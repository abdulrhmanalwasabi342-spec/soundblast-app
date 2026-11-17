import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../state/app_state.dart';
import '../widgets/common.dart';

/// Sign in with GitHub, using the backend's own OAuth flow
/// (server/_core/githubAuth.ts):
///   GET https://soundblast.onrender.com/api/auth/github
///     → 302 to github.com/login/oauth/authorize
///     → GET /api/auth/github/callback
///     → sets the httpOnly `sound_local_session` cookie, 302 to /
///
/// The flow is a pure web redirect flow with no deep-link/token hand-off,
/// so the app runs it in an in-app WebView and then reads the session
/// cookie out of the WebView's cookie jar into the app's own tRPC client.
/// The cookie is httpOnly — JavaScript can never see it; only the
/// platform cookie manager can. If GitHub login is not configured on the
/// server, the start URL returns 503 and the screen reports that.
class GitHubOAuthScreen extends StatefulWidget {
  const GitHubOAuthScreen({super.key});

  @override
  State<GitHubOAuthScreen> createState() => _GitHubOAuthScreenState();
}

class _GitHubOAuthScreenState extends State<GitHubOAuthScreen> {
  static const _site = 'https://soundblast.onrender.com';
  late final WebViewController _controller;
  bool _checking = false;
  bool _done = false;
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
                  'Could not load the sign-in page (${err.description}). Check your connection and try again.');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('$_site/api/auth/github'));
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
            'GitHub sign-in cookie extraction is Android-only.');
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
                'GitHub sign-in did not create a session. Please try again.';
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
      appBar: AppBar(title: const Text('Sign in with GitHub')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'You will sign in with GitHub in this window. When GitHub sends you back to SoundBlast, the app signs you in automatically.',
              style:
                  const TextStyle(color: SbColors.muted, fontSize: 13),
            ),
          ),
          if (_note != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(_note!,
                  style: const TextStyle(color: SbColors.danger)),
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
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text(
                          "I've signed in — check my account"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
