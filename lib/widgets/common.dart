import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../api/models.dart';
import '../l10n/app_localizations.dart';

/// Shorthand for the current language's strings: `context.l10n.home`.
extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// SoundBlast dark theme — read exactly from the website
/// (client/src/index.css + the screens):
/// page bg #050508, sections #07070c, brand pink #ee0faf (primary button,
/// hearts, highlights), pink light #ff61c6/#ff74c8, purple #9b0fee/#9574ff,
/// gold eyebrow #f4c778, blue #0d9eef secondary. Text white, secondary
/// white/55–66. Font Vazirmatn (UI, weights 400/700/900); display headings
/// Playfair Display. Radius 0.5rem base; buttons rounded-xl; cards
/// rounded-[1.45rem]; hero card rounded-[2rem]; mini player rounded-[1.35rem].
class SbColors {
  static const background = Color(0xFF050508);
  static const section = Color(0xFF07070C);
  static const surface = Color(0xFF0D0D1A);
  static const surface2 = Color(0xFF151020);
  static const card = Color(0xFF0F0F14);
  static const border = Color(0xFF23232E);
  static const inputBorder = Color(0xFF2C2C2C);
  static const text = Color(0xFFFFFFFF);
  static const muted = Color(0xFF9CA3AF);
  static const faint = Color(0xFF6B7280);
  static const accent = Color(0xFFEE0FAF); // website primary
  static const accentPink = Color(0xFFFF61C6);
  static const accentPinkLight = Color(0xFFFF74C8);
  static const accentPinkPale = Color(0xFFFF7ACE);
  static const purple = Color(0xFF9B0FEE);
  static const purpleLight = Color(0xFF9574FF);
  static const purpleDeep = Color(0xFF6649ED);
  static const gold = Color(0xFFF4C778);
  static const blue = Color(0xFF0D9EEF);
  static const danger = Color(0xFFEF4444);
  static const success = Color(0xFF22C55E);
}

ThemeData sbTheme() {
  const fontFamily = 'Vazirmatn';
  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: SbColors.background,
    primaryColor: SbColors.accent,
    colorScheme: const ColorScheme.dark(
      primary: SbColors.accent,
      secondary: SbColors.purpleLight,
      surface: SbColors.surface,
      error: SbColors.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: SbColors.background,
      foregroundColor: SbColors.text,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: SbColors.text,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: SbColors.surface,
      selectedItemColor: SbColors.accent,
      unselectedItemColor: SbColors.muted,
      type: BottomNavigationBarType.fixed,
    ),
    cardColor: SbColors.card,
    dividerColor: SbColors.border,
    chipTheme: const ChipThemeData(
      backgroundColor: SbColors.surface2,
      selectedColor: SbColors.accent,
      labelStyle: TextStyle(color: SbColors.text),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F0F0F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SbColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SbColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SbColors.accent),
      ),
      labelStyle: const TextStyle(color: SbColors.muted),
      hintStyle: const TextStyle(color: SbColors.muted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SbColors.accent,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: SbColors.accentPinkLight),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SbColors.text,
        side: const BorderSide(color: SbColors.inputBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: SbColors.surface2,
      contentTextStyle: TextStyle(color: SbColors.text),
    ),
  );
}

/// Gold uppercase eyebrow label, as the website's section headers use it:
/// 11px, semibold, letter-spacing 0.28em, gold #f4c778.
class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: SbColors.gold,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 3.0,
      ),
    );
  }
}

/// Display heading in Playfair Display — the website's .font-display
/// (h1/h2), weight 900.
class DisplayTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign align;
  const DisplayTitle(this.text,
      {super.key, this.fontSize = 32, this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: SbColors.text,
        height: 1.05,
      ),
    );
  }
}

/// Primary website button: pink bg, white text, rounded-xl, h-10.
class SbPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const SbPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }
}

String formatCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}

String formatPlays(int n) => '${formatCount(n)} plays';

class CoverImage extends StatelessWidget {
  final String? url;
  final double size;
  final double radius;
  final IconData fallbackIcon;
  const CoverImage({
    super.key,
    required this.url,
    this.size = 56,
    this.radius = 10,
    this.fallbackIcon = Icons.music_note,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: SbColors.surface2,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(fallbackIcon, color: SbColors.muted, size: size * 0.45),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: size,
          height: size,
          color: SbColors.surface2,
          child: Icon(fallbackIcon, color: SbColors.muted),
        ),
        errorWidget: (_, __, ___) => Container(
          width: size,
          height: size,
          color: SbColors.surface2,
          child: Icon(fallbackIcon, color: SbColors.muted),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle!,
                        style: const TextStyle(
                            color: SbColors.muted, fontSize: 13)),
                  ),
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See all',
                  style: TextStyle(color: SbColors.accent)),
            ),
        ],
      ),
    );
  }
}

/// A feature that exists in the app but cannot run yet, shown disabled with
/// the concrete reason (gated_feature_visibility skill).
class GatedFeature extends StatelessWidget {
  final String label;
  final String reason;
  final IconData icon;
  const GatedFeature({
    super.key,
    required this.label,
    required this.reason,
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.65,
      child: ListTile(
        leading: Icon(icon, color: SbColors.muted),
        title: Text(label),
        subtitle: Text(reason,
            style: const TextStyle(color: SbColors.muted, fontSize: 12)),
        trailing: const Icon(Icons.lock_outline, size: 18, color: SbColors.muted),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(reason)),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: SbColors.muted),
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style:
                    const TextStyle(color: SbColors.muted, fontSize: 14),
                textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 48, color: SbColors.muted),
            const SizedBox(height: 12),
            Text(message,
                style:
                    const TextStyle(color: SbColors.muted, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback? onPlay;
  final Widget? trailing;
  final int? rank;
  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.onPlay,
    this.trailing,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          CoverImage(url: song.imageUrl),
          if (onPlay != null)
            Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPlay,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
      title: Text(song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        [
          song.artist,
          if (song.durationLabel.isNotEmpty) song.durationLabel,
          if (song.playCount > 0) formatPlays(song.playCount),
        ].join(' • '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: SbColors.muted, fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank != null)
            Text('#$rank',
                style: const TextStyle(
                    color: SbColors.accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          if (trailing != null) trailing!,
        ],
      ),
      onTap: onTap,
    );
  }
}

class ArtistCard extends StatelessWidget {
  final ArtistProfile artist;
  final VoidCallback onTap;
  const ArtistCard({super.key, required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: artist.imageUrl ?? '',
                width: 104,
                height: 104,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 104,
                  height: 104,
                  color: SbColors.surface2,
                  child: const Icon(Icons.person,
                      size: 44, color: SbColors.muted),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(artist.stageName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                if (artist.verified)
                  const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Icon(Icons.verified,
                        size: 15, color: SbColors.accent),
                  ),
              ],
            ),
            Text('${formatCount(artist.followerCount)} followers',
                style:
                    const TextStyle(color: SbColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

Future<bool> confirmDialog(BuildContext context,
    {required String title, required String message}) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: SbColors.surface,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm')),
      ],
    ),
  );
  return res == true;
}
