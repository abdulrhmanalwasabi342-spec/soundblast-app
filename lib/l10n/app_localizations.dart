import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @aboutBody1.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast is a music platform for independent artists and the listeners who love them. Discover new songs, follow artists, build playlists, and — if you make music — publish your own releases and reach new ears.'**
  String get aboutBody1;

  /// No description provided for @aboutBody2.
  ///
  /// In en, this message translates to:
  /// **'Everything you hear here is published by real artists on the platform. Likes, comments, follows and playlists are shared across the website and this app, because both talk to the same SoundBlast backend.'**
  String get aboutBody2;

  /// No description provided for @aboutSoundBlast.
  ///
  /// In en, this message translates to:
  /// **'About SoundBlast'**
  String get aboutSoundBlast;

  /// No description provided for @accessOffBody.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast can play the songs already on this phone — even without internet.'**
  String get accessOffBody;

  /// No description provided for @accessOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Access to on-device songs is off'**
  String get accessOffTitle;

  /// No description provided for @activateAccount.
  ///
  /// In en, this message translates to:
  /// **'Activate account'**
  String get activateAccount;

  /// No description provided for @activateArtist.
  ///
  /// In en, this message translates to:
  /// **'Activate artist'**
  String get activateArtist;

  /// No description provided for @activationCasesHint.
  ///
  /// In en, this message translates to:
  /// **'Artist accounts that have not completed activation.'**
  String get activationCasesHint;

  /// No description provided for @activationStatus.
  ///
  /// In en, this message translates to:
  /// **'Activation: {status}'**
  String activationStatus(String status);

  /// No description provided for @addMissingToContinue.
  ///
  /// In en, this message translates to:
  /// **'Add {missing} to continue.'**
  String addMissingToContinue(Object missing);

  /// No description provided for @addSongsFromMenu.
  ///
  /// In en, this message translates to:
  /// **'Add songs from any song menu (⋮ → Add to playlist).'**
  String get addSongsFromMenu;

  /// No description provided for @addSongsHint.
  ///
  /// In en, this message translates to:
  /// **'Add songs from the on-device library (⋮ on any song).'**
  String get addSongsHint;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @addedToName.
  ///
  /// In en, this message translates to:
  /// **'Added to {name}.'**
  String addedToName(String name);

  /// No description provided for @addedToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Added to \"{name}\"'**
  String addedToPlaylist(String name);

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @adminDefaultNotification.
  ///
  /// In en, this message translates to:
  /// **'A message from SoundBlast'**
  String get adminDefaultNotification;

  /// No description provided for @adminRestricted.
  ///
  /// In en, this message translates to:
  /// **'This area is restricted to SoundBlast administrators.'**
  String get adminRestricted;

  /// No description provided for @adminShort.
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get adminShort;

  /// No description provided for @adminTabAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get adminTabAnalytics;

  /// No description provided for @adminTabArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get adminTabArtists;

  /// No description provided for @adminTabContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get adminTabContent;

  /// No description provided for @adminTabHomePlatform.
  ///
  /// In en, this message translates to:
  /// **'Home & platform'**
  String get adminTabHomePlatform;

  /// No description provided for @adminTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get adminTabOverview;

  /// No description provided for @adminTabSystemSafety.
  ///
  /// In en, this message translates to:
  /// **'System & safety'**
  String get adminTabSystemSafety;

  /// No description provided for @adminTabUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminTabUsers;

  /// No description provided for @adminsOnly.
  ///
  /// In en, this message translates to:
  /// **'Admins only'**
  String get adminsOnly;

  /// No description provided for @albumNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Album name (optional)'**
  String get albumNameOptional;

  /// No description provided for @albumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Album not found'**
  String get albumNotFound;

  /// No description provided for @albumsAppearHint.
  ///
  /// In en, this message translates to:
  /// **'Albums appear here once artists publish releases.'**
  String get albumsAppearHint;

  /// No description provided for @albumsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No albums} =1{1 album} other{{count} albums}}'**
  String albumsCount(int count);

  /// No description provided for @allArtists.
  ///
  /// In en, this message translates to:
  /// **'All artists'**
  String get allArtists;

  /// No description provided for @allSongs.
  ///
  /// In en, this message translates to:
  /// **'All songs'**
  String get allSongs;

  /// No description provided for @allTracks.
  ///
  /// In en, this message translates to:
  /// **'All tracks'**
  String get allTracks;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast'**
  String get appName;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.18 — Android app'**
  String get appVersionLabel;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @artistAccountsOnly.
  ///
  /// In en, this message translates to:
  /// **'Artist accounts only'**
  String get artistAccountsOnly;

  /// No description provided for @artistActivationCases.
  ///
  /// In en, this message translates to:
  /// **'Artist activation cases'**
  String get artistActivationCases;

  /// No description provided for @artistNotFound.
  ///
  /// In en, this message translates to:
  /// **'Artist not found'**
  String get artistNotFound;

  /// No description provided for @artistPageMissing.
  ///
  /// In en, this message translates to:
  /// **'This artist page does not exist.'**
  String get artistPageMissing;

  /// No description provided for @artistStats.
  ///
  /// In en, this message translates to:
  /// **'{followers} followers • {songs} songs • {plays} plays'**
  String artistStats(String followers, String plays, String songs);

  /// No description provided for @artistStudio.
  ///
  /// In en, this message translates to:
  /// **'Artist Studio'**
  String get artistStudio;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @artistsAppearHint.
  ///
  /// In en, this message translates to:
  /// **'Artists appear here once they sign up and publish.'**
  String get artistsAppearHint;

  /// No description provided for @artistsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No artists} =1{1 artist} other{{count} artists}}'**
  String artistsCount(int count);

  /// No description provided for @artistsToExplore.
  ///
  /// In en, this message translates to:
  /// **'Artists to explore'**
  String get artistsToExplore;

  /// No description provided for @artistsYouFollow.
  ///
  /// In en, this message translates to:
  /// **'Artists you follow'**
  String get artistsYouFollow;

  /// No description provided for @artworkAppearHint.
  ///
  /// In en, this message translates to:
  /// **'Song artwork appears here once songs with cover art are published.'**
  String get artworkAppearHint;

  /// No description provided for @audioSelected.
  ///
  /// In en, this message translates to:
  /// **'Audio selected'**
  String get audioSelected;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get auditLog;

  /// No description provided for @authAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms & Privacy Policy'**
  String get authAcceptTerms;

  /// No description provided for @authAcceptTermsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Privacy Policy.'**
  String get authAcceptTermsFirst;

  /// No description provided for @authAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a profile photo (optional)'**
  String get authAddPhoto;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account — Log in'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get authArtist;

  /// No description provided for @authArtistNeedsStage.
  ///
  /// In en, this message translates to:
  /// **'Artists need a stage name.'**
  String get authArtistNeedsStage;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get authBackToLogin;

  /// No description provided for @authContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get authContactSupport;

  /// No description provided for @authContinueGithub.
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get authContinueGithub;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get authCreateNew;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter SoundBlast'**
  String get authEnter;

  /// No description provided for @authEnterDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your name, a valid email, and a password of at least 8 characters.'**
  String get authEnterDetails;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get authForgotPassword;

  /// No description provided for @authForgotPasswordQ.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordQ;

  /// No description provided for @authGoogleNotSetup.
  ///
  /// In en, this message translates to:
  /// **'Google sign-up isn\'t set up on the server yet.'**
  String get authGoogleNotSetup;

  /// No description provided for @authJoinSub.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast · join the music'**
  String get authJoinSub;

  /// No description provided for @authJoiningAs.
  ///
  /// In en, this message translates to:
  /// **'I am joining as:'**
  String get authJoiningAs;

  /// No description provided for @authListener.
  ///
  /// In en, this message translates to:
  /// **'Listener'**
  String get authListener;

  /// No description provided for @authLoginSub.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue listening.'**
  String get authLoginSub;

  /// No description provided for @authOrContinue.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinue;

  /// No description provided for @authOrSignupWith.
  ///
  /// In en, this message translates to:
  /// **'or sign up with'**
  String get authOrSignupWith;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authPasswordHint;

  /// No description provided for @authPhotoRetry.
  ///
  /// In en, this message translates to:
  /// **'Photo upload failed — it will be retried when you create the account.'**
  String get authPhotoRetry;

  /// No description provided for @authPhotoTooBig.
  ///
  /// In en, this message translates to:
  /// **'The photo exceeds 5MB.'**
  String get authPhotoTooBig;

  /// No description provided for @authReadTerms.
  ///
  /// In en, this message translates to:
  /// **'Read the Terms, Privacy & Permissions'**
  String get authReadTerms;

  /// No description provided for @authSessionFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in did not create a session. Please try again.'**
  String get authSessionFailed;

  /// No description provided for @authStageName.
  ///
  /// In en, this message translates to:
  /// **'Stage name'**
  String get authStageName;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back.'**
  String get authWelcomeBack;

  /// No description provided for @authWelcomeBackSub.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast · welcome back'**
  String get authWelcomeBackSub;

  /// No description provided for @authYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authYourName;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioLabel;

  /// No description provided for @browseDeviceSongs.
  ///
  /// In en, this message translates to:
  /// **'Browse songs on this device'**
  String get browseDeviceSongs;

  /// No description provided for @browseGenres.
  ///
  /// In en, this message translates to:
  /// **'Browse genres'**
  String get browseGenres;

  /// No description provided for @browseMusic.
  ///
  /// In en, this message translates to:
  /// **'Browse music'**
  String get browseMusic;

  /// No description provided for @browseReleases.
  ///
  /// In en, this message translates to:
  /// **'Browse releases ↗'**
  String get browseReleases;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cannotPlayDeviceFile.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this file on your device. It may be corrupt, deleted, or in an unsupported format.'**
  String get cannotPlayDeviceFile;

  /// No description provided for @cannotPlaySong.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play this song. Check your connection and try again.'**
  String get cannotPlaySong;

  /// No description provided for @catAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get catAlbums;

  /// No description provided for @catArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get catArtists;

  /// No description provided for @catComposers.
  ///
  /// In en, this message translates to:
  /// **'Composers'**
  String get catComposers;

  /// No description provided for @catFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get catFolders;

  /// No description provided for @catGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get catGenres;

  /// No description provided for @catTracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get catTracks;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @chooseArtwork.
  ///
  /// In en, this message translates to:
  /// **'Choose release artwork (PNG, JPG, or WEBP)'**
  String get chooseArtwork;

  /// No description provided for @chooseAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Choose audio file (MP3, WAV, or M4A)'**
  String get chooseAudioFile;

  /// No description provided for @cleanLibraryIntegrity.
  ///
  /// In en, this message translates to:
  /// **'Clean library integrity'**
  String get cleanLibraryIntegrity;

  /// No description provided for @clearEngagement.
  ///
  /// In en, this message translates to:
  /// **'Clear engagement'**
  String get clearEngagement;

  /// No description provided for @clearFavorites.
  ///
  /// In en, this message translates to:
  /// **'Clear favorites [NEW]'**
  String get clearFavorites;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @clearVisitorHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear visitor history'**
  String get clearVisitorHistory;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @commentsModeration.
  ///
  /// In en, this message translates to:
  /// **'Comments moderation'**
  String get commentsModeration;

  /// No description provided for @composersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No composers} =1{1 composer} other{{count} composers}}'**
  String composersCount(int count);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmRights.
  ///
  /// In en, this message translates to:
  /// **'I confirm I own the rights to publish this song.'**
  String get confirmRights;

  /// No description provided for @confirmRightsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please confirm you own the rights to publish this song.'**
  String get confirmRightsFirst;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactBody.
  ///
  /// In en, this message translates to:
  /// **'Questions, problems, or a report about content on SoundBlast? Send feedback from the Feedback page — it goes straight to the SoundBlast team — or visit the website contact page.'**
  String get contactBody;

  /// No description provided for @contactInboxGap.
  ///
  /// In en, this message translates to:
  /// **'The website has no contact-messages inbox endpoint yet — contact currently goes through Feedback. Listed as a named gap in README.md.'**
  String get contactInboxGap;

  /// No description provided for @contactMessagesInbox.
  ///
  /// In en, this message translates to:
  /// **'Contact messages inbox [NEW]'**
  String get contactMessagesInbox;

  /// No description provided for @copyrightBody.
  ///
  /// In en, this message translates to:
  /// **'If content on SoundBlast infringes your rights, send a copyright report from the Feedback page (choose the copyright report category). Reports are reviewed by the SoundBlast administrators.'**
  String get copyrightBody;

  /// No description provided for @copyrightReports.
  ///
  /// In en, this message translates to:
  /// **'Copyright reports'**
  String get copyrightReports;

  /// No description provided for @couldNotOpenWebsite.
  ///
  /// In en, this message translates to:
  /// **'Could not open the website.'**
  String get couldNotOpenWebsite;

  /// No description provided for @couldNotReadFiles.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected files.'**
  String get couldNotReadFiles;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @createFirstPlaylistHint.
  ///
  /// In en, this message translates to:
  /// **'Create your first playlist and add songs to it.'**
  String get createFirstPlaylistHint;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create playlist'**
  String get createPlaylist;

  /// No description provided for @createPlaylistDraft.
  ///
  /// In en, this message translates to:
  /// **'Create playlist (as draft)'**
  String get createPlaylistDraft;

  /// No description provided for @createPlaylistHint.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist and add songs to it.'**
  String get createPlaylistHint;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create user'**
  String get createUser;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @dangerZoneNote.
  ///
  /// In en, this message translates to:
  /// **'Bulk actions delete platform data permanently. Each one needs its confirmation phrase typed in.'**
  String get dangerZoneNote;

  /// No description provided for @dashboardGlance.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast at a glance'**
  String get dashboardGlance;

  /// No description provided for @dashboardGuestNote.
  ///
  /// In en, this message translates to:
  /// **'Platform totals above are public. Your library, uploads and studio need an account.'**
  String get dashboardGuestNote;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'Delete ALL accounts'**
  String get deleteAllAccounts;

  /// No description provided for @deleteAllComments.
  ///
  /// In en, this message translates to:
  /// **'Delete ALL comments'**
  String get deleteAllComments;

  /// No description provided for @deleteAllCommentsOn.
  ///
  /// In en, this message translates to:
  /// **'Delete all comments on \"{title}\"?'**
  String deleteAllCommentsOn(String title);

  /// No description provided for @deleteAllItsComments.
  ///
  /// In en, this message translates to:
  /// **'Delete all its comments'**
  String get deleteAllItsComments;

  /// No description provided for @deleteAllPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Delete ALL playlists'**
  String get deleteAllPlaylists;

  /// No description provided for @deleteComment.
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get deleteComment;

  /// No description provided for @deleteCommentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this comment?'**
  String get deleteCommentConfirm;

  /// No description provided for @deleteComments.
  ///
  /// In en, this message translates to:
  /// **'Delete comments'**
  String get deleteComments;

  /// No description provided for @deleteDownload.
  ///
  /// In en, this message translates to:
  /// **'Delete download'**
  String get deleteDownload;

  /// No description provided for @deleteDownloadConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete the offline copy of \"{title}\"? The song stays on SoundBlast.'**
  String deleteDownloadConfirm(String title);

  /// No description provided for @deleteOauthUser.
  ///
  /// In en, this message translates to:
  /// **'Delete OAuth user'**
  String get deleteOauthUser;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist'**
  String get deletePlaylist;

  /// No description provided for @deletePlaylistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? The songs stay on this device.'**
  String deletePlaylistConfirm(String name);

  /// No description provided for @deletePlaylistConfirmPerm.
  ///
  /// In en, this message translates to:
  /// **'Delete this playlist permanently?'**
  String get deletePlaylistConfirmPerm;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete post'**
  String get deletePost;

  /// No description provided for @deletePostConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this post?'**
  String get deletePostConfirm;

  /// No description provided for @deleteRelease.
  ///
  /// In en, this message translates to:
  /// **'Delete release'**
  String get deleteRelease;

  /// No description provided for @deleteReleaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this release permanently?'**
  String get deleteReleaseConfirm;

  /// No description provided for @deleteSong.
  ///
  /// In en, this message translates to:
  /// **'Delete song'**
  String get deleteSong;

  /// No description provided for @deleteSongConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" permanently?'**
  String deleteSongConfirm(String title);

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get deleteUser;

  /// No description provided for @deleteUserConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this account permanently? The owner account can never be deleted.'**
  String get deleteUserConfirm;

  /// No description provided for @deleteVisitorHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all recorded visitor history?'**
  String get deleteVisitorHistoryConfirm;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @doneResult.
  ///
  /// In en, this message translates to:
  /// **'Done: {result}'**
  String doneResult(String result);

  /// No description provided for @downloadForOffline.
  ///
  /// In en, this message translates to:
  /// **'Download for offline'**
  String get downloadForOffline;

  /// No description provided for @downloadedAvailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Downloaded — available offline in Library → Downloaded.'**
  String get downloadedAvailableOffline;

  /// No description provided for @downloadedPlayOffline.
  ///
  /// In en, this message translates to:
  /// **'Downloaded — play offline'**
  String get downloadedPlayOffline;

  /// No description provided for @downloadedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved in the app — plays without internet'**
  String get downloadedSubtitle;

  /// No description provided for @downloadedTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloaded from SoundBlast'**
  String get downloadedTitle;

  /// No description provided for @downloadingSong.
  ///
  /// In en, this message translates to:
  /// **'Downloading {title}…'**
  String downloadingSong(String title);

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration: {time}'**
  String durationLabel(String time);

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editProfileArtistsOnly.
  ///
  /// In en, this message translates to:
  /// **'Profile editing is available for artist accounts.'**
  String get editProfileArtistsOnly;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get editUser;

  /// No description provided for @exploreMusic.
  ///
  /// In en, this message translates to:
  /// **'Explore music'**
  String get exploreMusic;

  /// No description provided for @featuredNow.
  ///
  /// In en, this message translates to:
  /// **'Featured now'**
  String get featuredNow;

  /// No description provided for @feedbackCopyrightReport.
  ///
  /// In en, this message translates to:
  /// **'Copyright report'**
  String get feedbackCopyrightReport;

  /// No description provided for @feedbackInbox.
  ///
  /// In en, this message translates to:
  /// **'Feedback inbox'**
  String get feedbackInbox;

  /// No description provided for @feedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'Bug reports, ideas, privacy requests and copyright reports all go to the SoundBlast team.'**
  String get feedbackIntro;

  /// No description provided for @feedbackMinChars.
  ///
  /// In en, this message translates to:
  /// **'Please write at least 10 characters.'**
  String get feedbackMinChars;

  /// No description provided for @feedbackPrivacyRequest.
  ///
  /// In en, this message translates to:
  /// **'Privacy request'**
  String get feedbackPrivacyRequest;

  /// No description provided for @feedbackSentThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks — your feedback was sent.'**
  String get feedbackSentThanks;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @foldersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No folders} =1{1 folder} other{{count} folders}}'**
  String foldersCount(int count);

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @followedArtistsNote.
  ///
  /// In en, this message translates to:
  /// **'New releases from these artists appear in your Notifications inbox.'**
  String get followedArtistsNote;

  /// No description provided for @followersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} followers'**
  String followersCount(String count);

  /// No description provided for @followersOnly.
  ///
  /// In en, this message translates to:
  /// **'Followers only'**
  String get followersOnly;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @freshFrom.
  ///
  /// In en, this message translates to:
  /// **'Fresh from'**
  String get freshFrom;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @galleryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Gallery is empty'**
  String get galleryEmpty;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @genresAppearHint.
  ///
  /// In en, this message translates to:
  /// **'Genres appear here once artists publish songs.'**
  String get genresAppearHint;

  /// No description provided for @genresCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No genres} =1{1 genre} other{{count} genres}}'**
  String genresCount(int count);

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get getInTouch;

  /// No description provided for @givePlaylistName.
  ///
  /// In en, this message translates to:
  /// **'Give your playlist a name.'**
  String get givePlaylistName;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get goHome;

  /// No description provided for @goToArtist.
  ///
  /// In en, this message translates to:
  /// **'Go to artist: {artist}'**
  String goToArtist(String artist);

  /// No description provided for @grantAdminOwner.
  ///
  /// In en, this message translates to:
  /// **'Grant admin (owner only)'**
  String get grantAdminOwner;

  /// No description provided for @guestMessage.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up to like songs, keep favorites, build playlists, upload music and follow artists.'**
  String get guestMessage;

  /// No description provided for @guestTitle.
  ///
  /// In en, this message translates to:
  /// **'You are browsing as a guest'**
  String get guestTitle;

  /// No description provided for @heroActionOrderHint.
  ///
  /// In en, this message translates to:
  /// **'Controls which action the Home hero button offers first.'**
  String get heroActionOrderHint;

  /// No description provided for @heroActionOrderSet.
  ///
  /// In en, this message translates to:
  /// **'Hero action order set to preset {n}.'**
  String heroActionOrderSet(int n);

  /// No description provided for @heroBody.
  ///
  /// In en, this message translates to:
  /// **'A focused home for releases, artist stories, and the tracks worth replaying. Built around the people making the music.'**
  String get heroBody;

  /// No description provided for @heroLine1.
  ///
  /// In en, this message translates to:
  /// **'Find the sound'**
  String get heroLine1;

  /// No description provided for @heroLine2.
  ///
  /// In en, this message translates to:
  /// **'that stays with'**
  String get heroLine2;

  /// No description provided for @heroLine3.
  ///
  /// In en, this message translates to:
  /// **'you.'**
  String get heroLine3;

  /// No description provided for @hideLyrics.
  ///
  /// In en, this message translates to:
  /// **'Hide lyrics'**
  String get hideLyrics;

  /// No description provided for @hideUnpublish.
  ///
  /// In en, this message translates to:
  /// **'Hide (unpublish)'**
  String get hideUnpublish;

  /// No description provided for @homeHeroActionOrder.
  ///
  /// In en, this message translates to:
  /// **'Home hero action order'**
  String get homeHeroActionOrder;

  /// No description provided for @homeSummaryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Home summary is unavailable on the server right now — showing songs directly.'**
  String get homeSummaryUnavailable;

  /// No description provided for @integrityEmptyPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Empty playlists'**
  String get integrityEmptyPlaylists;

  /// No description provided for @integrityOrphanPlaylistSongs.
  ///
  /// In en, this message translates to:
  /// **'Orphan playlist songs'**
  String get integrityOrphanPlaylistSongs;

  /// No description provided for @integrityRawPlayEvents.
  ///
  /// In en, this message translates to:
  /// **'Raw play events'**
  String get integrityRawPlayEvents;

  /// No description provided for @integrityRemovableEmptyPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Removable empty playlists'**
  String get integrityRemovableEmptyPlaylists;

  /// No description provided for @integritySongsMissingSize.
  ///
  /// In en, this message translates to:
  /// **'Songs missing size'**
  String get integritySongsMissingSize;

  /// No description provided for @joinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start listening.'**
  String get joinSubtitle;

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join SoundBlast'**
  String get joinTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @last7DaysPlays.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days: {plays} plays'**
  String last7DaysPlays(String plays);

  /// No description provided for @libraryCleanupDone.
  ///
  /// In en, this message translates to:
  /// **'Library cleanup done: {result}'**
  String libraryCleanupDone(String result);

  /// No description provided for @libraryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'The SoundBlast library is empty right now. Artists can publish the first songs from Upload.'**
  String get libraryEmptyHint;

  /// No description provided for @libraryIntegrity.
  ///
  /// In en, this message translates to:
  /// **'Library integrity'**
  String get libraryIntegrity;

  /// No description provided for @libraryLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Liked songs, favorites and playlists live in your account.'**
  String get libraryLoginMessage;

  /// No description provided for @libraryLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to see your library'**
  String get libraryLoginTitle;

  /// No description provided for @libraryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Library maintenance'**
  String get libraryMaintenance;

  /// No description provided for @likeAction.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeAction;

  /// No description provided for @likesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String likesCount(String count);

  /// No description provided for @listenWithIntent.
  ///
  /// In en, this message translates to:
  /// **'LISTEN WITH INTENT'**
  String get listenWithIntent;

  /// No description provided for @listenerCannotOpenStudio.
  ///
  /// In en, this message translates to:
  /// **'Your account is a listener account. Sign up as an artist to open the studio.'**
  String get listenerCannotOpenStudio;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginAsArtist.
  ///
  /// In en, this message translates to:
  /// **'Log in as an artist'**
  String get loginAsArtist;

  /// No description provided for @loginAsArtistUpload.
  ///
  /// In en, this message translates to:
  /// **'Log in as an artist to upload songs.'**
  String get loginAsArtistUpload;

  /// No description provided for @loginFirst.
  ///
  /// In en, this message translates to:
  /// **'Log in first'**
  String get loginFirst;

  /// No description provided for @loginForDashboard.
  ///
  /// In en, this message translates to:
  /// **'Log in for your personal dashboard'**
  String get loginForDashboard;

  /// No description provided for @loginPlaylistMessage.
  ///
  /// In en, this message translates to:
  /// **'Playlists belong to your account.'**
  String get loginPlaylistMessage;

  /// No description provided for @loginPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to see this playlist'**
  String get loginPlaylistTitle;

  /// No description provided for @loginPlaylistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to see playlists'**
  String get loginPlaylistsTitle;

  /// No description provided for @loginToComment.
  ///
  /// In en, this message translates to:
  /// **'Log in to comment.'**
  String get loginToComment;

  /// No description provided for @loginToCreatePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Log in to create a playlist.'**
  String get loginToCreatePlaylist;

  /// No description provided for @loginToFollow.
  ///
  /// In en, this message translates to:
  /// **'Log in to follow artists.'**
  String get loginToFollow;

  /// No description provided for @loginToLike.
  ///
  /// In en, this message translates to:
  /// **'Log in to like songs.'**
  String get loginToLike;

  /// No description provided for @loginToSaveFavorites.
  ///
  /// In en, this message translates to:
  /// **'Log in to save favorites.'**
  String get loginToSaveFavorites;

  /// No description provided for @loginToSeeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Log in to see notifications'**
  String get loginToSeeNotifications;

  /// No description provided for @loginToSendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Log in to send feedback.'**
  String get loginToSendFeedback;

  /// No description provided for @loginToSendFeedbackNote.
  ///
  /// In en, this message translates to:
  /// **'Log in to send feedback — it is filed under your account.'**
  String get loginToSendFeedbackNote;

  /// No description provided for @loginToUsePlaylists.
  ///
  /// In en, this message translates to:
  /// **'Log in to use playlists.'**
  String get loginToUsePlaylists;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out of SoundBlast on this device?'**
  String get logoutConfirm;

  /// No description provided for @lostAccessContactSupport.
  ///
  /// In en, this message translates to:
  /// **'If you lost access to your account, contact SoundBlast support from the Contact page and include the email address of your account.'**
  String get lostAccessContactSupport;

  /// No description provided for @lyrics.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyrics;

  /// No description provided for @maintenanceGap.
  ///
  /// In en, this message translates to:
  /// **'The website has no maintenance-mode endpoint — the app lists it as a named gap (see README.md). Use Render to stop the service if maintenance is needed.'**
  String get maintenanceGap;

  /// No description provided for @makeAdminOwner.
  ///
  /// In en, this message translates to:
  /// **'Make admin (owner only)'**
  String get makeAdminOwner;

  /// No description provided for @makeUser.
  ///
  /// In en, this message translates to:
  /// **'Make user'**
  String get makeUser;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @markRead.
  ///
  /// In en, this message translates to:
  /// **'Mark read'**
  String get markRead;

  /// No description provided for @markReviewed.
  ///
  /// In en, this message translates to:
  /// **'Mark reviewed'**
  String get markReviewed;

  /// No description provided for @markVerified.
  ///
  /// In en, this message translates to:
  /// **'Mark verified'**
  String get markVerified;

  /// No description provided for @marksOfLove.
  ///
  /// In en, this message translates to:
  /// **'{count} marks of love from the community'**
  String marksOfLove(String count);

  /// No description provided for @meetArtists.
  ///
  /// In en, this message translates to:
  /// **'Meet the artists'**
  String get meetArtists;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @messageLengthHint.
  ///
  /// In en, this message translates to:
  /// **'At least 10 characters, up to 2000.'**
  String get messageLengthHint;

  /// No description provided for @missingArtwork.
  ///
  /// In en, this message translates to:
  /// **'a cover image'**
  String get missingArtwork;

  /// No description provided for @missingAudio.
  ///
  /// In en, this message translates to:
  /// **'an audio file'**
  String get missingAudio;

  /// No description provided for @missingTitle.
  ///
  /// In en, this message translates to:
  /// **'the song title'**
  String get missingTitle;

  /// No description provided for @moodsGenres.
  ///
  /// In en, this message translates to:
  /// **'Moods & genres'**
  String get moodsGenres;

  /// No description provided for @mostFollowed.
  ///
  /// In en, this message translates to:
  /// **'Most followed on SoundBlast'**
  String get mostFollowed;

  /// No description provided for @mostPlayed7Days.
  ///
  /// In en, this message translates to:
  /// **'Most played in the last 7 days'**
  String get mostPlayed7Days;

  /// No description provided for @mostPlayedWeek.
  ///
  /// In en, this message translates to:
  /// **'Most played this week'**
  String get mostPlayedWeek;

  /// No description provided for @myPlaylistsOffline.
  ///
  /// In en, this message translates to:
  /// **'My playlists (offline)'**
  String get myPlaylistsOffline;

  /// No description provided for @myPosts.
  ///
  /// In en, this message translates to:
  /// **'My posts'**
  String get myPosts;

  /// No description provided for @myReleases.
  ///
  /// In en, this message translates to:
  /// **'My releases'**
  String get myReleases;

  /// No description provided for @mySongs.
  ///
  /// In en, this message translates to:
  /// **'My songs'**
  String get mySongs;

  /// No description provided for @navAddPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add playlist'**
  String get navAddPlaylist;

  /// No description provided for @navAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get navAlbums;

  /// No description provided for @navArtistPosts.
  ///
  /// In en, this message translates to:
  /// **'Artist Posts'**
  String get navArtistPosts;

  /// No description provided for @navArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get navArtists;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get navFeedback;

  /// No description provided for @navGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get navGenres;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navLikedSongs.
  ///
  /// In en, this message translates to:
  /// **'Liked Songs'**
  String get navLikedSongs;

  /// No description provided for @navMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navMenu;

  /// No description provided for @navMusicPlayer.
  ///
  /// In en, this message translates to:
  /// **'Music Player'**
  String get navMusicPlayer;

  /// No description provided for @navPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get navPlaylists;

  /// No description provided for @navProfileShort.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfileShort;

  /// No description provided for @navTrendingSongs.
  ///
  /// In en, this message translates to:
  /// **'Trending Songs'**
  String get navTrendingSongs;

  /// No description provided for @newInRoom.
  ///
  /// In en, this message translates to:
  /// **'New in the room'**
  String get newInRoom;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @newPasswordMin8.
  ///
  /// In en, this message translates to:
  /// **'New password (min 8)'**
  String get newPasswordMin8;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylist;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get newPost;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @nextFavouriteWaiting.
  ///
  /// In en, this message translates to:
  /// **'Your next favourite is waiting'**
  String get nextFavouriteWaiting;

  /// No description provided for @noAlbums.
  ///
  /// In en, this message translates to:
  /// **'No albums yet'**
  String get noAlbums;

  /// No description provided for @noArtistPosts.
  ///
  /// In en, this message translates to:
  /// **'Artists have not shared any public posts.'**
  String get noArtistPosts;

  /// No description provided for @noArtistPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No artist posts yet.'**
  String get noArtistPostsYet;

  /// No description provided for @noArtists.
  ///
  /// In en, this message translates to:
  /// **'No artists yet'**
  String get noArtists;

  /// No description provided for @noAudioFound.
  ///
  /// In en, this message translates to:
  /// **'No audio files found on this device.'**
  String get noAudioFound;

  /// No description provided for @noAuditEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No audit events yet.'**
  String get noAuditEventsYet;

  /// No description provided for @noCategorySongs.
  ///
  /// In en, this message translates to:
  /// **'No on-device songs in this category.'**
  String get noCategorySongs;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet — be the first to say something.'**
  String get noComments;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get noCommentsYet;

  /// No description provided for @noDownloads.
  ///
  /// In en, this message translates to:
  /// **'No downloads yet. Use ⋮ → Download for offline on any song.'**
  String get noDownloads;

  /// No description provided for @noDownloadsYet.
  ///
  /// In en, this message translates to:
  /// **'No downloads yet. Use ⋮ → Download for offline on any song.'**
  String get noDownloadsYet;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @noFeedbackYet.
  ///
  /// In en, this message translates to:
  /// **'No feedback yet.'**
  String get noFeedbackYet;

  /// No description provided for @noGenres.
  ///
  /// In en, this message translates to:
  /// **'No genres yet'**
  String get noGenres;

  /// No description provided for @noGenresEmpty.
  ///
  /// In en, this message translates to:
  /// **'No genres yet — the library is empty.'**
  String get noGenresEmpty;

  /// No description provided for @noLikedSongsYet.
  ///
  /// In en, this message translates to:
  /// **'No liked songs yet'**
  String get noLikedSongsYet;

  /// No description provided for @noLyrics.
  ///
  /// In en, this message translates to:
  /// **'No lyrics for this song'**
  String get noLyrics;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'When artists you follow release new songs or share posts, you will see it here.'**
  String get noNotificationsHint;

  /// No description provided for @noNotificationsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No notifications recorded yet.'**
  String get noNotificationsRecorded;

  /// No description provided for @noOauthUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No OAuth users yet.'**
  String get noOauthUsersYet;

  /// No description provided for @noOfflinePlaylists.
  ///
  /// In en, this message translates to:
  /// **'No offline playlists yet. Create one, then add songs with ⋮ on any on-device song.'**
  String get noOfflinePlaylists;

  /// No description provided for @noPendingActivation.
  ///
  /// In en, this message translates to:
  /// **'No pending activation cases.'**
  String get noPendingActivation;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get noPlaylists;

  /// No description provided for @noPlaylistsCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet — create one first.'**
  String get noPlaylistsCreateFirst;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPosts;

  /// No description provided for @noPublicSongsArtist.
  ///
  /// In en, this message translates to:
  /// **'No public songs from this artist yet.'**
  String get noPublicSongsArtist;

  /// No description provided for @noPublicSongsGenre.
  ///
  /// In en, this message translates to:
  /// **'No public songs in this genre right now.'**
  String get noPublicSongsGenre;

  /// No description provided for @noPublicSongsRelease.
  ///
  /// In en, this message translates to:
  /// **'No public songs in this release yet.'**
  String get noPublicSongsRelease;

  /// No description provided for @noReleasesYet.
  ///
  /// In en, this message translates to:
  /// **'No releases yet.'**
  String get noReleasesYet;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @noSlugSongs.
  ///
  /// In en, this message translates to:
  /// **'No {slug} songs yet'**
  String noSlugSongs(String slug);

  /// No description provided for @noSongsHere.
  ///
  /// In en, this message translates to:
  /// **'No songs here'**
  String get noSongsHere;

  /// No description provided for @noSongsInLibrary.
  ///
  /// In en, this message translates to:
  /// **'No songs in the library yet.'**
  String get noSongsInLibrary;

  /// No description provided for @noSongsMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No songs match this filter. Try another genre.'**
  String get noSongsMatchFilter;

  /// No description provided for @noSongsPublished.
  ///
  /// In en, this message translates to:
  /// **'You have not published any songs yet.'**
  String get noSongsPublished;

  /// No description provided for @noSongsShort.
  ///
  /// In en, this message translates to:
  /// **'No songs.'**
  String get noSongsShort;

  /// No description provided for @noSongsYet.
  ///
  /// In en, this message translates to:
  /// **'No songs yet'**
  String get noSongsYet;

  /// No description provided for @noTrending.
  ///
  /// In en, this message translates to:
  /// **'No trending songs yet'**
  String get noTrending;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No users yet.'**
  String get noUsersYet;

  /// No description provided for @noVisitorHistory.
  ///
  /// In en, this message translates to:
  /// **'No visitor history yet.'**
  String get noVisitorHistory;

  /// No description provided for @noneOption.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneOption;

  /// No description provided for @notFollowingArtists.
  ///
  /// In en, this message translates to:
  /// **'You are not following any artists yet.'**
  String get notFollowingArtists;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHere;

  /// No description provided for @nothingMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this device matches.'**
  String get nothingMatches;

  /// No description provided for @nothingMatchesQuery.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches \"{query}\" yet. Try a different song, artist or genre.'**
  String nothingMatchesQuery(String query);

  /// No description provided for @nothingPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get nothingPlaying;

  /// No description provided for @notifPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notifPreferences;

  /// No description provided for @notifPrefsBelongAccount.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences belong to your account.'**
  String get notifPrefsBelongAccount;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Notification sent.'**
  String get notificationSent;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'New releases from artists you follow arrive here.'**
  String get notificationsEmptyHint;

  /// No description provided for @notificationsState.
  ///
  /// In en, this message translates to:
  /// **'Notifications: {state}'**
  String notificationsState(String state);

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'NOW PLAYING'**
  String get nowPlaying;

  /// No description provided for @nowPlayingTitle.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlayingTitle;

  /// No description provided for @oauthAndroidOnly.
  ///
  /// In en, this message translates to:
  /// **'GitHub sign-in cookie extraction is Android-only.'**
  String get oauthAndroidOnly;

  /// No description provided for @oauthCheckAccount.
  ///
  /// In en, this message translates to:
  /// **'I\'ve signed in — check my account'**
  String get oauthCheckAccount;

  /// No description provided for @oauthInAppNote.
  ///
  /// In en, this message translates to:
  /// **'You will sign in with GitHub in this window. When GitHub sends you back to SoundBlast, the app signs you in automatically.'**
  String get oauthInAppNote;

  /// No description provided for @oauthLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the sign-in page ({error}). Check your connection and try again.'**
  String oauthLoadFailed(String error);

  /// No description provided for @oauthNoSession.
  ///
  /// In en, this message translates to:
  /// **'GitHub sign-in did not create a session. Please try again.'**
  String get oauthNoSession;

  /// No description provided for @oauthRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'role: {role}'**
  String oauthRoleLabel(String role);

  /// No description provided for @oauthServerStarting.
  ///
  /// In en, this message translates to:
  /// **'The server is starting or updating right now. Wait a moment and tap Retry — the GitHub page opens inside the app.'**
  String get oauthServerStarting;

  /// No description provided for @oauthTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with GitHub'**
  String get oauthTitle;

  /// No description provided for @oauthUsers.
  ///
  /// In en, this message translates to:
  /// **'OAuth users'**
  String get oauthUsers;

  /// No description provided for @offlineShowingCache.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline — showing the last saved library.'**
  String get offlineShowingCache;

  /// No description provided for @offlineShowingSaved.
  ///
  /// In en, this message translates to:
  /// **'You are offline — showing the last saved library.'**
  String get offlineShowingSaved;

  /// No description provided for @onDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Audio files already on your phone'**
  String get onDeviceSubtitle;

  /// No description provided for @onDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get onDeviceTitle;

  /// No description provided for @onThisDevice.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get onThisDevice;

  /// No description provided for @onboardingArtist.
  ///
  /// In en, this message translates to:
  /// **'Are you an artist?'**
  String get onboardingArtist;

  /// No description provided for @onboardingArtistBody.
  ///
  /// In en, this message translates to:
  /// **'Publish your own songs, build albums, and reach listeners — right from your phone. Sign up as an artist to start.'**
  String get onboardingArtistBody;

  /// No description provided for @onboardingBeat.
  ///
  /// In en, this message translates to:
  /// **'Feel the beat.'**
  String get onboardingBeat;

  /// No description provided for @onboardingBeatBody.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast is a home for independent music — discover new songs, follow the artists you love, and keep everything in one place.'**
  String get onboardingBeatBody;

  /// No description provided for @onboardingFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow artists.'**
  String get onboardingFollow;

  /// No description provided for @onboardingFollowBody.
  ///
  /// In en, this message translates to:
  /// **'Get notified when artists you follow release new songs and share posts. Your feed grows with the music you love.'**
  String get onboardingFollowBody;

  /// No description provided for @onlyArtistsUpload.
  ///
  /// In en, this message translates to:
  /// **'Only artist accounts can upload songs. Sign up as an artist to publish music.'**
  String get onlyArtistsUpload;

  /// No description provided for @onlyArtistsUploadListener.
  ///
  /// In en, this message translates to:
  /// **'Only artist accounts can upload songs. Your account is a listener account — create an artist account to publish music.'**
  String get onlyArtistsUploadListener;

  /// No description provided for @openAdmin.
  ///
  /// In en, this message translates to:
  /// **'Open Admin'**
  String get openAdmin;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @openArtistStudio.
  ///
  /// In en, this message translates to:
  /// **'Open Artist Studio'**
  String get openArtistStudio;

  /// No description provided for @openWebsite.
  ///
  /// In en, this message translates to:
  /// **'Open the SoundBlast website'**
  String get openWebsite;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @ownerNote.
  ///
  /// In en, this message translates to:
  /// **'The owner account (ADMIN_EMAIL) can never be demoted, suspended or deleted by another admin, and only the owner can grant admin to others.'**
  String get ownerNote;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This page does not exist on SoundBlast.'**
  String get pageNotFoundBody;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password (min 8)'**
  String get passwordMin8;

  /// No description provided for @passwordResetNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Password-reset email is not configured for SoundBlast yet. To protect your account, this app will not pretend that a reset message was sent.'**
  String get passwordResetNotConfigured;

  /// No description provided for @permAccessOffBody.
  ///
  /// In en, this message translates to:
  /// **'Without access to audio files, SoundBlast cannot list or play the songs stored on this device. Downloaded SoundBlast songs still work.\n\nYou can allow access now — this is the last time we will ask.'**
  String get permAccessOffBody;

  /// No description provided for @permAccessOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Access is still off'**
  String get permAccessOffTitle;

  /// No description provided for @permAllowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get permAllowAccess;

  /// No description provided for @permAskAgain.
  ///
  /// In en, this message translates to:
  /// **'Ask again'**
  String get permAskAgain;

  /// No description provided for @permMediaBody.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast can play the audio files already on this device — your downloaded songs and your own music library — even without internet.\n\nWe will ask for access to audio files on this device, only for playing your music. Nothing is uploaded.'**
  String get permMediaBody;

  /// No description provided for @permMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Play songs already on your phone'**
  String get permMediaTitle;

  /// No description provided for @permNotifBody.
  ///
  /// In en, this message translates to:
  /// **'When a song is playing, SoundBlast shows its player in the notification shade — title, artist, cover, and play / pause / next — so you can control it while the app is closed.\n\nWe will ask once to show notifications. If you skip it, music still plays; only the notification controls will be missing.'**
  String get permNotifBody;

  /// No description provided for @permNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the player in your notifications'**
  String get permNotifTitle;

  /// No description provided for @permShowPlayerControls.
  ///
  /// In en, this message translates to:
  /// **'Show player controls'**
  String get permShowPlayerControls;

  /// No description provided for @permanentlyDeletesData.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes the data and cannot be undone.'**
  String get permanentlyDeletesData;

  /// No description provided for @permissionDeclinedTwice.
  ///
  /// In en, this message translates to:
  /// **'You declined the audio permission twice, so SoundBlast will not ask again. You can still allow it any time in the app settings — downloaded SoundBlast songs keep working either way.'**
  String get permissionDeclinedTwice;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @permissionsBody.
  ///
  /// In en, this message translates to:
  /// **'The app asks for storage access only when you pick an audio file, artwork or profile photo to upload. Playback continues while the app is in the background so your music is not interrupted.'**
  String get permissionsBody;

  /// No description provided for @photoSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Photo saved on this phone. It will sync to your profile when storage is ready.'**
  String get photoSavedLocally;

  /// No description provided for @pickSongHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a song from Home, Discover or Search to start listening.'**
  String get pickSongHint;

  /// No description provided for @pickSongsOptional.
  ///
  /// In en, this message translates to:
  /// **'Pick songs (optional — you can save an empty playlist as a draft and add songs later).'**
  String get pickSongsOptional;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @playAlbum.
  ///
  /// In en, this message translates to:
  /// **'Play album'**
  String get playAlbum;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get playAll;

  /// No description provided for @playEventsRolledUp.
  ///
  /// In en, this message translates to:
  /// **'Play events rolled up: {result}'**
  String playEventsRolledUp(String result);

  /// No description provided for @playHistoryVisitors.
  ///
  /// In en, this message translates to:
  /// **'Play history (visitors)'**
  String get playHistoryVisitors;

  /// No description provided for @playNext.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get playNext;

  /// No description provided for @playTodaysSignal.
  ///
  /// In en, this message translates to:
  /// **'Play today\'s signal'**
  String get playTodaysSignal;

  /// No description provided for @playbackStopped.
  ///
  /// In en, this message translates to:
  /// **'Playback stopped — the player notification is dismissed.'**
  String get playbackStopped;

  /// No description provided for @playlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistNameHint;

  /// No description provided for @playlistNotFound.
  ///
  /// In en, this message translates to:
  /// **'Playlist not found'**
  String get playlistNotFound;

  /// No description provided for @playsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} plays'**
  String playsCount(String count);

  /// No description provided for @popularArtists.
  ///
  /// In en, this message translates to:
  /// **'Popular artists'**
  String get popularArtists;

  /// No description provided for @postHint.
  ///
  /// In en, this message translates to:
  /// **'Tell your followers something… (max 1000 characters)'**
  String get postHint;

  /// No description provided for @postKindPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postKindPost;

  /// No description provided for @postKindRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get postKindRecommendation;

  /// No description provided for @postShared.
  ///
  /// In en, this message translates to:
  /// **'Post shared.'**
  String get postShared;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @postsFeedUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The artist posts feed is unavailable on the server right now ({error}). Artist posts still work on each artist page.'**
  String postsFeedUnavailable(String error);

  /// No description provided for @presetNumber.
  ///
  /// In en, this message translates to:
  /// **'Preset {n}'**
  String presetNumber(int n);

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your account stores your name, email and profile photo, plus your likes, favorites, playlists, follows and listening history so the service can work across devices. Your session is kept in a secure cookie on this device. SoundBlast does not sell your personal data.'**
  String get privacyBody;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileUpdated;

  /// No description provided for @publishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publishButton;

  /// No description provided for @publishIntoReleaseOptional.
  ///
  /// In en, this message translates to:
  /// **'Publish into one of your releases (optional)'**
  String get publishIntoReleaseOptional;

  /// No description provided for @publishSong.
  ///
  /// In en, this message translates to:
  /// **'Publish song'**
  String get publishSong;

  /// No description provided for @publishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get publishing;

  /// No description provided for @pushNotificationsDevice.
  ///
  /// In en, this message translates to:
  /// **'Push notifications on this device'**
  String get pushNotificationsDevice;

  /// No description provided for @pushNotificationsSent.
  ///
  /// In en, this message translates to:
  /// **'Push notifications sent'**
  String get pushNotificationsSent;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @quickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick links'**
  String get quickLinks;

  /// No description provided for @recompressLegacyAudio.
  ///
  /// In en, this message translates to:
  /// **'Recompress legacy audio [NEW]'**
  String get recompressLegacyAudio;

  /// No description provided for @recompressedBatch.
  ///
  /// In en, this message translates to:
  /// **'Recompressed batch: {result}'**
  String recompressedBatch(String result);

  /// No description provided for @reconcileSongSizes.
  ///
  /// In en, this message translates to:
  /// **'Reconcile song sizes'**
  String get reconcileSongSizes;

  /// No description provided for @reconciledSizes.
  ///
  /// In en, this message translates to:
  /// **'Reconciled sizes: {result}'**
  String reconciledSizes(String result);

  /// No description provided for @releasePrivate.
  ///
  /// In en, this message translates to:
  /// **'This release may be private or removed.'**
  String get releasePrivate;

  /// No description provided for @releaseRadar.
  ///
  /// In en, this message translates to:
  /// **'Release radar'**
  String get releaseRadar;

  /// No description provided for @releasesAlbums.
  ///
  /// In en, this message translates to:
  /// **'Releases (albums)'**
  String get releasesAlbums;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylist;

  /// No description provided for @removeVerifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Remove verified badge'**
  String get removeVerifiedBadge;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @renamePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Rename playlist'**
  String get renamePlaylist;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPassword;

  /// No description provided for @resetPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordAction;

  /// No description provided for @resetPasswordFor.
  ///
  /// In en, this message translates to:
  /// **'Reset password — {name}'**
  String resetPasswordFor(String name);

  /// No description provided for @resetVisitorCounter.
  ///
  /// In en, this message translates to:
  /// **'Reset visitor counter'**
  String get resetVisitorCounter;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @revokeAdminOwner.
  ///
  /// In en, this message translates to:
  /// **'Revoke admin (owner only)'**
  String get revokeAdminOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @roleArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get roleArtist;

  /// No description provided for @roleListener.
  ///
  /// In en, this message translates to:
  /// **'Listener'**
  String get roleListener;

  /// No description provided for @rollUpPlayEvents.
  ///
  /// In en, this message translates to:
  /// **'Roll up play events (45d)'**
  String get rollUpPlayEvents;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save to favorites'**
  String get saveToFavorites;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @scheduledMaintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Scheduled maintenance mode [NEW]'**
  String get scheduledMaintenanceMode;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search songs, artists, genres…'**
  String get searchHint;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get sendNotification;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @sharePost.
  ///
  /// In en, this message translates to:
  /// **'Share a post'**
  String get sharePost;

  /// No description provided for @showLyrics.
  ///
  /// In en, this message translates to:
  /// **'Show lyrics'**
  String get showLyrics;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @signalCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get signalCardTitle;

  /// No description provided for @signalOriginal.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast original'**
  String get signalOriginal;

  /// No description provided for @signalTitle.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get signalTitle;

  /// No description provided for @signalsLive.
  ///
  /// In en, this message translates to:
  /// **'{count} signals live'**
  String signalsLive(int count);

  /// No description provided for @sitemap.
  ///
  /// In en, this message translates to:
  /// **'Sitemap'**
  String get sitemap;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skippedUnplayable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play this song — skipped to the next one.'**
  String get skippedUnplayable;

  /// No description provided for @songNoAudio.
  ///
  /// In en, this message translates to:
  /// **'This song has no audio file.'**
  String get songNoAudio;

  /// No description provided for @songPublished.
  ///
  /// In en, this message translates to:
  /// **'Song published.'**
  String get songPublished;

  /// No description provided for @songTitle.
  ///
  /// In en, this message translates to:
  /// **'Song title'**
  String get songTitle;

  /// No description provided for @songVisibilityHidden.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get songVisibilityHidden;

  /// No description provided for @songVisibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'public'**
  String get songVisibilityPublic;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @songsBy.
  ///
  /// In en, this message translates to:
  /// **'Songs by {name}'**
  String songsBy(String name);

  /// No description provided for @songsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No songs} =1{1 song} other{{count} songs}}'**
  String songsCount(int count);

  /// No description provided for @soundBlastRoom.
  ///
  /// In en, this message translates to:
  /// **'The SoundBlast room'**
  String get soundBlastRoom;

  /// No description provided for @soundBlastSelection.
  ///
  /// In en, this message translates to:
  /// **'SoundBlast selection'**
  String get soundBlastSelection;

  /// No description provided for @soundblastOriginal.
  ///
  /// In en, this message translates to:
  /// **'SOUNDBLAST ORIGINAL'**
  String get soundblastOriginal;

  /// No description provided for @stageName.
  ///
  /// In en, this message translates to:
  /// **'Stage name'**
  String get stageName;

  /// No description provided for @stageNameArtists.
  ///
  /// In en, this message translates to:
  /// **'Stage name (artists)'**
  String get stageNameArtists;

  /// No description provided for @stageNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a stage name.'**
  String get stageNameRequired;

  /// No description provided for @statFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get statFollowers;

  /// No description provided for @statLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get statLikes;

  /// No description provided for @statListeners.
  ///
  /// In en, this message translates to:
  /// **'Listeners'**
  String get statListeners;

  /// No description provided for @statPlays.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get statPlays;

  /// No description provided for @statStreams.
  ///
  /// In en, this message translates to:
  /// **'Streams'**
  String get statStreams;

  /// No description provided for @statVisitors.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get statVisitors;

  /// No description provided for @stopPlayback.
  ///
  /// In en, this message translates to:
  /// **'Stop playback (dismisses the player notification)'**
  String get stopPlayback;

  /// No description provided for @studioNeedsArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist Studio needs an artist account.'**
  String get studioNeedsArtist;

  /// No description provided for @suspendAccount.
  ///
  /// In en, this message translates to:
  /// **'Suspend account'**
  String get suspendAccount;

  /// No description provided for @suspendArtist.
  ///
  /// In en, this message translates to:
  /// **'Suspend artist [NEW]'**
  String get suspendArtist;

  /// No description provided for @switchOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get switchOff;

  /// No description provided for @switchOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get switchOn;

  /// No description provided for @tabDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get tabDownloaded;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @tabLiked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get tabLiked;

  /// No description provided for @tabPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get tabPlaylists;

  /// No description provided for @tapBookmarkHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on any song to save it here.'**
  String get tapBookmarkHint;

  /// No description provided for @tapBookmarkToSave.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on any song to save it here.'**
  String get tapBookmarkToSave;

  /// No description provided for @tapHeartHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any song to keep it here.'**
  String get tapHeartHint;

  /// No description provided for @tapHeartToKeep.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any song to keep it here.'**
  String get tapHeartToKeep;

  /// No description provided for @tellUsWhatYouThink.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think'**
  String get tellUsWhatYouThink;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'By using SoundBlast you agree to use the platform respectfully: publish only music you own the rights to, do not upload content that infringes copyright, and do not harass other users. Artists confirm they own the rights to every song they publish.'**
  String get termsBody;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @termsPrivacyPermissions.
  ///
  /// In en, this message translates to:
  /// **'Terms, Privacy & Permissions'**
  String get termsPrivacyPermissions;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @trendingExplainer.
  ///
  /// In en, this message translates to:
  /// **'Trending is computed from plays in the last 7 days. Once people start listening, the chart fills up here.'**
  String get trendingExplainer;

  /// No description provided for @typeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type \"{word}\" to confirm.'**
  String typeToConfirm(String word);

  /// No description provided for @unknownAlbum.
  ///
  /// In en, this message translates to:
  /// **'Unknown album'**
  String get unknownAlbum;

  /// No description provided for @unknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown artist'**
  String get unknownArtist;

  /// No description provided for @unknownComposer.
  ///
  /// In en, this message translates to:
  /// **'Unknown composer'**
  String get unknownComposer;

  /// No description provided for @unknownFolder.
  ///
  /// In en, this message translates to:
  /// **'Unknown folder'**
  String get unknownFolder;

  /// No description provided for @unknownGenre.
  ///
  /// In en, this message translates to:
  /// **'Unknown genre'**
  String get unknownGenre;

  /// No description provided for @unknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown title'**
  String get unknownTitle;

  /// No description provided for @unlikeAction.
  ///
  /// In en, this message translates to:
  /// **'Unlike'**
  String get unlikeAction;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @uploadMissingFields.
  ///
  /// In en, this message translates to:
  /// **'Add a title, audio file, and release artwork to continue.'**
  String get uploadMissingFields;

  /// No description provided for @uploadNewSong.
  ///
  /// In en, this message translates to:
  /// **'Upload a new song'**
  String get uploadNewSong;

  /// No description provided for @uploadNote.
  ///
  /// In en, this message translates to:
  /// **'Audio is uploaded to the same storage as the website, then the server validates and optimizes it. Large files may take a while on a slow connection.'**
  String get uploadNote;

  /// No description provided for @uploadSong.
  ///
  /// In en, this message translates to:
  /// **'Upload a song'**
  String get uploadSong;

  /// No description provided for @uploadStorageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Uploads are unavailable right now: the server storage isn\'t set up yet.'**
  String get uploadStorageUnavailable;

  /// No description provided for @uploadingArtwork.
  ///
  /// In en, this message translates to:
  /// **'Uploading artwork…'**
  String get uploadingArtwork;

  /// No description provided for @uploadingAudio.
  ///
  /// In en, this message translates to:
  /// **'Uploading audio…'**
  String get uploadingAudio;

  /// No description provided for @userLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userLabel;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @viewLiveAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View live analytics · {plays} plays / 7d'**
  String viewLiveAnalytics(String plays);

  /// No description provided for @viewSongs.
  ///
  /// In en, this message translates to:
  /// **'View songs'**
  String get viewSongs;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get visibilityPublic;

  /// No description provided for @visitorCounterReset.
  ///
  /// In en, this message translates to:
  /// **'Visitor counter reset.'**
  String get visitorCounterReset;

  /// No description provided for @webPushUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Web Push (browser notifications) is not available in the Android app yet — new releases still arrive in your in-app Notifications inbox.'**
  String get webPushUnavailable;

  /// No description provided for @weeklyTop.
  ///
  /// In en, this message translates to:
  /// **'Weekly top'**
  String get weeklyTop;

  /// No description provided for @welcomeBackName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackName(String name);

  /// No description provided for @wipePlatformContent.
  ///
  /// In en, this message translates to:
  /// **'WIPE platform content'**
  String get wipePlatformContent;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment… (max 500 characters)'**
  String get writeComment;

  /// No description provided for @yourLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your Library'**
  String get yourLibrary;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authInvalidCredentials;

  /// No description provided for @accountSuspended.
  ///
  /// In en, this message translates to:
  /// **'This account is suspended. Contact SoundBlast support.'**
  String get accountSuspended;

  /// No description provided for @accountExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get accountExists;

  /// No description provided for @createAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the account. Please try again.'**
  String get createAccountFailed;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created.'**
  String get playlistCreated;

  /// No description provided for @playlistPrivateOrGone.
  ///
  /// In en, this message translates to:
  /// **'This playlist is private or no longer exists.'**
  String get playlistPrivateOrGone;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} — Android app'**
  String appVersion(String version);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
