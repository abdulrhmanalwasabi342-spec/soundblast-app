import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/common.dart';

/// Sign in with GitHub, in the system browser — never a website inside the
/// app.
///
///   GET https://soundblast.onrender.com/api/auth/github?app=1
///     → 302 to github.com/login/oauth/authorize (opens in the browser)
///     → GET /api/auth/github/callback
///     → 302 to soundblast://oauth?code=… (the app reopens automatically)
///     → localAuth.exchangeAppCode swaps the one-time code for the session
///       cookie, exactly like email/password login.
///
/// The browser's cookies never reach the app, which is why the server hands
/// back a single-use code instead of signing the browser session in. The
/// previous in-app WebView flow is gone: it showed the Render deploy page
/// whenever the server was restarting, and a website inside the app is not
/// how sign-in should feel.
class GitHubOAuthScreen extends StatefulWidget {
  const GitHubOAuthScreen({super.key});

  @override
  State<GitHubOAuthScreen> createState() => _GitHubOAuthScreenState();
}

class _GitHubOAuthScreenState extends State<GitHubOAuthScreen> {
  static const _site = 'https://soundblast.onrender.com';
  bool _busy = false;
  bool _done = false;
  String? _note;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (_busy || _done) return;
    setState(() {
      _busy = true;
      _note = null;
    });
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: '$_site/api/auth/github?app=1',
        callbackUrlScheme: 'soundblast',
      );
      if (!mounted) return;
      final code = Uri.tryParse(result)?.queryParameters['code'];
      if (code == null || code.isEmpty) {
        throw Exception('GitHub did not return a sign-in code.');
      }
      final state = context.read<AppState>();
      await state.api.exchangeAppCode(code);
      final user = await state.api.me();
      if (user == null) {
        throw Exception('GitHub sign-in did not create a session.');
      }
      state.setUser(user);
      await state.refreshLibrary();
      if (!mounted) return;
      setState(() => _done = true);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    } on PlatformException catch (e) {
      // The user closed the browser tab without signing in.
      if (mounted) {
        setState(() {
          _busy = false;
          _note = e.code == 'CANCELED'
              ? 'Sign-in was cancelled. Tap Retry to try again.'
              : 'Could not open the browser (${e.message}). Check your connection and try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _note = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with GitHub')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.open_in_browser,
                size: 56, color: SbColors.accent),
            const SizedBox(height: 24),
            const Text(
              'GitHub opens in your browser. Sign in there, and you come straight back to SoundBlast — no website inside the app.',
              textAlign: TextAlign.center,
              style: TextStyle(color: SbColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            if (_busy) const CircularProgressIndicator(),
            if (_note != null) ...[
              Text(_note!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: SbColors.danger)),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _start, child: const Text('Retry')),
            ],
            if (!_busy && _note == null)
              ElevatedButton(
                  onPressed: _start,
                  child: const Text('Open GitHub sign-in')),
          ],
        ),
      ),
    );
  }
}
