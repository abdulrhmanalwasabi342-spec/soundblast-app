import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/common.dart';

/// Permission prompts in SoundBlast appear ONCE only, at the point of need,
/// with a short in-app explanation BEFORE the system dialog.
///
/// Rules (Shadow's rule, implemented exactly):
///  - Never ask on launch, never nag.
///  - First need: show the in-app explanation, then the system dialog once.
///  - If granted: never ask again.
///  - If denied once: the explanation may be shown and the system dialog
///    asked ONE more time at most.
///  - If denied twice, or permanently denied: NEVER re-prompt. Show a calm
///    in-app note with a button that opens the app settings instead.
class PermissionFlow {
  static const _mediaAskedKey = 'sb_perm_media_asked';
  static const _notifAskedKey = 'sb_perm_notif_asked';

  static Future<SharedPreferences> _prefs() =>
      SharedPreferences.getInstance();

  static Future<int> _askedCount(String key) async {
    final prefs = await _prefs();
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> _bumpAsked(String key) async {
    final prefs = await _prefs();
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }

  /// Android SDK version (for the media-permission split).
  static Future<int> androidSdk() async {
    if (!Platform.isAndroid) return 0;
    final info = await DeviceInfoPlugin().androidInfo;
    return info.version.sdkInt;
  }

  /// The media permission for this Android version: READ_MEDIA_AUDIO on
  /// Android 13+ (SDK 33+), READ_EXTERNAL_STORAGE on older versions.
  static Future<Permission> mediaPermission() async {
    final sdk = await androidSdk();
    return sdk >= 33 ? Permission.audio : Permission.storage;
  }

  static Future<bool> isMediaGranted() async {
    final perm = await mediaPermission();
    return await perm.status.isGranted;
  }

  /// Ask for the on-device media permission, following the once-only rule.
  /// Returns true when the permission is granted.
  /// Shows the in-app explanation first; never calls the system dialog more
  /// than twice in total across the life of the app.
  static Future<bool> requestMedia(BuildContext context) async {
    final perm = await mediaPermission();
    final status = await perm.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied || status.isRestricted) return false;

    final asked = await _askedCount(_mediaAskedKey);
    if (asked >= 2) return false; // already asked twice — never again

    if (asked == 0) {
      final goAhead = await _showRationale(
        context,
        title: context.l10n.permMediaTitle,
        body:
            context.l10n.permMediaBody,
        actionLabel: context.l10n.permAllowAccess,
      );
      if (goAhead != true) return false;
    } else {
      // Denied once: one short explanation, then the second (and last) ask.
      final goAhead = await _showRationale(
        context,
        title: context.l10n.permAccessOffTitle,
        body:
            context.l10n.permAccessOffBody,
        actionLabel: context.l10n.permAskAgain,
      );
      if (goAhead != true) return false;
    }

    await _bumpAsked(_mediaAskedKey);
    final result = await perm.request();
    return result.isGranted;
  }

  static Future<bool> isNotificationGranted() async {
    if (!Platform.isAndroid) return true;
    final sdk = await androidSdk();
    if (sdk < 33) return true; // permission did not exist before Android 13
    return await Permission.notification.status.isGranted;
  }

  /// Ask for the notification permission (media controls in the notification
  /// shade), once only, at first play. If denied, audio keeps playing — only
  /// the shade controls are missing.
  static Future<bool> requestNotifications(BuildContext context) async {
    if (!Platform.isAndroid) return true;
    final sdk = await androidSdk();
    if (sdk < 33) return true;
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied || status.isRestricted) return false;

    final asked = await _askedCount(_notifAskedKey);
    if (asked >= 2) return false;

    final goAhead = await _showRationale(
      context,
      title: context.l10n.permNotifTitle,
      body:
          context.l10n.permNotifBody,
      actionLabel: context.l10n.permShowPlayerControls,
    );
    if (goAhead != true) return false;
    await _bumpAsked(_notifAskedKey);
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  /// Calm in-app note shown when a permission can no longer be asked for:
  /// no re-prompt, just an explanation + a button to app settings.
  static Widget permissionBlockedNote(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SbColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: SbColors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: SbColors.muted)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: openAppSettings,
            icon: const Icon(Icons.settings, size: 18),
            label: Text(context.l10n.openAppSettings),
          ),
        ],
      ),
    );
  }

  static Future<bool?> _showRationale(
    BuildContext context, {
    required String title,
    required String body,
    required String actionLabel,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: SbColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(body,
                  style:
                      const TextStyle(color: SbColors.muted, fontSize: 14)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(actionLabel),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(context.l10n.notNow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
