import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/common.dart';

/// Onboarding — the website's three-screen first-visit intro.
/// "Enter SoundBlast" marks onboarding done (local flag, same as the web).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  static const _pages = [
    (
      icon: Icons.music_note,
      title: 'Feel the beat.',
      body:
          'SoundBlast is a home for independent music — discover new songs, follow the artists you love, and keep everything in one place.',
    ),
    (
      icon: Icons.people,
      title: 'Follow artists.',
      body:
          'Get notified when artists you follow release new songs and share posts. Your feed grows with the music you love.',
    ),
    (
      icon: Icons.mic,
      title: 'Are you an artist?',
      body:
          'Publish your own songs, build albums, and reach listeners — right from your phone. Sign up as an artist to start.',
    ),
  ];

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<void> _enter() async {
    await context.read<AppState>().setOnboarded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _enter,
                child: const Text('Skip',
                    style: TextStyle(color: SbColors.muted)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _page,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (ctx, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: SbColors.surface2,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(p.icon,
                              size: 56, color: SbColors.accent),
                        ),
                        const SizedBox(height: 32),
                        Text(p.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        Text(p.body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: SbColors.muted, fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _index == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _index == i
                        ? SbColors.accent
                        : SbColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_index < _pages.length - 1) {
                      _page.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    } else {
                      _enter();
                    }
                  },
                  child: Text(
                      _index < _pages.length - 1 ? 'Next' : 'Enter SoundBlast'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _enter();
                Navigator.of(context).pushNamed('/login');
              },
              child: const Text('I already have an account — Log in'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Login (website /login) — email + password via localAuth.login.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _login() async {
    final state = context.read<AppState>();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final err = await state.login(
          _email.text.trim(), _password.text);
      if (!mounted) return;
      if (err != null) {
        setState(() => _error = err);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (_) => false);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          const Center(
            child: Text('SoundBlast',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Welcome back.',
                style: TextStyle(color: SbColors.muted, fontSize: 16)),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!,
                  style: const TextStyle(color: SbColors.danger)),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _busy ? null : _login,
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Log in'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/forgot-password'),
            child: const Text('Forgot password?'),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? ",
                  style: TextStyle(color: SbColors.muted)),
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed('/signup'),
                child: const Text('Sign up',
                    style: TextStyle(
                        color: SbColors.accent,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider(color: SbColors.border)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('or continue with',
                    style: TextStyle(color: SbColors.muted, fontSize: 13)),
              ),
              Expanded(child: Divider(color: SbColors.border)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/oauth/github'),
              icon: const Icon(Icons.code),
              label: const Text('Continue with GitHub'),
            ),
          ),
          const SizedBox(height: 8),
          const GatedFeature(
            label: 'Continue with Google',
            reason:
                'Google sign-in is not available on the SoundBlast server yet — it needs a new server route and a Google Cloud OAuth client. Email sign-in works today.',
            icon: Icons.g_mobiledata,
          ),
        ],
      ),
    );
  }
}

/// Signup (website /signup) — name, email, password, role (listener/artist),
/// stage name for artists, optional avatar photo (uploaded before signup,
/// exactly like the website's pre-signup avatar upload).
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _stageName = TextEditingController();
  String _role = 'user';
  bool _policy = false;
  bool _busy = false;
  String? _error;
  String? _avatarUrl;
  String? _avatarName;
  bool _uploadingAvatar = false;

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;
    if (bytes.length > 5 * 1024 * 1024) {
      showSnack(context, 'The photo exceeds 5MB.');
      return;
    }
    setState(() => _uploadingAvatar = true);
    try {
      final url = await context.read<AppState>().api.signupAvatarUpload(
            base64Data: base64Encode(bytes),
            fileName: file.name,
            fileType: 'image/${file.extension ?? 'jpeg'}',
          );
      if (!mounted) return;
      setState(() {
        _avatarUrl = url;
        _avatarName = file.name;
      });
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _signup() async {
    final state = context.read<AppState>();
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.length < 8) {
      setState(() => _error =
          'Enter your name, a valid email, and a password of at least 8 characters.');
      return;
    }
    if (_role == 'artist' && _stageName.text.trim().isEmpty) {
      setState(() => _error = 'Artists need a stage name.');
      return;
    }
    if (!_policy) {
      setState(
          () => _error = 'Please accept the Terms & Privacy Policy.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final err = await state.signup(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        role: _role,
        stageName: _role == 'artist' ? _stageName.text.trim() : null,
        imageUrl: _avatarUrl,
      );
      if (!mounted) return;
      if (err != null) {
        setState(() => _error = err);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (_) => false);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _stageName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: Text('Join SoundBlast',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: _uploadingAvatar ? null : _pickAvatar,
              child: CircleAvatar(
                radius: 44,
                backgroundColor: SbColors.surface2,
                backgroundImage: _avatarUrl != null
                    ? NetworkImage(_avatarUrl!)
                    : null,
                child: _avatarUrl == null
                    ? (_uploadingAvatar
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.add_a_photo,
                            color: SbColors.muted))
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(_avatarName ?? 'Add a profile photo (optional)',
                style: const TextStyle(color: SbColors.muted, fontSize: 13)),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Your name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            decoration:
                const InputDecoration(labelText: 'Password (min 8 characters)'),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          const Text('I am joining as:',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'user',
                  label: Text('Listener'),
                  icon: Icon(Icons.headphones)),
              ButtonSegment(
                  value: 'artist',
                  label: Text('Artist'),
                  icon: Icon(Icons.mic)),
            ],
            selected: {_role},
            onSelectionChanged: (s) => setState(() => _role = s.first),
          ),
          if (_role == 'artist') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _stageName,
              decoration:
                  const InputDecoration(labelText: 'Stage name'),
            ),
          ],
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _policy,
            onChanged: (v) => setState(() => _policy = v ?? false),
            title: const Text(
                'I accept the Terms & Privacy Policy',
                style: TextStyle(fontSize: 14)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/policy'),
            child: const Text('Read the Terms, Privacy & Permissions'),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!,
                  style: const TextStyle(color: SbColors.danger)),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _busy ? null : _signup,
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Create account'),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? ',
                  style: TextStyle(color: SbColors.muted)),
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed('/login'),
                child: const Text('Log in',
                    style: TextStyle(
                        color: SbColors.accent,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider(color: SbColors.border)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('or sign up with',
                    style: TextStyle(color: SbColors.muted, fontSize: 13)),
              ),
              Expanded(child: Divider(color: SbColors.border)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/oauth/github'),
              icon: const Icon(Icons.code),
              label: const Text('Continue with GitHub'),
            ),
          ),
          const SizedBox(height: 8),
          const GatedFeature(
            label: 'Continue with Google',
            reason:
                'Google sign-in is not available on the SoundBlast server yet — it needs a new server route and a Google Cloud OAuth client. Email sign-up works today.',
            icon: Icons.g_mobiledata,
          ),
        ],
      ),
    );
  }
}

/// Forgot password (website /forgot-password).
/// The website itself states: "Password-reset email is not configured for
/// SoundBlast yet. To protect your account, this app will not pretend that
/// a reset message was sent." — the app says exactly the same, honestly.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.lock_reset,
                size: 56, color: SbColors.accent),
            const SizedBox(height: 24),
            const Text('Reset your password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const Text(
              'Password-reset email is not configured for SoundBlast yet. To protect your account, this app will not pretend that a reset message was sent.',
              style: TextStyle(color: SbColors.muted, fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you lost access to your account, contact SoundBlast support from the Contact page and include the email address of your account.',
              style: TextStyle(color: SbColors.muted, fontSize: 15),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/contact'),
                child: const Text('Contact support'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
