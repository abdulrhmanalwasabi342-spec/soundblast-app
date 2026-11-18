// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get accessOffBody => 'يستطيع ساوند بلاست تشغيل الأغاني الموجودة على هاتفك — حتى بدون إنترنت.';

  @override
  String get accessOffTitle => 'الوصول لأغاني الجهاز متوقف';

  @override
  String get addSongsHint => 'أضف أغانٍ من مكتبة الجهاز (⋮ على أي أغنية).';

  @override
  String get addToPlaylist => 'إضافة إلى قائمة تشغيل';

  @override
  String addedToPlaylist(String name) {
    return 'تمت الإضافة إلى \"$name\"';
  }

  @override
  String get admin => 'الإدارة';

  @override
  String get albumNotFound => 'الألبوم غير موجود';

  @override
  String albumsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ألبوم',
      many: '$count ألبومًا',
      few: '$count ألبومات',
      two: 'ألبومان',
      one: 'ألبوم واحد',
      zero: 'لا توجد ألبومات',
    );
    return '$_temp0';
  }

  @override
  String get allSongs => 'كل الأغاني';

  @override
  String get allTracks => 'كل الأغاني';

  @override
  String get appName => 'SoundBlast';

  @override
  String get artistNotFound => 'الفنان غير موجود';

  @override
  String get artistPageMissing => 'صفحة هذا الفنان غير موجودة.';

  @override
  String get artists => 'الفنانون';

  @override
  String artistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فنان',
      many: '$count فنانًا',
      few: '$count فنانين',
      two: 'فنانان',
      one: 'فنان واحد',
      zero: 'لا يوجد فنانون',
    );
    return '$_temp0';
  }

  @override
  String get artistsToExplore => 'فنانون للاستكشاف';

  @override
  String get authAcceptTerms => 'أوافق على الشروط وسياسة الخصوصية';

  @override
  String get authAcceptTermsFirst => 'يرجى الموافقة على الشروط وسياسة الخصوصية.';

  @override
  String get authAddPhoto => 'أضف صورة شخصية (اختياري)';

  @override
  String get authAlreadyHaveAccount => 'لدي حساب بالفعل — تسجيل الدخول';

  @override
  String get authArtist => 'فنان';

  @override
  String get authArtistNeedsStage => 'الفنان يحتاج اسمًا فنيًا.';

  @override
  String get authBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get authContactSupport => 'تواصل مع الدعم';

  @override
  String get authContinueGithub => 'المتابعة مع GitHub';

  @override
  String get authContinueGoogle => 'المتابعة مع Google';

  @override
  String get authCreateAccount => 'إنشاء الحساب';

  @override
  String get authCreateNew => 'أنشئ حسابًا جديدًا';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authEnter => 'ادخل ساوند بلاست';

  @override
  String get authEnterDetails => 'أدخل اسمك وبريدًا صحيحًا وكلمة مرور من 8 أحرف على الأقل.';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور';

  @override
  String get authForgotPasswordQ => 'نسيت كلمة المرور؟';

  @override
  String get authGoogleNotSetup => 'التسجيل عبر Google غير مفعّل على الخادم بعد.';

  @override
  String get authJoinSub => 'ساوند بلاست · انضم إلى الموسيقى';

  @override
  String get authJoiningAs => 'أنضم كـ:';

  @override
  String get authListener => 'مستمع';

  @override
  String get authLoginSub => 'سجّل الدخول لتواصل الاستماع.';

  @override
  String get authOrContinue => 'أو تابع بواسطة';

  @override
  String get authOrSignupWith => 'أو سجّل بواسطة';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authPasswordHint => '8 أحرف على الأقل';

  @override
  String get authPhotoRetry => 'فشل رفع الصورة — ستتم إعادة المحاولة عند إنشاء الحساب.';

  @override
  String get authPhotoTooBig => 'الصورة أكبر من 5 ميغابايت.';

  @override
  String get authReadTerms => 'اقرأ الشروط والخصوصية والأذونات';

  @override
  String get authStageName => 'الاسم الفني';

  @override
  String get authWelcomeBack => 'أهلاً بعودتك.';

  @override
  String get authWelcomeBackSub => 'ساوند بلاست · أهلاً بعودتك';

  @override
  String get authYourName => 'اسمك';

  @override
  String get browseDeviceSongs => 'تصفح أغاني هذا الجهاز';

  @override
  String get browseGenres => 'تصفح الأنواع';

  @override
  String get browseMusic => 'تصفح الموسيقى';

  @override
  String get browseReleases => 'تصفح الإصدارات ↗';

  @override
  String get cancel => 'إلغاء';

  @override
  String get catAlbums => 'الألبومات';

  @override
  String get catArtists => 'الفنانون';

  @override
  String get catComposers => 'الملحنون';

  @override
  String get catFolders => 'المجلدات';

  @override
  String get catGenres => 'الأنواع';

  @override
  String get catTracks => 'الأغاني';

  @override
  String get close => 'إغلاق';

  @override
  String get comments => 'التعليقات';

  @override
  String composersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملحن',
      many: '$count ملحنًا',
      few: '$count ملحنين',
      two: 'ملحنان',
      one: 'ملحن واحد',
      zero: 'لا يوجد ملحنون',
    );
    return '$_temp0';
  }

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createPlaylist => 'إنشاء قائمة تشغيل';

  @override
  String get createPlaylistDraft => 'إنشاء قائمة تشغيل (كمسودة)';

  @override
  String get createPlaylistHint => 'أنشئ قائمة تشغيل وأضف إليها أغانٍ.';

  @override
  String get delete => 'حذف';

  @override
  String get deleteComment => 'حذف التعليق';

  @override
  String get deleteCommentConfirm => 'حذف هذا التعليق؟';

  @override
  String get deleteDownload => 'حذف التنزيل';

  @override
  String deleteDownloadConfirm(String title) {
    return 'حذف النسخة بدون نت من \"$title\"؟ الأغنية تبقى على ساوند بلاست.';
  }

  @override
  String get deletePlaylist => 'حذف قائمة التشغيل';

  @override
  String deletePlaylistConfirm(String name) {
    return 'حذف \"$name\"؟ الأغاني تبقى على هذا الجهاز.';
  }

  @override
  String get downloadedSubtitle => 'محفوظة في التطبيق — تعمل بدون إنترنت';

  @override
  String get downloadedTitle => 'منزّلة من ساوند بلاست';

  @override
  String foldersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مجلد',
      many: '$count مجلدًا',
      few: '$count مجلدات',
      two: 'مجلدان',
      one: 'مجلد واحد',
      zero: 'لا توجد مجلدات',
    );
    return '$_temp0';
  }

  @override
  String get gallery => 'المعرض';

  @override
  String get galleryEmpty => 'المعرض فارغ';

  @override
  String get genres => 'الأنواع';

  @override
  String genresCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نوع',
      many: '$count نوعًا',
      few: '$count أنواع',
      two: 'نوعان',
      one: 'نوع واحد',
      zero: 'لا توجد أنواع',
    );
    return '$_temp0';
  }

  @override
  String goToArtist(String artist) {
    return 'الانتقال إلى الفنان: $artist';
  }

  @override
  String get guestMessage => 'سجّل الدخول أو أنشئ حسابًا للإعجاب بالأغاني وحفظ المفضلة وبناء قوائم التشغيل ورفع الموسيقى ومتابعة الفنانين.';

  @override
  String get guestTitle => 'تتصفح كضيف';

  @override
  String get hideLyrics => 'إخفاء الكلمات';

  @override
  String get joinSubtitle => 'أنشئ حسابك لتبدأ الاستماع.';

  @override
  String get joinTitle => 'انضم إلى ساوند بلاست';

  @override
  String get language => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageSystem => 'لغة الجهاز';

  @override
  String get libraryLoginMessage => 'الأغاني المعجبة والمفضلة وقوائم التشغيل موجودة في حسابك.';

  @override
  String get libraryLoginTitle => 'سجّل الدخول لعرض مكتبتك';

  @override
  String likesCount(String count) {
    return '$count إعجاب';
  }

  @override
  String get listenWithIntent => 'استمع بقصد';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginPlaylistMessage => 'قوائم التشغيل خاصة بحسابك.';

  @override
  String get loginPlaylistTitle => 'سجّل الدخول لعرض قائمة التشغيل هذه';

  @override
  String get loginPlaylistsTitle => 'سجّل الدخول لعرض قوائم التشغيل';

  @override
  String get loginToComment => 'سجّل الدخول للتعليق.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get lyrics => 'الكلمات';

  @override
  String get meetArtists => 'تعرّف على الفنانين';

  @override
  String get menu => 'القائمة';

  @override
  String get moodsGenres => 'المزاج والأنواع';

  @override
  String get mostFollowed => 'الأكثر متابعة على ساوند بلاست';

  @override
  String get mostPlayedWeek => 'الأكثر تشغيلًا هذا الأسبوع';

  @override
  String get myPlaylistsOffline => 'قوائم تشغيلي (بدون نت)';

  @override
  String get navAddPlaylist => 'إضافة قائمة تشغيل';

  @override
  String get navAlbums => 'الألبومات';

  @override
  String get navArtistPosts => 'منشورات الفنانين';

  @override
  String get navArtists => 'الفنانون';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navDiscover => 'اكتشف';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get navFeedback => 'ملاحظات';

  @override
  String get navGenres => 'الأنواع';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navLikedSongs => 'الأغاني المعجبة';

  @override
  String get navMenu => 'القائمة';

  @override
  String get navMusicPlayer => 'مشغل الموسيقى';

  @override
  String get navPlaylists => 'قوائم التشغيل';

  @override
  String get navTrendingSongs => 'الأغاني الرائجة';

  @override
  String get newLabel => 'جديد';

  @override
  String get newPlaylist => 'قائمة تشغيل جديدة';

  @override
  String get next => 'التالي';

  @override
  String get noAlbums => 'لا توجد ألبومات بعد';

  @override
  String get noArtistPosts => 'لم يشارك الفنانون أي منشورات عامة بعد.';

  @override
  String get noArtists => 'لا يوجد فنانون بعد';

  @override
  String get noAudioFound => 'لا توجد ملفات صوتية على هذا الجهاز.';

  @override
  String get noCategorySongs => 'لا توجد أغانٍ على الجهاز في هذا التصنيف.';

  @override
  String get noComments => 'لا توجد تعليقات بعد — كن أول من يقول شيئًا.';

  @override
  String get noDownloads => 'لا توجد تنزيلات بعد. استخدم ⋮ ← تنزيل للاستماع بدون نت لأي أغنية.';

  @override
  String get noGenres => 'لا توجد أنواع بعد';

  @override
  String get noGenresEmpty => 'لا توجد أنواع بعد — المكتبة فارغة.';

  @override
  String get noLyrics => 'لا توجد كلمات لهذه الأغنية';

  @override
  String get noOfflinePlaylists => 'لا توجد قوائم تشغيل بدون نت بعد. أنشئ واحدة، ثم أضف أغانٍ بالضغط على ⋮ لأي أغنية على الجهاز.';

  @override
  String get noPlaylists => 'لا توجد قوائم تشغيل بعد';

  @override
  String get noPosts => 'لا توجد منشورات بعد';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String noSlugSongs(String slug) {
    return 'لا توجد أغانٍ لـ $slug بعد';
  }

  @override
  String get noSongsHere => 'لا توجد أغانٍ هنا';

  @override
  String get noSongsInLibrary => 'لا توجد أغانٍ في المكتبة بعد.';

  @override
  String get noSongsYet => 'لا توجد أغانٍ بعد';

  @override
  String get noTrending => 'لا توجد أغانٍ رائجة بعد';

  @override
  String get nothingHere => 'لا شيء هنا بعد';

  @override
  String get nothingMatches => 'لا يوجد ما يطابق على هذا الجهاز.';

  @override
  String get nothingPlaying => 'لا يوجد ما يعمل الآن';

  @override
  String get nowPlaying => 'يُشغَّل الآن';

  @override
  String get nowPlayingTitle => 'يُشغَّل الآن';

  @override
  String get oauthAndroidOnly => 'استخراج ملف تعريف GitHub يعمل على أندرويد فقط.';

  @override
  String get oauthCheckAccount => 'سجلت دخولي — تحقق من حسابي';

  @override
  String get oauthInAppNote => 'ستسجل الدخول مع GitHub في هذه النافذة. عندما يعيدك GitHub إلى ساوند بلاست، يسجّل التطبيق دخولك تلقائيًا.';

  @override
  String oauthLoadFailed(String error) {
    return 'تعذر تحميل صفحة تسجيل الدخول ($error). تحقق من اتصالك وحاول مجددًا.';
  }

  @override
  String get oauthNoSession => 'تسجيل الدخول مع GitHub لم ينشئ جلسة. حاول مجددًا.';

  @override
  String get oauthServerStarting => 'الخادم يبدأ أو يتحدث الآن. انتظر لحظة واضغط إعادة المحاولة — صفحة GitHub تفتح داخل التطبيق.';

  @override
  String get oauthTitle => 'تسجيل الدخول مع GitHub';

  @override
  String get onDeviceSubtitle => 'ملفات صوتية موجودة على هاتفك';

  @override
  String get onDeviceTitle => 'على هذا الجهاز';

  @override
  String get onboardingArtist => 'هل أنت فنان؟';

  @override
  String get onboardingArtistBody => 'انشر أغانيك، وابنِ ألبومات، واصِل إلى المستمعين — من هاتفك مباشرة. سجّل كفنان لتبدأ.';

  @override
  String get onboardingBeat => 'اشعر بالإيقاع.';

  @override
  String get onboardingBeatBody => 'ساوند بلاست بيت للموسيقى المستقلة — اكتشف أغانٍ جديدة، وتابع الفنانين الذين تحبهم، واحتفظ بكل شيء في مكان واحد.';

  @override
  String get onboardingFollow => 'تابع الفنانين.';

  @override
  String get onboardingFollowBody => 'تصلك إشعارات عندما يصدر الفنانون الذين تتابعهم أغانٍ جديدة أو يشاركون منشورات. خلاصتك تكبر مع الموسيقى التي تحبها.';

  @override
  String get pickSongHint => 'اختر أغنية من الرئيسية أو اكتشف أو البحث لتبدأ الاستماع.';

  @override
  String get play => 'تشغيل';

  @override
  String get playAlbum => 'تشغيل الألبوم';

  @override
  String get playAll => 'تشغيل الكل';

  @override
  String get playNext => 'تشغيل التالي';

  @override
  String get playbackStopped => 'تم إيقاف التشغيل — تمت إزالة إشعار المشغل.';

  @override
  String get playlistNameHint => 'اسم قائمة التشغيل';

  @override
  String get playlistNotFound => 'قائمة التشغيل غير موجودة';

  @override
  String get popularArtists => 'الفنانون المشهورون';

  @override
  String get posts => 'المنشورات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get queue => 'قائمة التشغيل';

  @override
  String get quickLinks => 'روابط سريعة';

  @override
  String get releasePrivate => 'قد يكون هذا الإصدار خاصًا أو محذوفًا.';

  @override
  String get removeFromPlaylist => 'إزالة من قائمة التشغيل';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get renamePlaylist => 'إعادة تسمية قائمة التشغيل';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get roleAdmin => 'مدير النظام';

  @override
  String get roleArtist => 'فنان';

  @override
  String get roleListener => 'مستمع';

  @override
  String get save => 'حفظ';

  @override
  String get search => 'بحث';

  @override
  String get searchHint => 'ابحث عن أغاني، فنانين، أنواع…';

  @override
  String get showLyrics => 'عرض الكلمات';

  @override
  String get shuffle => 'عشوائي';

  @override
  String get sitemap => 'خريطة الموقع';

  @override
  String get skip => 'تخطي';

  @override
  String get songs => 'الأغاني';

  @override
  String songsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أغنية',
      many: '$count أغنية',
      few: '$count أغانٍ',
      two: 'أغنيتان',
      one: 'أغنية واحدة',
      zero: 'لا توجد أغانٍ',
    );
    return '$_temp0';
  }

  @override
  String get stopPlayback => 'إيقاف التشغيل (يزيل إشعار المشغل)';

  @override
  String get trending => 'الرائج';

  @override
  String get unknownAlbum => 'ألبوم غير معروف';

  @override
  String get unknownComposer => 'ملحن غير معروف';

  @override
  String get unknownFolder => 'مجلد غير معروف';

  @override
  String get unknownGenre => 'نوع غير معروف';

  @override
  String get upNext => 'التالي';

  @override
  String get uploadSong => 'رفع أغنية';

  @override
  String get weeklyTop => 'الأفضل هذا الأسبوع';

  @override
  String get writeComment => 'اكتب تعليقًا… (بحد أقصى 500 حرف)';

  @override
  String get yourLibrary => 'مكتبتك';
}
