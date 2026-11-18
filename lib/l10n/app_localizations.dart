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

  /// No description provided for @albumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Album not found'**
  String get albumNotFound;

  /// No description provided for @albumsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No albums} =1{1 album} other{{count} albums}}'**
  String albumsCount(int count);

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

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

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

  /// No description provided for @composersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No composers} =1{1 composer} other{{count} composers}}'**
  String composersCount(int count);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

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

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

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

  /// No description provided for @foldersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No folders} =1{1 folder} other{{count} folders}}'**
  String foldersCount(int count);

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

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @genresCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No genres} =1{1 genre} other{{count} genres}}'**
  String genresCount(int count);

  /// No description provided for @goToArtist.
  ///
  /// In en, this message translates to:
  /// **'Go to artist: {artist}'**
  String goToArtist(String artist);

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

  /// No description provided for @hideLyrics.
  ///
  /// In en, this message translates to:
  /// **'Hide lyrics'**
  String get hideLyrics;

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

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

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

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @lyrics.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyrics;

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

  /// No description provided for @navTrendingSongs.
  ///
  /// In en, this message translates to:
  /// **'Trending Songs'**
  String get navTrendingSongs;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylist;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

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

  /// No description provided for @noDownloads.
  ///
  /// In en, this message translates to:
  /// **'No downloads yet. Use ⋮ → Download for offline on any song.'**
  String get noDownloads;

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

  /// No description provided for @noLyrics.
  ///
  /// In en, this message translates to:
  /// **'No lyrics for this song'**
  String get noLyrics;

  /// No description provided for @noOfflinePlaylists.
  ///
  /// In en, this message translates to:
  /// **'No offline playlists yet. Create one, then add songs with ⋮ on any on-device song.'**
  String get noOfflinePlaylists;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get noPlaylists;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPosts;

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

  /// No description provided for @nothingPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get nothingPlaying;

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

  /// No description provided for @pickSongHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a song from Home, Discover or Search to start listening.'**
  String get pickSongHint;

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

  /// No description provided for @playNext.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get playNext;

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

  /// No description provided for @popularArtists.
  ///
  /// In en, this message translates to:
  /// **'Popular artists'**
  String get popularArtists;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

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

  /// No description provided for @releasePrivate.
  ///
  /// In en, this message translates to:
  /// **'This release may be private or removed.'**
  String get releasePrivate;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylist;

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

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPassword;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

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

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

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

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @songsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No songs} =1{1 song} other{{count} songs}}'**
  String songsCount(int count);

  /// No description provided for @stopPlayback.
  ///
  /// In en, this message translates to:
  /// **'Stop playback (dismisses the player notification)'**
  String get stopPlayback;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @unknownAlbum.
  ///
  /// In en, this message translates to:
  /// **'Unknown album'**
  String get unknownAlbum;

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

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @uploadSong.
  ///
  /// In en, this message translates to:
  /// **'Upload a song'**
  String get uploadSong;

  /// No description provided for @weeklyTop.
  ///
  /// In en, this message translates to:
  /// **'Weekly top'**
  String get weeklyTop;

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
