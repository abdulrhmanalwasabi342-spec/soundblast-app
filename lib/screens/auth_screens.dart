import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../widgets/auth_shell.dart';
import '../widgets/common.dart';

/// Onboarding — the website's three-screen first-visit intro.
/// "Enter SoundBlast" marks onboarding done (local flag, same as the web).

/// "Continue with Google" — Google forbids OAuth in an embedded WebView
/// (it answers 403 disallowed_useragent), so this opens the system browser
/// (Chrome Custom Tab) and Google returns to the app on
/// soundblast://oauth?code=…; the code is exchanged for a session via
/// localAuth.exchangeAppCode. Pre-flight: the start URL must 302 to
/// accounts.google.com — anything else (e.g. the server's 503 while the
/// Google keys are not set yet) keeps the button honestly gated with the
/// "not set up" message instead of opening a dead page.
Future<void> signInWithGoogle(BuildContext context) async {
  final state = context.read<AppState>();
  final l10n = context.l10n;
  const startUrl = 'https://soundblast.onrender.com/api/auth/google?app=1';
  // Pre-flight through the app's (Cronet) transport, not a raw socket
  // client: the start URL must end at Google's sign-in page. The server
  // 503s while the Google keys are not set yet, so anything but a 200
  // keeps the button honestly gated instead of opening a dead page.
  final status =
      await state.api.client.getStatus('/api/auth/google?app=1');
  final up = status == 200;
  if (!context.mounted) return;
  if (!up) {
    showSnack(context, l10n.authGoogleNotSetup);
    return;
  }
  try {
    final result = await FlutterWebAuth2.authenticate(
      url: startUrl,
      callbackUrlScheme: 'soundblast',
    );
    final code = Uri.parse(result).queryParameters['code'];
    if (code == null || code.isEmpty) {
      if (context.mounted) showSnack(context, l10n.authSessionFailed);
      return;
    }
    final ok = await state.api.exchangeAppCode(code);
    if (!ok) {
      if (context.mounted) showSnack(context, l10n.authSessionFailed);
      return;
    }
    final user = await state.api.me();
    if (user != null) state.setUser(user);
    await state.refreshLibrary();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  } on PlatformException {
    // The user closed the browser tab — nothing to do.
  } catch (_) {
    if (context.mounted) showSnack(context, l10n.authSessionFailed);
  }
}
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  /// Onboarding pages, built from the current language (not const, so
  /// the language switch rebuilds them).
  List<({IconData icon, String title, String body})> _pages(
          AppLocalizations l) =>
      [
        (
          icon: Icons.music_note,
          title: l.onboardingBeat,
          body: l.onboardingBeatBody,
        ),
        (
          icon: Icons.people,
          title: l.onboardingFollow,
          body: l.onboardingFollowBody,
        ),
        (
          icon: Icons.mic,
          title: l.onboardingArtist,
          body: l.onboardingArtistBody,
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
      // The website's onboarding stage: the anime backdrop art, full
      // stage, dimmed so the text stays readable.
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding-anime.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.35),
                    SbColors.background.withValues(alpha: 0.92),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _enter,
                child: Text(context.l10n.skip,
                    style: TextStyle(color: SbColors.muted)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _page,
                itemCount: _pages(context.l10n).length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (ctx, i) {
                  final p = _pages(context.l10n)[i];
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
                _pages(context.l10n).length,
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
                    if (_index < _pages(context.l10n).length - 1) {
                      _page.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    } else {
                      _enter();
                    }
                  },
                  child: Text(
                      _index < _pages(context.l10n).length - 1 ? context.l10n.next : context.l10n.authEnter),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _enter();
                Navigator.of(context).pushNamed('/login');
              },
              child: Text(context.l10n.authAlreadyHaveAccount),
            ),
            const SizedBox(height: 24),
          ],
        ),
          ),
        ],
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
  @override
  void initState() {
    super.initState();
    // Wake the server while the user types their credentials: the
    // backend sleeps after 15 idle minutes, and a login tap on a
    // sleeping server pays the whole 30-90s cold start. Covers the
    // case where the app has been open (guest) long enough for the
    // server to fall asleep again after AppState.init()'s warm-up.
    unawaited(
        context.read<AppState>().api.client.getStatus('/login'));
  }

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
        // login() returns a code, not a message: map it to the localized
        // string here so Arabic users never see English.
        setState(() => _error = switch (err) {
              'suspended' => context.l10n.accountSuspended,
              'exists' => context.l10n.accountExists,
              _ => context.l10n.authInvalidCredentials,
            });
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (_) => false);
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e, context.l10n));
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
                Center(
                  child: GradientText(
                    context.l10n.authWelcomeBack,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    context.l10n.authLoginSub,
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
                AuthLabel(context.l10n.authEmail),
                AuthTextField(
                  controller: _email,
                  icon: Icons.mail_outline,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: _login,
                ),
                const SizedBox(height: 16),
                AuthLabel(context.l10n.authPassword),
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
                    child: Text(
                      context.l10n.authForgotPasswordQ,
                      style: TextStyle(
                        color: Color(0xFFF0ABFC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AuthGradientButton(
                  label: context.l10n.login,
                  icon: Icons.favorite,
                  busy: _busy,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),
                AuthDivider(context.l10n.authOrContinue),
                const SizedBox(height: 16),
                AuthOutlineButton(
                  label: context.l10n.authContinueGithub,
                  icon: FontAwesomeIcons.github,
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/oauth/github'),
                ),
                const SizedBox(height: 12),
                AuthOutlineButton(
                  label: context.l10n.authCreateNew,
                  icon: Icons.auto_awesome,
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed('/signup'),
                ),
                const SizedBox(height: 12),
                AuthOutlineButton(
                  label: context.l10n.authContinueGoogle,
                  icon: FontAwesomeIcons.google,
                  onPressed: () => signInWithGoogle(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              context.l10n.authWelcomeBackSub,
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
      showSnack(context, context.l10n.authPhotoTooBig);
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
            context.l10n.authPhotoRetry);
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
          context.l10n.authEnterDetails);
      return;
    }
    if (_role == 'artist' && _stageName.text.trim().isEmpty) {
      setState(() => _error = context.l10n.authArtistNeedsStage);
      return;
    }
    if (!_policy) {
      setState(
          () => _error = context.l10n.authAcceptTermsFirst);
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
        setState(() => _error = switch (err) {
              'exists' => context.l10n.accountExists,
              'stageName' => context.l10n.authArtistNeedsStage,
              _ => context.l10n.createAccountFailed,
            });
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (_) => false);
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e, context.l10n));
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
                Center(
                  child: GradientText(
                    context.l10n.joinTitle,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    context.l10n.joinSubtitle,
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
                      _avatarName ?? context.l10n.authAddPhoto,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13)),
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  AuthErrorBanner(_error!),
                  const SizedBox(height: 16),
                ],
                AuthLabel(context.l10n.authYourName),
                AuthTextField(
                  controller: _name,
                  icon: Icons.person_outline,
                  hint: context.l10n.authYourName,
                ),
                const SizedBox(height: 16),
                AuthLabel(context.l10n.authEmail),
                AuthTextField(
                  controller: _email,
                  icon: Icons.mail_outline,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AuthLabel(context.l10n.authPassword),
                AuthTextField(
                  controller: _password,
                  icon: Icons.lock_outline,
                  hint: context.l10n.authPasswordHint,
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
                Text(context.l10n.authJoiningAs,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                        value: 'user',
                        label: Text(context.l10n.authListener),
                        icon: Icon(Icons.headphones)),
                    ButtonSegment(
                        value: 'artist',
                        label: Text(context.l10n.authArtist),
                        icon: Icon(Icons.mic)),
                  ],
                  selected: {_role},
                  onSelectionChanged: (s) =>
                      setState(() => _role = s.first),
                ),
                if (_role == 'artist') ...[
                  const SizedBox(height: 16),
                  AuthLabel(context.l10n.authStageName),
                  AuthTextField(
                    controller: _stageName,
                    icon: Icons.mic,
                    hint: context.l10n.authStageName,
                  ),
                ],
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _policy,
                  onChanged: (v) => setState(() => _policy = v ?? false),
                  title: Text(context.l10n.authAcceptTerms,
                      style: TextStyle(fontSize: 14)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/policy'),
                  child:
                      Text(context.l10n.authReadTerms),
                ),
                const SizedBox(height: 8),
                AuthGradientButton(
                  label: context.l10n.authCreateAccount,
                  icon: Icons.auto_awesome,
                  busy: _busy,
                  onPressed: _signup,
                ),
                const SizedBox(height: 20),
                AuthDivider(context.l10n.authOrSignupWith),
                const SizedBox(height: 16),
                AuthOutlineButton(
                  label: context.l10n.authContinueGithub,
                  icon: FontAwesomeIcons.github,
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/oauth/github'),
                ),
                const SizedBox(height: 12),
                AuthOutlineButton(
                  label: context.l10n.login,
                  icon: Icons.login,
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed('/login'),
                ),
                const SizedBox(height: 12),
                AuthOutlineButton(
                  label: context.l10n.authContinueGoogle,
                  icon: FontAwesomeIcons.google,
                  onPressed: () => signInWithGoogle(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              context.l10n.authJoinSub,
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
      appBar: AppBar(title: Text(context.l10n.authForgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.lock_reset,
                size: 56, color: SbColors.accent),
            const SizedBox(height: 24),
            Text(context.l10n.resetPassword,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(
              context.l10n.passwordResetNotConfigured,
              style: TextStyle(color: SbColors.muted, fontSize: 15),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.lostAccessContactSupport,
              style: TextStyle(color: SbColors.muted, fontSize: 15),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/contact'),
                child: Text(context.l10n.authContactSupport),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.authBackToLogin),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
