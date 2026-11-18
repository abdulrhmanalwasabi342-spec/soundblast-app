// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accessOffBody => 'SoundBlast can play the songs already on this phone — even without internet.';

  @override
  String get accessOffTitle => 'Access to on-device songs is off';

  @override
  String get addSongsHint => 'Add songs from the on-device library (⋮ on any song).';

  @override
  String get addToPlaylist => 'Add to playlist';

  @override
  String addedToPlaylist(String name) {
    return 'Added to \"$name\"';
  }

  @override
  String get admin => 'Admin';

  @override
  String get albumNotFound => 'Album not found';

  @override
  String albumsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
      zero: 'No albums',
    );
    return '$_temp0';
  }

  @override
  String get allSongs => 'All songs';

  @override
  String get allTracks => 'All tracks';

  @override
  String get appName => 'SoundBlast';

  @override
  String get artistNotFound => 'Artist not found';

  @override
  String get artistPageMissing => 'This artist page does not exist.';

  @override
  String get artists => 'Artists';

  @override
  String artistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artists',
      one: '1 artist',
      zero: 'No artists',
    );
    return '$_temp0';
  }

  @override
  String get artistsToExplore => 'Artists to explore';

  @override
  String get authAcceptTerms => 'I accept the Terms & Privacy Policy';

  @override
  String get authAcceptTermsFirst => 'Please accept the Terms & Privacy Policy.';

  @override
  String get authAddPhoto => 'Add a profile photo (optional)';

  @override
  String get authAlreadyHaveAccount => 'I already have an account — Log in';

  @override
  String get authArtist => 'Artist';

  @override
  String get authArtistNeedsStage => 'Artists need a stage name.';

  @override
  String get authBackToLogin => 'Back to log in';

  @override
  String get authContactSupport => 'Contact support';

  @override
  String get authContinueGithub => 'Continue with GitHub';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authCreateNew => 'Create a new account';

  @override
  String get authEmail => 'Email';

  @override
  String get authEnter => 'Enter SoundBlast';

  @override
  String get authEnterDetails => 'Enter your name, a valid email, and a password of at least 8 characters.';

  @override
  String get authForgotPassword => 'Forgot password';

  @override
  String get authForgotPasswordQ => 'Forgot password?';

  @override
  String get authGoogleNotSetup => 'Google sign-up isn\'t set up on the server yet.';

  @override
  String get authJoinSub => 'SoundBlast · join the music';

  @override
  String get authJoiningAs => 'I am joining as:';

  @override
  String get authListener => 'Listener';

  @override
  String get authLoginSub => 'Log in to continue listening.';

  @override
  String get authOrContinue => 'or continue with';

  @override
  String get authOrSignupWith => 'or sign up with';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHint => 'At least 8 characters';

  @override
  String get authPhotoRetry => 'Photo upload failed — it will be retried when you create the account.';

  @override
  String get authPhotoTooBig => 'The photo exceeds 5MB.';

  @override
  String get authReadTerms => 'Read the Terms, Privacy & Permissions';

  @override
  String get authSessionFailed => 'Sign-in did not create a session. Please try again.';

  @override
  String get authStageName => 'Stage name';

  @override
  String get authWelcomeBack => 'Welcome back.';

  @override
  String get authWelcomeBackSub => 'SoundBlast · welcome back';

  @override
  String get authYourName => 'Your name';

  @override
  String get browseDeviceSongs => 'Browse songs on this device';

  @override
  String get browseGenres => 'Browse genres';

  @override
  String get browseMusic => 'Browse music';

  @override
  String get browseReleases => 'Browse releases ↗';

  @override
  String get cancel => 'Cancel';

  @override
  String get catAlbums => 'Albums';

  @override
  String get catArtists => 'Artists';

  @override
  String get catComposers => 'Composers';

  @override
  String get catFolders => 'Folders';

  @override
  String get catGenres => 'Genres';

  @override
  String get catTracks => 'Tracks';

  @override
  String get close => 'Close';

  @override
  String get comments => 'Comments';

  @override
  String composersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count composers',
      one: '1 composer',
      zero: 'No composers',
    );
    return '$_temp0';
  }

  @override
  String get createAccount => 'Create an account';

  @override
  String get createPlaylist => 'Create playlist';

  @override
  String get createPlaylistDraft => 'Create playlist (as draft)';

  @override
  String get createPlaylistHint => 'Create a playlist and add songs to it.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteComment => 'Delete comment';

  @override
  String get deleteCommentConfirm => 'Delete this comment?';

  @override
  String get deleteDownload => 'Delete download';

  @override
  String deleteDownloadConfirm(String title) {
    return 'Delete the offline copy of \"$title\"? The song stays on SoundBlast.';
  }

  @override
  String get deletePlaylist => 'Delete playlist';

  @override
  String deletePlaylistConfirm(String name) {
    return 'Delete \"$name\"? The songs stay on this device.';
  }

  @override
  String get downloadedSubtitle => 'Saved in the app — plays without internet';

  @override
  String get downloadedTitle => 'Downloaded from SoundBlast';

  @override
  String foldersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count folders',
      one: '1 folder',
      zero: 'No folders',
    );
    return '$_temp0';
  }

  @override
  String get gallery => 'Gallery';

  @override
  String get galleryEmpty => 'Gallery is empty';

  @override
  String get genres => 'Genres';

  @override
  String genresCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count genres',
      one: '1 genre',
      zero: 'No genres',
    );
    return '$_temp0';
  }

  @override
  String goToArtist(String artist) {
    return 'Go to artist: $artist';
  }

  @override
  String get guestMessage => 'Log in or sign up to like songs, keep favorites, build playlists, upload music and follow artists.';

  @override
  String get guestTitle => 'You are browsing as a guest';

  @override
  String get hideLyrics => 'Hide lyrics';

  @override
  String get joinSubtitle => 'Create your account to start listening.';

  @override
  String get joinTitle => 'Join SoundBlast';

  @override
  String get language => 'Language';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystem => 'System default';

  @override
  String get libraryLoginMessage => 'Liked songs, favorites and playlists live in your account.';

  @override
  String get libraryLoginTitle => 'Log in to see your library';

  @override
  String likesCount(String count) {
    return '$count likes';
  }

  @override
  String get listenWithIntent => 'LISTEN WITH INTENT';

  @override
  String get login => 'Log in';

  @override
  String get loginPlaylistMessage => 'Playlists belong to your account.';

  @override
  String get loginPlaylistTitle => 'Log in to see this playlist';

  @override
  String get loginPlaylistsTitle => 'Log in to see playlists';

  @override
  String get loginToComment => 'Log in to comment.';

  @override
  String get logout => 'Log out';

  @override
  String get lyrics => 'Lyrics';

  @override
  String get meetArtists => 'Meet the artists';

  @override
  String get menu => 'Menu';

  @override
  String get moodsGenres => 'Moods & genres';

  @override
  String get mostFollowed => 'Most followed on SoundBlast';

  @override
  String get mostPlayedWeek => 'Most played this week';

  @override
  String get myPlaylistsOffline => 'My playlists (offline)';

  @override
  String get navAddPlaylist => 'Add playlist';

  @override
  String get navAlbums => 'Albums';

  @override
  String get navArtistPosts => 'Artist Posts';

  @override
  String get navArtists => 'Artists';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navFeedback => 'Feedback';

  @override
  String get navGenres => 'Genres';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navLikedSongs => 'Liked Songs';

  @override
  String get navMenu => 'Menu';

  @override
  String get navMusicPlayer => 'Music Player';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navTrendingSongs => 'Trending Songs';

  @override
  String get newLabel => 'New';

  @override
  String get newPlaylist => 'New playlist';

  @override
  String get next => 'Next';

  @override
  String get noAlbums => 'No albums yet';

  @override
  String get noArtistPosts => 'Artists have not shared any public posts.';

  @override
  String get noArtists => 'No artists yet';

  @override
  String get noAudioFound => 'No audio files found on this device.';

  @override
  String get noCategorySongs => 'No on-device songs in this category.';

  @override
  String get noComments => 'No comments yet — be the first to say something.';

  @override
  String get noDownloads => 'No downloads yet. Use ⋮ → Download for offline on any song.';

  @override
  String get noGenres => 'No genres yet';

  @override
  String get noGenresEmpty => 'No genres yet — the library is empty.';

  @override
  String get noLyrics => 'No lyrics for this song';

  @override
  String get noOfflinePlaylists => 'No offline playlists yet. Create one, then add songs with ⋮ on any on-device song.';

  @override
  String get noPlaylists => 'No playlists yet';

  @override
  String get noPosts => 'No posts yet';

  @override
  String get noResults => 'No results';

  @override
  String noSlugSongs(String slug) {
    return 'No $slug songs yet';
  }

  @override
  String get noSongsHere => 'No songs here';

  @override
  String get noSongsInLibrary => 'No songs in the library yet.';

  @override
  String get noSongsYet => 'No songs yet';

  @override
  String get noTrending => 'No trending songs yet';

  @override
  String get nothingHere => 'Nothing here yet';

  @override
  String get nothingMatches => 'Nothing on this device matches.';

  @override
  String get nothingPlaying => 'Nothing playing';

  @override
  String get nowPlaying => 'NOW PLAYING';

  @override
  String get nowPlayingTitle => 'Now Playing';

  @override
  String get oauthAndroidOnly => 'GitHub sign-in cookie extraction is Android-only.';

  @override
  String get oauthCheckAccount => 'I\'ve signed in — check my account';

  @override
  String get oauthInAppNote => 'You will sign in with GitHub in this window. When GitHub sends you back to SoundBlast, the app signs you in automatically.';

  @override
  String oauthLoadFailed(String error) {
    return 'Could not load the sign-in page ($error). Check your connection and try again.';
  }

  @override
  String get oauthNoSession => 'GitHub sign-in did not create a session. Please try again.';

  @override
  String get oauthServerStarting => 'The server is starting or updating right now. Wait a moment and tap Retry — the GitHub page opens inside the app.';

  @override
  String get oauthTitle => 'Sign in with GitHub';

  @override
  String get onDeviceSubtitle => 'Audio files already on your phone';

  @override
  String get onDeviceTitle => 'On this device';

  @override
  String get onboardingArtist => 'Are you an artist?';

  @override
  String get onboardingArtistBody => 'Publish your own songs, build albums, and reach listeners — right from your phone. Sign up as an artist to start.';

  @override
  String get onboardingBeat => 'Feel the beat.';

  @override
  String get onboardingBeatBody => 'SoundBlast is a home for independent music — discover new songs, follow the artists you love, and keep everything in one place.';

  @override
  String get onboardingFollow => 'Follow artists.';

  @override
  String get onboardingFollowBody => 'Get notified when artists you follow release new songs and share posts. Your feed grows with the music you love.';

  @override
  String get pickSongHint => 'Pick a song from Home, Discover or Search to start listening.';

  @override
  String get play => 'Play';

  @override
  String get playAlbum => 'Play album';

  @override
  String get playAll => 'Play all';

  @override
  String get playNext => 'Play next';

  @override
  String get playbackStopped => 'Playback stopped — the player notification is dismissed.';

  @override
  String get playlistNameHint => 'Playlist name';

  @override
  String get playlistNotFound => 'Playlist not found';

  @override
  String get popularArtists => 'Popular artists';

  @override
  String get posts => 'Posts';

  @override
  String get profile => 'Profile';

  @override
  String get queue => 'Queue';

  @override
  String get quickLinks => 'Quick links';

  @override
  String get releasePrivate => 'This release may be private or removed.';

  @override
  String get removeFromPlaylist => 'Remove from playlist';

  @override
  String get rename => 'Rename';

  @override
  String get renamePlaylist => 'Rename playlist';

  @override
  String get resetPassword => 'Reset your password';

  @override
  String get retry => 'Retry';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleArtist => 'Artist';

  @override
  String get roleListener => 'Listener';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search songs, artists, genres…';

  @override
  String get showLyrics => 'Show lyrics';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get sitemap => 'Sitemap';

  @override
  String get skip => 'Skip';

  @override
  String get songs => 'Songs';

  @override
  String songsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
      zero: 'No songs',
    );
    return '$_temp0';
  }

  @override
  String get stopPlayback => 'Stop playback (dismisses the player notification)';

  @override
  String get trending => 'Trending';

  @override
  String get unknownAlbum => 'Unknown album';

  @override
  String get unknownComposer => 'Unknown composer';

  @override
  String get unknownFolder => 'Unknown folder';

  @override
  String get unknownGenre => 'Unknown genre';

  @override
  String get upNext => 'Up next';

  @override
  String get uploadSong => 'Upload a song';

  @override
  String get weeklyTop => 'Weekly top';

  @override
  String get writeComment => 'Write a comment… (max 500 characters)';

  @override
  String get yourLibrary => 'Your Library';
}
