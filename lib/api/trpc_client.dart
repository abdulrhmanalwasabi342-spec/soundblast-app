import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// SoundBlast backend: the live website backend at
/// https://soundblast.onrender.com — the Flutter app reuses it, it does not
/// run its own server.
///
/// tRPC v11 + superjson over HTTP (verified live 2026-11-17 with curl):
///   Query:    GET  /api/trpc/<router>.<procedure>?batch=1&input={"0":{"json":{...}}}
///   Mutation: POST /api/trpc/<router>.<procedure>?batch=1  body {"0":{"json":{...}}}
///   No-input query: input={"0":{}}.
///   Response: [{"result":{"data":{"json": <value>}}}]  (dates arrive as ISO
///   strings inside the json payload; the superjson "meta" block is ignored)
///   Error:    [{"error":{"json":{"message": "...", "code": -32603,
///             "data": {"code": "INTERNAL_SERVER_ERROR", "httpStatus": 500}}}}]
///   Session: TWO httpOnly cookies can carry identity (the tRPC context
///   checks both): `app_session_id` (Manus OAuth session) and
///   `sound_local_session` (local email/password + GitHub OAuth — set by
///   signLocalSession, server/_core/localSession.ts). Both are persisted in
///   secure storage and sent on every request.
class ApiException implements Exception {
  final String message;
  final int? httpStatus;
  final String? code;
  const ApiException(this.message, {this.httpStatus, this.code});
  @override
  String toString() => message;
}

class TrpcClient {
  static const String baseUrl = 'https://soundblast.onrender.com';
  static const _sessionCookieNames = {
    'app_session_id',
    'sound_local_session',
  };
  static const _cookieKey = 'sb_session_cookies';

  final http.Client _http;
  final FlutterSecureStorage _storage;
  final Map<String, String> _cookies = {}; // name -> "name=value"

  TrpcClient({http.Client? httpClient, FlutterSecureStorage? storage})
      : _http = httpClient ?? http.Client(),
        _storage = storage ?? const FlutterSecureStorage();

  Future<void> init() async {
    final raw = await _storage.read(key: _cookieKey);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        for (final e in map.entries) {
          _cookies[e.key] = e.value.toString();
        }
      } catch (_) {}
    }
  }

  bool get hasSession => _cookies.isNotEmpty;

  Future<void> clearSession() async {
    _cookies.clear();
    await _storage.delete(key: _cookieKey);
  }

  /// Import a session cookie captured elsewhere (e.g. the GitHub OAuth
  /// WebView, where the httpOnly cookie lives in the WebView's jar).
  Future<void> importCookie(String name, String value) async {
    if (!_sessionCookieNames.contains(name) || value.isEmpty) return;
    _cookies[name] = '$name=$value';
    await _persist();
  }

  Future<void> _persist() async {
    await _storage.write(key: _cookieKey, value: jsonEncode(_cookies));
  }

  void _storeCookieFromHeaders(Map<String, String> headers) {
    // package:http joins multiple Set-Cookie headers with ", " — and cookie
    // values here are JWTs (no commas/semicolons), so a regex per cookie
    // name is safe despite the Expires dates in the same string.
    final setCookie = headers['set-cookie'];
    if (setCookie == null) return;
    var changed = false;
    for (final name in _sessionCookieNames) {
      final m =
          RegExp('${RegExp.escape(name)}=([^;,]+)').firstMatch(setCookie);
      if (m != null) {
        final value = m.group(1)!.trim();
        if (value.isNotEmpty) {
          _cookies[name] = '$name=$value';
          changed = true;
        }
      }
    }
    if (changed) unawaited(_persist());
  }

  Map<String, String> get _headers {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_cookies.isNotEmpty) {
      h['Cookie'] = _cookies.values.join('; ');
    }
    return h;
  }

  dynamic _unwrap(http.Response res, String path) {
    dynamic decoded;
    try {
      decoded = jsonDecode(res.body);
    } on FormatException {
      throw ApiException(
        'Server returned an unreadable response (${res.statusCode}) for $path',
        httpStatus: res.statusCode,
      );
    }
    if (decoded is! List || decoded.isEmpty) {
      throw ApiException('Unexpected server response for $path',
          httpStatus: res.statusCode);
    }
    final first = decoded[0];
    if (first is! Map) {
      throw ApiException('Unexpected server response for $path',
          httpStatus: res.statusCode);
    }
    if (first.containsKey('error')) {
      final err = first['error'];
      final ej = err is Map ? err['json'] : null;
      final msg = ej is Map
          ? (ej['message']?.toString() ?? 'Server error')
          : 'Server error';
      final data = ej is Map ? ej['data'] : null;
      final code = data is Map ? data['code']?.toString() : null;
      final status = data is Map
          ? (data['httpStatus'] is num
              ? (data['httpStatus'] as num).toInt()
              : res.statusCode)
          : res.statusCode;
      throw ApiException(_friendly(msg), httpStatus: status, code: code);
    }
    final result = first['result'];
    if (result is Map) {
      final data = result['data'];
      if (data is Map && data.containsKey('json')) return data['json'];
      return data;
    }
    return null;
  }

  /// Shorten raw DB/driver errors into something a user can read.
  static String _friendly(String msg) {
    // The server's auth error carries a raw numeric code (10001) that means
    // nothing to a user — every screen shows a plain login prompt instead.
    if (msg.contains('Please login (10001)')) {
      return 'Please log in to continue.';
    }
    if (msg.startsWith('Failed query:')) {
      return 'The server database returned an error. Please try again later.';
    }
    if (msg.contains('Invalid input')) return 'Invalid input: $msg';
    return msg;
  }

  /// GET query. Pass `input: null` for procedures without input.
  Future<dynamic> query(String path, [Map<String, dynamic>? input]) async {
    final inputJson = input == null
        ? '{"0":{}}'
        : jsonEncode({
            '0': {'json': input}
          });
    final uri = Uri.parse(
        '$baseUrl/api/trpc/$path?batch=1&input=${Uri.encodeComponent(inputJson)}');
    http.Response res;
    try {
      res = await _http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 180));
    } catch (e) {
      throw ApiException(
          'Could not reach SoundBlast. Check your connection and try again. ($e)');
    }
    _storeCookieFromHeaders(res.headers);
    if (res.statusCode == 401 || res.statusCode == 403) {
      // Session expired/invalid — clear so the app falls back to guest.
      if (res.statusCode == 401) await clearSession();
    }
    return _unwrap(res, path);
  }

  /// POST mutation. Pass `input: null` for procedures without input.
  Future<dynamic> mutation(String path, [Map<String, dynamic>? input]) async {
    final uri = Uri.parse('$baseUrl/api/trpc/$path?batch=1');
    final body = jsonEncode({
      '0': {'json': input ?? {}}
    });
    http.Response res;
    try {
      res = await _http
          .post(uri, headers: _headers, body: body)
          .timeout(const Duration(seconds: 180));
    } catch (e) {
      throw ApiException(
          'Could not reach SoundBlast. Check your connection and try again. ($e)');
    }
    _storeCookieFromHeaders(res.headers);
    return _unwrap(res, path);
  }

  void dispose() => _http.close();
}
