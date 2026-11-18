// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aboutBody1 => 'SoundBlast is a music platform for independent artists and the listeners who love them. Discover new songs, follow artists, build playlists, and — if you make music — publish your own releases and reach new ears.';

  @override
  String get aboutBody2 => 'Everything you hear here is published by real artists on the platform. Likes, comments, follows and playlists are shared across the website and this app, because both talk to the same SoundBlast backend.';

  @override
  String get aboutSoundBlast => 'About SoundBlast';

  @override
  String get accessOffBody => 'SoundBlast can play the songs already on this phone — even without internet.';

  @override
  String get accessOffTitle => 'Access to on-device songs is off';

  @override
  String get activateAccount => 'Activate account';

  @override
  String get activateArtist => 'Activate artist';

  @override
  String get activationCasesHint => 'Artist accounts that have not completed activation.';

  @override
  String activationStatus(String status) {
    return 'Activation: $status';
  }

  @override
  String get addSongsFromMenu => 'Add songs from any song menu (⋮ → Add to playlist).';

  @override
  String get addSongsHint => 'Add songs from the on-device library (⋮ on any song).';

  @override
  String get addToPlaylist => 'Add to playlist';

  @override
  String addedToName(String name) {
    return 'Added to $name.';
  }

  @override
  String addedToPlaylist(String name) {
    return 'Added to \"$name\"';
  }

  @override
  String get admin => 'Admin';

  @override
  String get adminDefaultNotification => 'A message from SoundBlast';

  @override
  String get adminRestricted => 'This area is restricted to SoundBlast administrators.';

  @override
  String get adminShort => 'admin';

  @override
  String get adminTabAnalytics => 'Analytics';

  @override
  String get adminTabArtists => 'Artists';

  @override
  String get adminTabContent => 'Content';

  @override
  String get adminTabHomePlatform => 'Home & platform';

  @override
  String get adminTabOverview => 'Overview';

  @override
  String get adminTabSystemSafety => 'System & safety';

  @override
  String get adminTabUsers => 'Users';

  @override
  String get adminsOnly => 'Admins only';

  @override
  String get albumNameOptional => 'Album name (optional)';

  @override
  String get albumNotFound => 'Album not found';

  @override
  String get albumsAppearHint => 'Albums appear here once artists publish releases.';

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
  String get allArtists => 'All artists';

  @override
  String get allSongs => 'All songs';

  @override
  String get allTracks => 'All tracks';

  @override
  String get appName => 'SoundBlast';

  @override
  String get appVersionLabel => 'Version 1.0.0 — Android app';

  @override
  String get archive => 'Archive';

  @override
  String get artistAccountsOnly => 'Artist accounts only';

  @override
  String get artistActivationCases => 'Artist activation cases';

  @override
  String get artistNotFound => 'Artist not found';

  @override
  String get artistPageMissing => 'This artist page does not exist.';

  @override
  String artistStats(String followers, String plays, String songs) {
    return '$followers followers • $songs songs • $plays plays';
  }

  @override
  String get artistStudio => 'Artist Studio';

  @override
  String get artists => 'Artists';

  @override
  String get artistsAppearHint => 'Artists appear here once they sign up and publish.';

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
  String get artistsYouFollow => 'Artists you follow';

  @override
  String get artworkAppearHint => 'Song artwork appears here once songs with cover art are published.';

  @override
  String get audioSelected => 'Audio selected';

  @override
  String get auditLog => 'Audit log';

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
  String get bio => 'Bio';

  @override
  String get bioLabel => 'Bio';

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
  String get cannotPlaySong => 'Couldn\'t play this song. Check your connection and try again.';

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
  String get category => 'Category';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get chooseArtwork => 'Choose release artwork (PNG, JPG, or WEBP)';

  @override
  String get chooseAudioFile => 'Choose audio file (MP3, WAV, or M4A)';

  @override
  String get cleanLibraryIntegrity => 'Clean library integrity';

  @override
  String get clearEngagement => 'Clear engagement';

  @override
  String get clearFavorites => 'Clear favorites [NEW]';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearVisitorHistory => 'Clear visitor history';

  @override
  String get close => 'Close';

  @override
  String get comments => 'Comments';

  @override
  String get commentsModeration => 'Comments moderation';

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
  String get confirm => 'Confirm';

  @override
  String get confirmRights => 'I confirm I own the rights to publish this song.';

  @override
  String get confirmRightsFirst => 'Please confirm you own the rights to publish this song.';

  @override
  String get contact => 'Contact';

  @override
  String get contactBody => 'Questions, problems, or a report about content on SoundBlast? Send feedback from the Feedback page — it goes straight to the SoundBlast team — or visit the website contact page.';

  @override
  String get contactInboxGap => 'The website has no contact-messages inbox endpoint yet — contact currently goes through Feedback. Listed as a named gap in README.md.';

  @override
  String get contactMessagesInbox => 'Contact messages inbox [NEW]';

  @override
  String get copyrightBody => 'If content on SoundBlast infringes your rights, send a copyright report from the Feedback page (choose the copyright report category). Reports are reviewed by the SoundBlast administrators.';

  @override
  String get copyrightReports => 'Copyright reports';

  @override
  String get couldNotOpenWebsite => 'Could not open the website.';

  @override
  String get couldNotReadFiles => 'Could not read the selected files.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get createButton => 'Create';

  @override
  String get createFirstPlaylistHint => 'Create your first playlist and add songs to it.';

  @override
  String get createPlaylist => 'Create playlist';

  @override
  String get createPlaylistDraft => 'Create playlist (as draft)';

  @override
  String get createPlaylistHint => 'Create a playlist and add songs to it.';

  @override
  String get createUser => 'Create user';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get dangerZoneNote => 'Bulk actions delete platform data permanently. Each one needs its confirmation phrase typed in.';

  @override
  String get dashboardGlance => 'SoundBlast at a glance';

  @override
  String get dashboardGuestNote => 'Platform totals above are public. Your library, uploads and studio need an account.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAllAccounts => 'Delete ALL accounts';

  @override
  String get deleteAllComments => 'Delete ALL comments';

  @override
  String deleteAllCommentsOn(String title) {
    return 'Delete all comments on \"$title\"?';
  }

  @override
  String get deleteAllItsComments => 'Delete all its comments';

  @override
  String get deleteAllPlaylists => 'Delete ALL playlists';

  @override
  String get deleteComment => 'Delete comment';

  @override
  String get deleteCommentConfirm => 'Delete this comment?';

  @override
  String get deleteComments => 'Delete comments';

  @override
  String get deleteDownload => 'Delete download';

  @override
  String deleteDownloadConfirm(String title) {
    return 'Delete the offline copy of \"$title\"? The song stays on SoundBlast.';
  }

  @override
  String get deleteOauthUser => 'Delete OAuth user';

  @override
  String get deletePlaylist => 'Delete playlist';

  @override
  String deletePlaylistConfirm(String name) {
    return 'Delete \"$name\"? The songs stay on this device.';
  }

  @override
  String get deletePlaylistConfirmPerm => 'Delete this playlist permanently?';

  @override
  String get deletePost => 'Delete post';

  @override
  String get deletePostConfirm => 'Delete this post?';

  @override
  String get deleteRelease => 'Delete release';

  @override
  String get deleteReleaseConfirm => 'Delete this release permanently?';

  @override
  String get deleteSong => 'Delete song';

  @override
  String deleteSongConfirm(String title) {
    return 'Delete \"$title\" permanently?';
  }

  @override
  String get deleteUser => 'Delete user';

  @override
  String get deleteUserConfirm => 'Delete this account permanently? The owner account can never be deleted.';

  @override
  String get deleteVisitorHistoryConfirm => 'Delete all recorded visitor history?';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String doneResult(String result) {
    return 'Done: $result';
  }

  @override
  String get downloadForOffline => 'Download for offline';

  @override
  String get downloadedAvailableOffline => 'Downloaded — available offline in Library → Downloaded.';

  @override
  String get downloadedPlayOffline => 'Downloaded — play offline';

  @override
  String get downloadedSubtitle => 'Saved in the app — plays without internet';

  @override
  String get downloadedTitle => 'Downloaded from SoundBlast';

  @override
  String downloadingSong(String title) {
    return 'Downloading $title…';
  }

  @override
  String durationLabel(String time) {
    return 'Duration: $time';
  }

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileArtistsOnly => 'Profile editing is available for artist accounts.';

  @override
  String get editUser => 'Edit user';

  @override
  String get exploreMusic => 'Explore music';

  @override
  String get feedbackCopyrightReport => 'Copyright report';

  @override
  String get feedbackInbox => 'Feedback inbox';

  @override
  String get feedbackIntro => 'Bug reports, ideas, privacy requests and copyright reports all go to the SoundBlast team.';

  @override
  String get feedbackMinChars => 'Please write at least 10 characters.';

  @override
  String get feedbackPrivacyRequest => 'Privacy request';

  @override
  String get feedbackSentThanks => 'Thanks — your feedback was sent.';

  @override
  String get fieldName => 'Name';

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
  String get follow => 'Follow';

  @override
  String get followedArtistsNote => 'New releases from these artists appear in your Notifications inbox.';

  @override
  String followersCount(String count) {
    return '$count followers';
  }

  @override
  String get followersOnly => 'Followers only';

  @override
  String get following => 'Following';

  @override
  String get gallery => 'Gallery';

  @override
  String get galleryEmpty => 'Gallery is empty';

  @override
  String get genre => 'Genre';

  @override
  String get genres => 'Genres';

  @override
  String get genresAppearHint => 'Genres appear here once artists publish songs.';

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
  String get getInTouch => 'Get in touch';

  @override
  String get givePlaylistName => 'Give your playlist a name.';

  @override
  String get goHome => 'Go home';

  @override
  String goToArtist(String artist) {
    return 'Go to artist: $artist';
  }

  @override
  String get grantAdminOwner => 'Grant admin (owner only)';

  @override
  String get guestMessage => 'Log in or sign up to like songs, keep favorites, build playlists, upload music and follow artists.';

  @override
  String get guestTitle => 'You are browsing as a guest';

  @override
  String get heroActionOrderHint => 'Controls which action the Home hero button offers first.';

  @override
  String heroActionOrderSet(int n) {
    return 'Hero action order set to preset $n.';
  }

  @override
  String get heroBody => 'A focused home for releases, artist stories, and the tracks worth replaying. Built around the people making the music.';

  @override
  String get heroLine1 => 'Find the sound';

  @override
  String get heroLine2 => 'that stays with';

  @override
  String get heroLine3 => 'you.';

  @override
  String get hideLyrics => 'Hide lyrics';

  @override
  String get hideUnpublish => 'Hide (unpublish)';

  @override
  String get homeHeroActionOrder => 'Home hero action order';

  @override
  String get homeSummaryUnavailable => 'Home summary is unavailable on the server right now — showing songs directly.';

  @override
  String get integrityEmptyPlaylists => 'Empty playlists';

  @override
  String get integrityOrphanPlaylistSongs => 'Orphan playlist songs';

  @override
  String get integrityRawPlayEvents => 'Raw play events';

  @override
  String get integrityRemovableEmptyPlaylists => 'Removable empty playlists';

  @override
  String get integritySongsMissingSize => 'Songs missing size';

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
  String last7DaysPlays(String plays) {
    return 'Last 7 days: $plays plays';
  }

  @override
  String libraryCleanupDone(String result) {
    return 'Library cleanup done: $result';
  }

  @override
  String get libraryEmptyHint => 'The SoundBlast library is empty right now. Artists can publish the first songs from Upload.';

  @override
  String get libraryIntegrity => 'Library integrity';

  @override
  String get libraryLoginMessage => 'Liked songs, favorites and playlists live in your account.';

  @override
  String get libraryLoginTitle => 'Log in to see your library';

  @override
  String get libraryMaintenance => 'Library maintenance';

  @override
  String get likeAction => 'Like';

  @override
  String likesCount(String count) {
    return '$count likes';
  }

  @override
  String get listenWithIntent => 'LISTEN WITH INTENT';

  @override
  String get listenerCannotOpenStudio => 'Your account is a listener account. Sign up as an artist to open the studio.';

  @override
  String get login => 'Log in';

  @override
  String get loginAsArtist => 'Log in as an artist';

  @override
  String get loginAsArtistUpload => 'Log in as an artist to upload songs.';

  @override
  String get loginFirst => 'Log in first';

  @override
  String get loginForDashboard => 'Log in for your personal dashboard';

  @override
  String get loginPlaylistMessage => 'Playlists belong to your account.';

  @override
  String get loginPlaylistTitle => 'Log in to see this playlist';

  @override
  String get loginPlaylistsTitle => 'Log in to see playlists';

  @override
  String get loginToComment => 'Log in to comment.';

  @override
  String get loginToCreatePlaylist => 'Log in to create a playlist.';

  @override
  String get loginToFollow => 'Log in to follow artists.';

  @override
  String get loginToLike => 'Log in to like songs.';

  @override
  String get loginToSaveFavorites => 'Log in to save favorites.';

  @override
  String get loginToSeeNotifications => 'Log in to see notifications';

  @override
  String get loginToSendFeedback => 'Log in to send feedback.';

  @override
  String get loginToSendFeedbackNote => 'Log in to send feedback — it is filed under your account.';

  @override
  String get loginToUsePlaylists => 'Log in to use playlists.';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirm => 'Log out of SoundBlast on this device?';

  @override
  String get lostAccessContactSupport => 'If you lost access to your account, contact SoundBlast support from the Contact page and include the email address of your account.';

  @override
  String get lyrics => 'Lyrics';

  @override
  String get maintenanceGap => 'The website has no maintenance-mode endpoint — the app lists it as a named gap (see README.md). Use Render to stop the service if maintenance is needed.';

  @override
  String get makeAdminOwner => 'Make admin (owner only)';

  @override
  String get makeUser => 'Make user';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get markRead => 'Mark read';

  @override
  String get markReviewed => 'Mark reviewed';

  @override
  String get markVerified => 'Mark verified';

  @override
  String marksOfLove(String count) {
    return '$count marks of love from the community';
  }

  @override
  String get meetArtists => 'Meet the artists';

  @override
  String get menu => 'Menu';

  @override
  String get messageLengthHint => 'At least 10 characters, up to 2000.';

  @override
  String get moodsGenres => 'Moods & genres';

  @override
  String get mostFollowed => 'Most followed on SoundBlast';

  @override
  String get mostPlayed7Days => 'Most played in the last 7 days';

  @override
  String get mostPlayedWeek => 'Most played this week';

  @override
  String get myPlaylistsOffline => 'My playlists (offline)';

  @override
  String get myPosts => 'My posts';

  @override
  String get myReleases => 'My releases';

  @override
  String get mySongs => 'My songs';

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
  String get navProfileShort => 'Profile';

  @override
  String get navTrendingSongs => 'Trending Songs';

  @override
  String get newInRoom => 'New in the room';

  @override
  String get newLabel => 'New';

  @override
  String get newPasswordMin8 => 'New password (min 8)';

  @override
  String get newPlaylist => 'New playlist';

  @override
  String get newPost => 'New post';

  @override
  String get next => 'Next';

  @override
  String get noAlbums => 'No albums yet';

  @override
  String get noArtistPosts => 'Artists have not shared any public posts.';

  @override
  String get noArtistPostsYet => 'No artist posts yet.';

  @override
  String get noArtists => 'No artists yet';

  @override
  String get noAudioFound => 'No audio files found on this device.';

  @override
  String get noAuditEventsYet => 'No audit events yet.';

  @override
  String get noCategorySongs => 'No on-device songs in this category.';

  @override
  String get noComments => 'No comments yet — be the first to say something.';

  @override
  String get noCommentsYet => 'No comments yet.';

  @override
  String get noDownloads => 'No downloads yet. Use ⋮ → Download for offline on any song.';

  @override
  String get noDownloadsYet => 'No downloads yet. Use ⋮ → Download for offline on any song.';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get noFeedbackYet => 'No feedback yet.';

  @override
  String get noGenres => 'No genres yet';

  @override
  String get noGenresEmpty => 'No genres yet — the library is empty.';

  @override
  String get noLikedSongsYet => 'No liked songs yet';

  @override
  String get noLyrics => 'No lyrics for this song';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noNotificationsHint => 'When artists you follow release new songs or share posts, you will see it here.';

  @override
  String get noNotificationsRecorded => 'No notifications recorded yet.';

  @override
  String get noOauthUsersYet => 'No OAuth users yet.';

  @override
  String get noOfflinePlaylists => 'No offline playlists yet. Create one, then add songs with ⋮ on any on-device song.';

  @override
  String get noPendingActivation => 'No pending activation cases.';

  @override
  String get noPlaylists => 'No playlists yet';

  @override
  String get noPlaylistsCreateFirst => 'No playlists yet — create one first.';

  @override
  String get noPosts => 'No posts yet';

  @override
  String get noPublicSongsArtist => 'No public songs from this artist yet.';

  @override
  String get noPublicSongsGenre => 'No public songs in this genre right now.';

  @override
  String get noPublicSongsRelease => 'No public songs in this release yet.';

  @override
  String get noReleasesYet => 'No releases yet.';

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
  String get noSongsMatchFilter => 'No songs match this filter. Try another genre.';

  @override
  String get noSongsPublished => 'You have not published any songs yet.';

  @override
  String get noSongsShort => 'No songs.';

  @override
  String get noSongsYet => 'No songs yet';

  @override
  String get noTrending => 'No trending songs yet';

  @override
  String get noUsersYet => 'No users yet.';

  @override
  String get noVisitorHistory => 'No visitor history yet.';

  @override
  String get noneOption => 'None';

  @override
  String get notFollowingArtists => 'You are not following any artists yet.';

  @override
  String get notNow => 'Not now';

  @override
  String get notVerified => 'Not verified';

  @override
  String get nothingHere => 'Nothing here yet';

  @override
  String get nothingMatches => 'Nothing on this device matches.';

  @override
  String nothingMatchesQuery(String query) {
    return 'Nothing matches \"$query\" yet. Try a different song, artist or genre.';
  }

  @override
  String get nothingPlaying => 'Nothing playing';

  @override
  String get notifPreferences => 'Notification preferences';

  @override
  String get notifPrefsBelongAccount => 'Notification preferences belong to your account.';

  @override
  String get notificationSent => 'Notification sent.';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEmptyHint => 'New releases from artists you follow arrive here.';

  @override
  String notificationsState(String state) {
    return 'Notifications: $state';
  }

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
  String oauthRoleLabel(String role) {
    return 'role: $role';
  }

  @override
  String get oauthServerStarting => 'The server is starting or updating right now. Wait a moment and tap Retry — the GitHub page opens inside the app.';

  @override
  String get oauthTitle => 'Sign in with GitHub';

  @override
  String get oauthUsers => 'OAuth users';

  @override
  String get offlineShowingCache => 'You\'re offline — showing the last saved library.';

  @override
  String get offlineShowingSaved => 'You are offline — showing the last saved library.';

  @override
  String get onDeviceSubtitle => 'Audio files already on your phone';

  @override
  String get onDeviceTitle => 'On this device';

  @override
  String get onThisDevice => 'On this device';

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
  String get onlyArtistsUpload => 'Only artist accounts can upload songs. Sign up as an artist to publish music.';

  @override
  String get onlyArtistsUploadListener => 'Only artist accounts can upload songs. Your account is a listener account — create an artist account to publish music.';

  @override
  String get openAdmin => 'Open Admin';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get openArtistStudio => 'Open Artist Studio';

  @override
  String get openWebsite => 'Open the SoundBlast website';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get ownerNote => 'The owner account (ADMIN_EMAIL) can never be demoted, suspended or deleted by another admin, and only the owner can grant admin to others.';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get pageNotFoundBody => 'This page does not exist on SoundBlast.';

  @override
  String get passwordMin8 => 'Password (min 8)';

  @override
  String get passwordResetNotConfigured => 'Password-reset email is not configured for SoundBlast yet. To protect your account, this app will not pretend that a reset message was sent.';

  @override
  String get permAccessOffBody => 'Without access to audio files, SoundBlast cannot list or play the songs stored on this device. Downloaded SoundBlast songs still work.\n\nYou can allow access now — this is the last time we will ask.';

  @override
  String get permAccessOffTitle => 'Access is still off';

  @override
  String get permAllowAccess => 'Allow access';

  @override
  String get permAskAgain => 'Ask again';

  @override
  String get permMediaBody => 'SoundBlast can play the audio files already on this device — your downloaded songs and your own music library — even without internet.\n\nWe will ask for access to audio files on this device, only for playing your music. Nothing is uploaded.';

  @override
  String get permMediaTitle => 'Play songs already on your phone';

  @override
  String get permNotifBody => 'When a song is playing, SoundBlast shows its player in the notification shade — title, artist, cover, and play / pause / next — so you can control it while the app is closed.\n\nWe will ask once to show notifications. If you skip it, music still plays; only the notification controls will be missing.';

  @override
  String get permNotifTitle => 'Keep the player in your notifications';

  @override
  String get permShowPlayerControls => 'Show player controls';

  @override
  String get permanentlyDeletesData => 'This permanently deletes the data and cannot be undone.';

  @override
  String get permissionDeclinedTwice => 'You declined the audio permission twice, so SoundBlast will not ask again. You can still allow it any time in the app settings — downloaded SoundBlast songs keep working either way.';

  @override
  String get permissions => 'Permissions';

  @override
  String get permissionsBody => 'The app asks for storage access only when you pick an audio file, artwork or profile photo to upload. Playback continues while the app is in the background so your music is not interrupted.';

  @override
  String get photoSavedLocally => 'Photo saved on this phone. It will sync to your profile when storage is ready.';

  @override
  String get pickSongHint => 'Pick a song from Home, Discover or Search to start listening.';

  @override
  String get pickSongsOptional => 'Pick songs (optional — you can save an empty playlist as a draft and add songs later).';

  @override
  String get play => 'Play';

  @override
  String get playAlbum => 'Play album';

  @override
  String get playAll => 'Play all';

  @override
  String playEventsRolledUp(String result) {
    return 'Play events rolled up: $result';
  }

  @override
  String get playHistoryVisitors => 'Play history (visitors)';

  @override
  String get playNext => 'Play next';

  @override
  String get playTodaysSignal => 'Play today\'s signal';

  @override
  String get playbackStopped => 'Playback stopped — the player notification is dismissed.';

  @override
  String get playlistNameHint => 'Playlist name';

  @override
  String get playlistNotFound => 'Playlist not found';

  @override
  String playsCount(String count) {
    return '$count plays';
  }

  @override
  String get popularArtists => 'Popular artists';

  @override
  String get postHint => 'Tell your followers something… (max 1000 characters)';

  @override
  String get postKindPost => 'Post';

  @override
  String get postKindRecommendation => 'Recommendation';

  @override
  String get postShared => 'Post shared.';

  @override
  String get posts => 'Posts';

  @override
  String postsFeedUnavailable(String error) {
    return 'The artist posts feed is unavailable on the server right now ($error). Artist posts still work on each artist page.';
  }

  @override
  String presetNumber(int n) {
    return 'Preset $n';
  }

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyBody => 'Your account stores your name, email and profile photo, plus your likes, favorites, playlists, follows and listening history so the service can work across devices. Your session is kept in a secure cookie on this device. SoundBlast does not sell your personal data.';

  @override
  String get profile => 'Profile';

  @override
  String get profileUpdated => 'Profile updated.';

  @override
  String get publishButton => 'Publish';

  @override
  String get publishIntoReleaseOptional => 'Publish into one of your releases (optional)';

  @override
  String get publishSong => 'Publish song';

  @override
  String get publishing => 'Publishing…';

  @override
  String get pushNotificationsDevice => 'Push notifications on this device';

  @override
  String get pushNotificationsSent => 'Push notifications sent';

  @override
  String get queue => 'Queue';

  @override
  String get quickLinks => 'Quick links';

  @override
  String get recompressLegacyAudio => 'Recompress legacy audio [NEW]';

  @override
  String recompressedBatch(String result) {
    return 'Recompressed batch: $result';
  }

  @override
  String get reconcileSongSizes => 'Reconcile song sizes';

  @override
  String reconciledSizes(String result) {
    return 'Reconciled sizes: $result';
  }

  @override
  String get releasePrivate => 'This release may be private or removed.';

  @override
  String get releaseRadar => 'Release radar';

  @override
  String get releasesAlbums => 'Releases (albums)';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get removeFromPlaylist => 'Remove from playlist';

  @override
  String get removeVerifiedBadge => 'Remove verified badge';

  @override
  String get rename => 'Rename';

  @override
  String get renamePlaylist => 'Rename playlist';

  @override
  String get resetButton => 'Reset';

  @override
  String get resetPassword => 'Reset your password';

  @override
  String get resetPasswordAction => 'Reset password';

  @override
  String resetPasswordFor(String name) {
    return 'Reset password — $name';
  }

  @override
  String get resetVisitorCounter => 'Reset visitor counter';

  @override
  String get restore => 'Restore';

  @override
  String get retry => 'Retry';

  @override
  String get revokeAdminOwner => 'Revoke admin (owner only)';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleArtist => 'Artist';

  @override
  String get roleListener => 'Listener';

  @override
  String get rollUpPlayEvents => 'Roll up play events (45d)';

  @override
  String get save => 'Save';

  @override
  String get saveToFavorites => 'Save to favorites';

  @override
  String get saving => 'Saving…';

  @override
  String get scheduledMaintenanceMode => 'Scheduled maintenance mode [NEW]';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search songs, artists, genres…';

  @override
  String get seeAll => 'See all';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get sendNotification => 'Send notification';

  @override
  String get share => 'Share';

  @override
  String get sharePost => 'Share a post';

  @override
  String get showLyrics => 'Show lyrics';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get signalCardTitle => 'Signal';

  @override
  String signalsLive(int count) {
    return '$count signals live';
  }

  @override
  String get sitemap => 'Sitemap';

  @override
  String get skip => 'Skip';

  @override
  String get skippedUnplayable => 'Couldn\'t play this song — skipped to the next one.';

  @override
  String get songNoAudio => 'This song has no audio file.';

  @override
  String get songPublished => 'Song published.';

  @override
  String get songTitle => 'Song title';

  @override
  String get songVisibilityHidden => 'hidden';

  @override
  String get songVisibilityPublic => 'public';

  @override
  String get songs => 'Songs';

  @override
  String songsBy(String name) {
    return 'Songs by $name';
  }

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
  String get soundBlastRoom => 'The SoundBlast room';

  @override
  String get soundblastOriginal => 'SOUNDBLAST ORIGINAL';

  @override
  String get stageName => 'Stage name';

  @override
  String get stageNameArtists => 'Stage name (artists)';

  @override
  String get stageNameRequired => 'Enter a stage name.';

  @override
  String get statFollowers => 'Followers';

  @override
  String get statLikes => 'Likes';

  @override
  String get statListeners => 'Listeners';

  @override
  String get statPlays => 'Plays';

  @override
  String get statStreams => 'Streams';

  @override
  String get statVisitors => 'Visitors';

  @override
  String get stopPlayback => 'Stop playback (dismisses the player notification)';

  @override
  String get studioNeedsArtist => 'Artist Studio needs an artist account.';

  @override
  String get suspendAccount => 'Suspend account';

  @override
  String get suspendArtist => 'Suspend artist [NEW]';

  @override
  String get switchOff => 'off';

  @override
  String get switchOn => 'on';

  @override
  String get tabDownloaded => 'Downloaded';

  @override
  String get tabLiked => 'Liked';

  @override
  String get tapBookmarkHint => 'Tap the bookmark on any song to save it here.';

  @override
  String get tapHeartHint => 'Tap the heart on any song to keep it here.';

  @override
  String get tellUsWhatYouThink => 'Tell us what you think';

  @override
  String get termsBody => 'By using SoundBlast you agree to use the platform respectfully: publish only music you own the rights to, do not upload content that infringes copyright, and do not harass other users. Artists confirm they own the rights to every song they publish.';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get termsPrivacyPermissions => 'Terms, Privacy & Permissions';

  @override
  String get trending => 'Trending';

  @override
  String get trendingExplainer => 'Trending is computed from plays in the last 7 days. Once people start listening, the chart fills up here.';

  @override
  String typeToConfirm(String word) {
    return 'Type \"$word\" to confirm.';
  }

  @override
  String get unknownAlbum => 'Unknown album';

  @override
  String get unknownArtist => 'Unknown artist';

  @override
  String get unknownComposer => 'Unknown composer';

  @override
  String get unknownFolder => 'Unknown folder';

  @override
  String get unknownGenre => 'Unknown genre';

  @override
  String get unknownTitle => 'Unknown title';

  @override
  String get unlikeAction => 'Unlike';

  @override
  String get upNext => 'Up next';

  @override
  String get uploadMissingFields => 'Add a title, audio file, and release artwork to continue.';

  @override
  String get uploadNewSong => 'Upload a new song';

  @override
  String get uploadNote => 'Audio is uploaded to the same storage as the website, then the server validates and optimizes it. Large files may take a while on a slow connection.';

  @override
  String get uploadSong => 'Upload a song';

  @override
  String get uploadingArtwork => 'Uploading artwork…';

  @override
  String get uploadingAudio => 'Uploading audio…';

  @override
  String get userLabel => 'User';

  @override
  String get verified => 'Verified';

  @override
  String viewLiveAnalytics(String plays) {
    return 'View live analytics · $plays plays / 7d';
  }

  @override
  String get viewSongs => 'View songs';

  @override
  String get visibilityPublic => 'Public';

  @override
  String get visitorCounterReset => 'Visitor counter reset.';

  @override
  String get webPushUnavailable => 'Web Push (browser notifications) is not available in the Android app yet — new releases still arrive in your in-app Notifications inbox.';

  @override
  String get weeklyTop => 'Weekly top';

  @override
  String welcomeBackName(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get wipePlatformContent => 'WIPE platform content';

  @override
  String get writeComment => 'Write a comment… (max 500 characters)';

  @override
  String get yourLibrary => 'Your Library';

  @override
  String get yourMessage => 'Your message';
}
