import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../state/app_state.dart';
import '../widgets/common.dart';

/// Sign in with GitHub, inside the app (server/_core/githubAuth.ts):
///   GET https://soundblast.onrender.com/api/auth/github
///     → 302 to github.com/login/oauth/authorize
///     → GET /api/auth/github/callback
///     → sets the httpOnly `sound_local_session` cookie, 302 to /
///
/// The GitHub page appears in an in-app window and the account is created
/// in the app — GitHub's own rules mean its sign-in page has to appear
/// somewhere, and inside the app is the way (no system browser, no leaving
/// SoundBlast). The flow is a pure web redirect flow with no deep-link/
/// token hand-off, so the app reads the session cookie out of the WebView's
/// cookie jar into its own tRPC client. The cookie is httpOnly — JavaScript
/// can never see it; only the platform cookie manager can.
///
/// Before the window opens, the app checks the server is actually up: on
/// Render's free tier the server sleeps and serves a placeholder page while
/// it restarts, and loading the window then showed that page instead of
/// GitHub. If the check fails, the screen says so and offers Retry instead
/// of opening a broken page. If GitHub login is not configured on the
/// server, the start URL returns 503 and the screen reports that.
class GitHubOAuthScreen extends StatefulWidget {
  const GitHubOAuthScreen({super.key});

  @override
  State<GitHubOAuthScreen> createState() => _GitHubOAuthScreenState();
}

class _GitHubOAuthScreenState extends State<GitHubOAuthScreen> {
  static const _site = 'https://soundblast.onrender.com';
  late final WebViewController _controller;
  bool _busy = false;
  bool _checking = false;
  bool _done = false;
  bool _webViewReady = false;
  String? _note;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            final url = change.url;
            if (url != null) _maybeFinished(url);
          },
          onPageFinished: (url) => _maybeFinished(url),
          onWebResourceError: (err) {
            if (mounted) {
              setState(() => _note =
                  context.l10n.oauthLoadFailed(err.description));
            }
          },
        ),
      );
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  /// The start URL must 302 to github.com — anything else (Render's
  /// placeholder page while the server restarts, a 503, a timeout) means
  /// the window would not show GitHub.
  Future<bool> _serverUp() async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 70);
    try {
      final request =
          await client.getUrl(Uri.parse('$_site/api/auth/github'));
      request.followRedirects = false;
      final response =
          await request.close().timeout(const Duration(seconds: 70));
      await response.drain<void>();
      final location = response.headers.value('location') ?? '';
      return response.statusCode == 302 && location.contains('github.com');
    } catch (_) {
      return false;
    } finally {
      client.close();
    }
  }

  Future<void> _start() async {
    if (_busy || _done || _webViewReady) return;
    setState(() {
      _busy = true;
      _note = null;
    });
    final up = await _serverUp();
    if (!mounted) return;
    if (!up) {
      setState(() {
        _busy = false;
        _note =
            context.l10n.oauthServerStarting;
      });
      return;
    }
    setState(() {
      _busy = false;
      _webViewReady = true;
    });
    await _controller.loadRequest(Uri.parse('$_site/api/auth/github'));
  }

  void _maybeFinished(String url) {
    if (_done || _checking) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    // Back on the SoundBlast site after GitHub (the callback 302s to /).
    // github.com pages are ignored — the user is still signing in there.
    if (uri.host == 'soundblast.onrender.com') {
      _checkSession();
    }
  }

  Future<void> _checkSession() async {
    if (_checking || _done) return;
    setState(() => _checking = true);
    try {
      // The cross-platform WebViewCookieManager no longer exposes
      // getCookies (webview_flutter 4.13+); the Android implementation
      // does. The cookie is httpOnly, so only the platform cookie manager
      // can read it — JavaScript never can.
      if (WebViewPlatform.instance is! AndroidWebViewPlatform) {
        throw UnsupportedError(
            context.l10n.oauthAndroidOnly);
      }
      final manager = WebViewCookieManager();
      final androidManager =
          manager.platform as AndroidWebViewCookieManager;
      final cookies = await androidManager.getCookies(Uri.parse(_site));
      var found = false;
      for (final c in cookies) {
        if (c.name == 'sound_local_session' && c.value.isNotEmpty) {
          await context
              .read<AppState>()
              .trpc
              .importCookie(c.name, c.value);
          found = true;
        }
      }
      if (!found) {
        // Cookie may be set but not yet visible, or the user landed on the
        // home page without signing in. Leave the WebView open.
        if (mounted) setState(() => _checking = false);
        return;
      }
      final state = context.read<AppState>();
      final user = await state.api.me();
      if (user == null) {
        if (mounted) {
          setState(() {
            _checking = false;
            _note =
                context.l10n.oauthNoSession;
          });
        }
        return;
      }
      state.setUser(user);
      await state.refreshLibrary();
      if (!mounted) return;
      setState(() => _done = true);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _checking = false;
          _note = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.oauthTitle)),
      body: !_webViewReady
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_busy) const CircularProgressIndicator(),
                    if (_note != null) ...[
                      Text(_note!,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: SbColors.danger)),
                      const SizedBox(height: 16),
                      OutlinedButton(
                          onPressed: _start, child: Text(context.l10n.retry)),
                    ],
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    context.l10n.oauthInAppNote,
                    style: const TextStyle(
                        color: SbColors.muted, fontSize: 13),
                  ),
                ),
                if (_note != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(_note!,
                              style: const TextStyle(
                                  color: SbColors.danger)),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          // The GitHub page can fail to load on a flaky connection
                          // (e.g. QUIC errors) — retry instead of a dead screen.
                          onPressed: () {
                            setState(() => _note = null);
                            _controller.loadRequest(
                                Uri.parse('$_site/api/auth/github'));
                          },
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: WebViewWidget(controller: _controller)),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checking ? null : _checkSession,
                        child: _checking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2))
                            : Text(
                                context.l10n.oauthCheckAccount),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
