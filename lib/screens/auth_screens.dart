import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/auth_shell.dart';
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
  bool _showPassword = false;
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
    final canPop = Navigator.of(context).canPop();
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (canPop)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          const SizedBox(height: 8),
          const AuthBrandHeader(),
          const SizedBox(height: 24),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: GradientText(
                    'Welcome back.',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Log in to continue listening.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white54, fontSize: 14, height: 1.5),
                  ),
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  AuthErrorBanner(_error!),
                  const SizedBox(height: 16),
                ],
                const AuthLabel('Email'),
                AuthTextField(
                  controller: _email,
                  icon: Icons.mail_outline,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: _login,
                ),
                const SizedBox(height: 16),
                const AuthLabel('Password'),
                AuthTextField(
                  controller: _password,
                  icon: Icons.lock_outline,
                  hint: '••••••••',
                  obscureText: !_showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                      color: Colors.white54,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  onSubmitted: _login,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/forgot-password'),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFFF0ABFC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AuthGradientButton(
                  label: 'Log in',
                  icon: Icons.favorite,
                  busy: _busy,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),
                const AuthDivider('or continue with'),
                const SizedBox(height: 16),
                AuthOutlineButton(
                  label: 'Continue with GitHub',
                  icon: FontAwesomeIcons.github,
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/oauth/github'),
                ),
                const SizedBox(height: 12),
                AuthOutlineButton(
                  label: 'Create a new account',
                  icon: Icons.auto_awesome,
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed('/signup'),
                ),
                const SizedBox(height: 12),
                const GatedFeature(
                  label: 'Continue with Google',
                  reason: "Google sign-in isn't set up on the server yet.",
                  icon: FontAwesomeIcons.google,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'SoundBlast · welcome back',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
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
  bool _showPassword = false;
  String? _error;
  String? _avatarUrl;
  String? _avatarName;
  // The picked photo itself: shown in the circle the moment it is picked,
  // even while the upload is still running (or the server is unreachable).
  Uint8List? _avatarBytes;
  PlatformFile? _avatarFile;
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
    // Show the photo immediately — the upload runs in the background and
    // must never be the reason the circle stays empty.
    setState(() {
      _avatarBytes = bytes;
      _avatarFile = file;
      _avatarName = file.name;
      _uploadingAvatar = true;
    });
    await _uploadAvatar();
    if (mounted) setState(() => _uploadingAvatar = false);
  }

  /// Upload the picked photo; returns its URL (or null). Retried at signup
  /// time when the first attempt failed, so a photo picked while the server
  /// was unreachable still lands on the account.
  Future<String?> _uploadAvatar() async {
    final bytes = _avatarBytes;
    final file = _avatarFile;
    if (bytes == null || file == null) return null;
    try {
      final url = await context.read<AppState>().api.signupAvatarUpload(
            base64Data: base64Encode(bytes),
            fileName: file.name,
            fileType: 'image/${file.extension ?? 'jpeg'}',
          );
      if (!mounted) return url;
      setState(() => _avatarUrl = url);
      return url;
    } catch (e) {
      if (mounted) {
        showSnack(context,
            'Photo upload failed — it will be retried when you create the account.');
      }
      return null;
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
    // The photo was picked but its upload never completed (e.g. the server
    // was unreachable at pick time): try once more now so the account gets
    // the photo.
    if (_avatarBytes != null && _avatarUrl == null) {
      await _uploadAvatar();
    }
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
    final canPop = Navigator.of(context).canPop();
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (canPop)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          const SizedBox(height: 8),
          const AuthBrandHeader(),
          const SizedBox(height: 24),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: GradientText(
                    'Join SoundBlast',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Create your account to start listening.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white54, fontSize: 14, height: 1.5),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _uploadingAvatar ? null : _pickAvatar,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: SbColors.surface2,
                      // Local photo first: it is there the moment the user
                      // picks it, even if the upload has not finished.
                      backgroundImage: _avatarBytes != null
                          ? MemoryImage(_avatarBytes!)
                          : (_avatarUrl != null
                              ? NetworkImage(_avatarUrl!)
                              : null),
                      child: _avatarBytes == null && _avatarUrl == null
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
                  child: Text(
                      _avatarName ?? 'Add a profile photo (optional)',
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13)),
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  AuthErrorBanner(_error!),
                  const SizedBox(height: 16),
                ],
                const AuthLabel('Your name'),
                AuthTextField(
                  controller: _name,
                  icon: Icons.person_outline,
                  hint: 'Your name',
                ),
                const SizedBox(height: 16),
                const AuthLabel('Email'),
                AuthTextField(
                  controller: _email,
                  icon: Icons.mail_outline,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const AuthLabel('Password'),
                AuthTextField(
                  controller: _password,
                  icon: Icons.lock_outline,
                  hint: 'At least 8 characters',
                  obscureText: !_showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                      color: Colors.white54,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
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
                  onSelectionChanged: (s) =>
                      setState(() => _role = s.first),
                ),
                if (_role == 'artist') ...[
                  const SizedBox(height: 16),
                  const AuthLabel('Stage name'),
                  AuthTextField(
                    controller: _stageName,
                    icon: Icons.mic,
                    hint: 'Stage name',
                  ),
                ],
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _policy,
                  onChanged: (v) => setState(() => _policy = v ?? false),
                  title: const Text('I accept the Terms & Privacy Policy',
                      style: TextStyle(fontSize: 14)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/policy'),
                  child:
                      const Text('Read the Terms, Privacy & Permissions'),
                ),
                const SizedBox(height: 8),
                AuthGradientButton(
                  label: 'Create account',
                  icon: Icons.auto_awesome,
                  busy: _busy,
                  onPressed: _signup,
                ),
                const SizedBox(height: 20),
                const AuthDivider('or sign up with'),
                const SizedBox(height: 16),
                AuthOutlineButton(
                  label: 'Continue with GitHub',
                  icon: FontAwesomeIcons.github,
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/oauth/github'),
                ),
                const SizedBox(height: 12),
                AuthOutlineButton(
                  label: 'Log in',
                  icon: Icons.login,
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed('/login'),
                ),
                const SizedBox(height: 12),
                const GatedFeature(
                  label: 'Continue with Google',
                  reason: "Google sign-up isn't set up on the server yet.",
                  icon: FontAwesomeIcons.google,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'SoundBlast · join the music',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
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
