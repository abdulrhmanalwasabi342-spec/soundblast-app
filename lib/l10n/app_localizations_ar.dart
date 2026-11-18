// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get aboutBody1 => 'ساوند بلاست منصة موسيقية للفنانين المستقلين والمستمعين الذين يحبونهم. اكتشف أغانٍ جديدة، وتابع الفنانين، وابنِ قوائم تشغيل، وإن كنت تصنع الموسيقى — انشر إصداراتك الخاصة واصِل إلى آذان جديدة.';

  @override
  String get aboutBody2 => 'كل ما تسمعه هنا نشره فنانون حقيقيون على المنصة. الإعجابات والتعليقات والمتابعات وقوائم التشغيل مشتركة بين الموقع وهذا التطبيق، لأن كليهما يتحدث إلى نفس خادم ساوند بلاست.';

  @override
  String get aboutSoundBlast => 'عن SoundBlast';

  @override
  String get accessOffBody => 'يستطيع ساوند بلاست تشغيل الأغاني الموجودة على هاتفك — حتى بدون إنترنت.';

  @override
  String get accessOffTitle => 'الوصول لأغاني الجهاز متوقف';

  @override
  String get activateAccount => 'تفعيل الحساب';

  @override
  String get activateArtist => 'تفعيل الفنان';

  @override
  String get activationCasesHint => 'حسابات فنانين لم تكمل التفعيل.';

  @override
  String activationStatus(String status) {
    return 'التفعيل: $status';
  }

  @override
  String addMissingToContinue(Object missing) {
    return 'أضف $missing للمتابعة.';
  }

  @override
  String get addSongsFromMenu => 'أضف أغانٍ من قائمة أي أغنية (⋮ ← إضافة إلى قائمة تشغيل).';

  @override
  String get addSongsHint => 'أضف أغانٍ من مكتبة الجهاز (⋮ على أي أغنية).';

  @override
  String get addToPlaylist => 'إضافة إلى قائمة تشغيل';

  @override
  String addedToName(String name) {
    return 'تمت الإضافة إلى $name.';
  }

  @override
  String addedToPlaylist(String name) {
    return 'تمت الإضافة إلى \"$name\"';
  }

  @override
  String get admin => 'الإدارة';

  @override
  String get adminDefaultNotification => 'رسالة من ساوند بلاست';

  @override
  String get adminRestricted => 'هذه المنطقة مقصورة على مسؤولي ساوند بلاست.';

  @override
  String get adminShort => 'مسؤول';

  @override
  String get adminTabAnalytics => 'التحليلات';

  @override
  String get adminTabArtists => 'الفنانون';

  @override
  String get adminTabContent => 'المحتوى';

  @override
  String get adminTabHomePlatform => 'الرئيسية والمنصة';

  @override
  String get adminTabOverview => 'نظرة عامة';

  @override
  String get adminTabSystemSafety => 'النظام والأمان';

  @override
  String get adminTabUsers => 'المستخدمون';

  @override
  String get adminsOnly => 'للمسؤولين فقط';

  @override
  String get albumNameOptional => 'اسم الألبوم (اختياري)';

  @override
  String get albumNotFound => 'الألبوم غير موجود';

  @override
  String get albumsAppearHint => 'تظهر الألبومات هنا عندما ينشر الفنانون إصدارات.';

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
  String get allArtists => 'كل الفنانين';

  @override
  String get allSongs => 'كل الأغاني';

  @override
  String get allTracks => 'كل الأغاني';

  @override
  String get appName => 'SoundBlast';

  @override
  String get appVersionLabel => 'الإصدار 1.0.26 — تطبيق أندرويد';

  @override
  String get archive => 'أرشفة';

  @override
  String get artistAccountsOnly => 'حسابات الفنانين فقط';

  @override
  String get artistActivationCases => 'حالات تفعيل الفنانين';

  @override
  String get artistNotFound => 'الفنان غير موجود';

  @override
  String get artistPageMissing => 'صفحة هذا الفنان غير موجودة.';

  @override
  String artistStats(String followers, String plays, String songs) {
    return '$followers متابع • $songs أغنية • $plays تشغيل';
  }

  @override
  String get artistStudio => 'استوديو الفنان';

  @override
  String get artists => 'الفنانون';

  @override
  String get artistsAppearHint => 'يظهر الفنانون هنا عندما يسجّلون وينشرون.';

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
  String get artistsYouFollow => 'الفنانون الذين تتابعهم';

  @override
  String get artworkAppearHint => 'تظهر أغلفة الأغاني هنا عندما تُنشر أغانٍ بصور غلاف.';

  @override
  String get audioSelected => 'تم اختيار الملف الصوتي';

  @override
  String get auditLog => 'سجل التدقيق';

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
  String get authSessionFailed => 'تسجيل الدخول لم ينشئ جلسة. حاول مجددًا.';

  @override
  String get authStageName => 'الاسم الفني';

  @override
  String get authWelcomeBack => 'أهلاً بعودتك.';

  @override
  String get authWelcomeBackSub => 'ساوند بلاست · أهلاً بعودتك';

  @override
  String get authYourName => 'اسمك';

  @override
  String get bio => 'نبذة';

  @override
  String get bioLabel => 'نبذة';

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
  String get cannotPlayDeviceFile => 'تعذّر فتح هذا الملف على جهازك. قد يكون تالفًا أو محذوفًا أو بصيغة غير مدعومة.';

  @override
  String get cannotPlaySong => 'تعذّر تشغيل هذه الأغنية. تحقّق من الاتصال وحاول مجددًا.';

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
  String get category => 'الفئة';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get chooseArtwork => 'اختر صورة الغلاف (PNG أو JPG أو WEBP)';

  @override
  String get chooseAudioFile => 'اختر ملفًا صوتيًا (MP3 أو WAV أو M4A)';

  @override
  String get cleanLibraryIntegrity => 'تنظيف سلامة المكتبة';

  @override
  String get clearEngagement => 'مسح التفاعل';

  @override
  String get clearFavorites => 'مسح المفضلة [جديد]';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get clearVisitorHistory => 'مسح سجل الزوار';

  @override
  String get close => 'إغلاق';

  @override
  String get comments => 'التعليقات';

  @override
  String get commentsModeration => 'إشراف التعليقات';

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
  String get confirm => 'تأكيد';

  @override
  String get confirmRights => 'أؤكد أنني أملك حقوق نشر هذه الأغنية.';

  @override
  String get confirmRightsFirst => 'يرجى تأكيد أنك تملك حقوق نشر هذه الأغنية.';

  @override
  String get contact => 'تواصل معنا';

  @override
  String get contactBody => 'أسئلة أو مشاكل أو بلاغ عن محتوى في ساوند بلاست؟ أرسل ملاحظاتك من صفحة الملاحظات — تصل مباشرة إلى فريق ساوند بلاست — أو زر صفحة التواصل في الموقع.';

  @override
  String get contactInboxGap => 'الموقع ليس لديه نقطة نهاية لصندوق رسائل التواصل بعد — التواصل حاليًا يمر عبر الملاحظات. مذكور كفجوة مسماة في README.md.';

  @override
  String get contactMessagesInbox => 'صندوق رسائل التواصل [جديد]';

  @override
  String get copyrightBody => 'إذا كان محتوى في ساوند بلاست ينتهك حقوقك، أرسل بلاغ حقوق نشر من صفحة الملاحظات (اختر فئة بلاغ حقوق النشر). يراجع البلاغات مسؤولو ساوند بلاست.';

  @override
  String get copyrightReports => 'بلاغات حقوق النشر';

  @override
  String get couldNotOpenWebsite => 'تعذر فتح الموقع.';

  @override
  String get couldNotReadFiles => 'تعذر قراءة الملفات المحددة.';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createButton => 'إنشاء';

  @override
  String get createFirstPlaylistHint => 'أنشئ أول قائمة تشغيل وأضف إليها أغانٍ.';

  @override
  String get createPlaylist => 'إنشاء قائمة تشغيل';

  @override
  String get createPlaylistDraft => 'إنشاء قائمة تشغيل (كمسودة)';

  @override
  String get createPlaylistHint => 'أنشئ قائمة تشغيل وأضف إليها أغانٍ.';

  @override
  String get createUser => 'إنشاء مستخدم';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get dangerZoneNote => 'الإجراءات الجماعية تحذف بيانات المنصة نهائيًا. كل إجراء يحتاج كتابة عبارة التأكيد الخاصة به.';

  @override
  String get dashboardGlance => 'ساوند بلاست في لمحة';

  @override
  String get dashboardGuestNote => 'إجماليات المنصة أعلاه عامة. مكتبتك ورفوعاتك والاستوديو تحتاج حسابًا.';

  @override
  String get delete => 'حذف';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAllAccounts => 'حذف كل الحسابات';

  @override
  String get deleteAllComments => 'حذف كل التعليقات';

  @override
  String deleteAllCommentsOn(String title) {
    return 'حذف كل التعليقات على \"$title\"؟';
  }

  @override
  String get deleteAllItsComments => 'حذف كل تعليقاتها';

  @override
  String get deleteAllPlaylists => 'حذف كل قوائم التشغيل';

  @override
  String get deleteComment => 'حذف التعليق';

  @override
  String get deleteCommentConfirm => 'حذف هذا التعليق؟';

  @override
  String get deleteComments => 'حذف التعليقات';

  @override
  String get deleteDownload => 'حذف التنزيل';

  @override
  String deleteDownloadConfirm(String title) {
    return 'حذف النسخة بدون نت من \"$title\"؟ الأغنية تبقى على ساوند بلاست.';
  }

  @override
  String get deleteOauthUser => 'حذف مستخدم OAuth';

  @override
  String get deletePlaylist => 'حذف قائمة التشغيل';

  @override
  String deletePlaylistConfirm(String name) {
    return 'حذف \"$name\"؟ الأغاني تبقى على هذا الجهاز.';
  }

  @override
  String get deletePlaylistConfirmPerm => 'حذف قائمة التشغيل هذه نهائيًا؟';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get deletePostConfirm => 'حذف هذا المنشور؟';

  @override
  String get deleteRelease => 'حذف الإصدار';

  @override
  String get deleteReleaseConfirm => 'حذف هذا الإصدار نهائيًا؟';

  @override
  String get deleteSong => 'حذف الأغنية';

  @override
  String deleteSongConfirm(String title) {
    return 'حذف \"$title\" نهائيًا؟';
  }

  @override
  String get deleteUser => 'حذف المستخدم';

  @override
  String get deleteUserConfirm => 'حذف هذا الحساب نهائيًا؟ حساب المالك لا يمكن حذفه أبدًا.';

  @override
  String get deleteVisitorHistoryConfirm => 'حذف كل سجل الزوار المسجّل؟';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String doneResult(String result) {
    return 'تم: $result';
  }

  @override
  String get downloadForOffline => 'تنزيل للاستماع بدون نت';

  @override
  String get downloadedAvailableOffline => 'تم التنزيل — متاحة بدون نت في المكتبة ← المنزّلة.';

  @override
  String get downloadedPlayOffline => 'منزّلة — تشغيل بدون نت';

  @override
  String get downloadedSubtitle => 'محفوظة في التطبيق — تعمل بدون إنترنت';

  @override
  String get downloadedTitle => 'منزّلة من ساوند بلاست';

  @override
  String downloadingSong(String title) {
    return 'جارٍ تنزيل $title…';
  }

  @override
  String durationLabel(String time) {
    return 'المدة: $time';
  }

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get editProfileArtistsOnly => 'تعديل الملف الشخصي متاح لحسابات الفنانين.';

  @override
  String get editUser => 'تعديل المستخدم';

  @override
  String get exploreMusic => 'استكشف الموسيقى';

  @override
  String get featuredNow => 'مميز الآن';

  @override
  String get feedbackCopyrightReport => 'بلاغ حقوق نشر';

  @override
  String get feedbackInbox => 'صندوق الملاحظات';

  @override
  String get feedbackIntro => 'بلاغات الأخطاء والأفكار وطلبات الخصوصية وبلاغات حقوق النشر تصل كلها إلى فريق ساوند بلاست.';

  @override
  String get feedbackMinChars => 'يرجى كتابة 10 أحرف على الأقل.';

  @override
  String get feedbackPrivacyRequest => 'طلب خصوصية';

  @override
  String get feedbackSentThanks => 'شكرًا — تم إرسال ملاحظاتك.';

  @override
  String get fieldName => 'الاسم';

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
  String get follow => 'متابعة';

  @override
  String get followedArtistsNote => 'تظهر الإصدارات الجديدة من هؤلاء الفنانين في صندوق إشعاراتك.';

  @override
  String followersCount(String count) {
    return '$count متابع';
  }

  @override
  String get followersOnly => 'للمتابعين فقط';

  @override
  String get following => 'تتابعه';

  @override
  String get freshFrom => 'جديد من';

  @override
  String get gallery => 'المعرض';

  @override
  String get galleryEmpty => 'المعرض فارغ';

  @override
  String get genre => 'النوع';

  @override
  String get genres => 'الأنواع';

  @override
  String get genresAppearHint => 'تظهر الأنواع هنا عندما ينشر الفنانون أغانٍ.';

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
  String get getInTouch => 'تواصل معنا';

  @override
  String get givePlaylistName => 'أعطِ قائمة التشغيل اسمًا.';

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String goToArtist(String artist) {
    return 'الانتقال إلى الفنان: $artist';
  }

  @override
  String get grantAdminOwner => 'منح صلاحية المسؤول (المالك فقط)';

  @override
  String get guestMessage => 'سجّل الدخول أو أنشئ حسابًا للإعجاب بالأغاني وحفظ المفضلة وبناء قوائم التشغيل ورفع الموسيقى ومتابعة الفنانين.';

  @override
  String get guestTitle => 'تتصفح كضيف';

  @override
  String get heroActionOrderHint => 'يتحكم في الإجراء الذي يعرضه زر واجهة الرئيسية أولاً.';

  @override
  String heroActionOrderSet(int n) {
    return 'تم ضبط ترتيب إجراء الواجهة على الإعداد $n.';
  }

  @override
  String get heroBody => 'بيت مركّز للإصدارات وقصص الفنانين والأغاني التي تستحق إعادة الاستماع. مبني حول الأشخاص الذين يصنعون الموسيقى.';

  @override
  String get heroLine1 => 'اعثر على الصوت';

  @override
  String get heroLine2 => 'الذي يبقى';

  @override
  String get heroLine3 => 'معك.';

  @override
  String get hideLyrics => 'إخفاء الكلمات';

  @override
  String get hideUnpublish => 'إخفاء (إلغاء النشر)';

  @override
  String get homeHeroActionOrder => 'ترتيب إجراء واجهة الرئيسية';

  @override
  String get homeSummaryUnavailable => 'ملخص الرئيسية غير متاح على الخادم الآن — نعرض الأغاني مباشرة.';

  @override
  String get integrityEmptyPlaylists => 'قوائم تشغيل فارغة';

  @override
  String get integrityOrphanPlaylistSongs => 'أغانٍ يتيمة في قوائم التشغيل';

  @override
  String get integrityRawPlayEvents => 'أحداث تشغيل خام';

  @override
  String get integrityRemovableEmptyPlaylists => 'قوائم تشغيل فارغة قابلة للإزالة';

  @override
  String get integritySongsMissingSize => 'أغانٍ بدون حجم';

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
  String last7DaysPlays(String plays) {
    return 'آخر 7 أيام: $plays تشغيل';
  }

  @override
  String libraryCleanupDone(String result) {
    return 'تم تنظيف المكتبة: $result';
  }

  @override
  String get libraryEmptyHint => 'مكتبة ساوند بلاست فارغة الآن. يستطيع الفنانون نشر أول الأغاني من صفحة الرفع.';

  @override
  String get libraryIntegrity => 'سلامة المكتبة';

  @override
  String get libraryLoginMessage => 'الأغاني المعجبة والمفضلة وقوائم التشغيل موجودة في حسابك.';

  @override
  String get libraryLoginTitle => 'سجّل الدخول لعرض مكتبتك';

  @override
  String get libraryMaintenance => 'صيانة المكتبة';

  @override
  String get likeAction => 'إعجاب';

  @override
  String likesCount(String count) {
    return '$count إعجاب';
  }

  @override
  String get listenWithIntent => 'استمع بقصد';

  @override
  String get listenerCannotOpenStudio => 'حسابك حساب مستمع. سجّل كفنان لفتح الاستوديو.';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginAsArtist => 'سجّل الدخول كفنان';

  @override
  String get loginAsArtistUpload => 'سجّل الدخول كفنان لرفع الأغاني.';

  @override
  String get loginFirst => 'سجّل الدخول أولاً';

  @override
  String get loginForDashboard => 'سجّل الدخول لعرض لوحة التحكم الخاصة بك';

  @override
  String get loginPlaylistMessage => 'قوائم التشغيل خاصة بحسابك.';

  @override
  String get loginPlaylistTitle => 'سجّل الدخول لعرض قائمة التشغيل هذه';

  @override
  String get loginPlaylistsTitle => 'سجّل الدخول لعرض قوائم التشغيل';

  @override
  String get loginToComment => 'سجّل الدخول للتعليق.';

  @override
  String get loginToCreatePlaylist => 'سجّل الدخول لإنشاء قائمة تشغيل.';

  @override
  String get loginToFollow => 'سجّل الدخول لمتابعة الفنانين.';

  @override
  String get loginToLike => 'سجّل الدخول للإعجاب بالأغاني.';

  @override
  String get loginToSaveFavorites => 'سجّل الدخول لحفظ المفضلة.';

  @override
  String get loginToSeeNotifications => 'سجّل الدخول لعرض الإشعارات';

  @override
  String get loginToSendFeedback => 'سجّل الدخول لإرسال ملاحظات.';

  @override
  String get loginToSendFeedbackNote => 'سجّل الدخول لإرسال ملاحظات — تُحفظ تحت حسابك.';

  @override
  String get loginToUsePlaylists => 'سجّل الدخول لاستخدام قوائم التشغيل.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'تسجيل الخروج من ساوند بلاست على هذا الجهاز؟';

  @override
  String get lostAccessContactSupport => 'إذا فقدت الوصول إلى حسابك، تواصل مع دعم ساوند بلاست من صفحة التواصل وأرفق البريد الإلكتروني لحسابك.';

  @override
  String get lyrics => 'الكلمات';

  @override
  String get maintenanceGap => 'الموقع ليس لديه نقطة نهاية لوضع الصيانة — التطبيق يدرجه كفجوة مسماة (انظر README.md). استخدم Render لإيقاف الخدمة إذا لزمت الصيانة.';

  @override
  String get makeAdminOwner => 'جعله مسؤولاً (المالك فقط)';

  @override
  String get makeUser => 'جعله مستخدمًا';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get markRead => 'تحديد كمقروء';

  @override
  String get markReviewed => 'تحديد كمُراجَع';

  @override
  String get markVerified => 'تحديد كموثّق';

  @override
  String marksOfLove(String count) {
    return '$count علامة حب من المجتمع';
  }

  @override
  String get meetArtists => 'تعرّف على الفنانين';

  @override
  String get menu => 'القائمة';

  @override
  String get messageLengthHint => '10 أحرف على الأقل، حتى 2000 حرف.';

  @override
  String get missingArtwork => 'صورة الغلاف';

  @override
  String get missingAudio => 'الملف الصوتي';

  @override
  String get missingTitle => 'عنوان الأغنية';

  @override
  String get moodsGenres => 'المزاج والأنواع';

  @override
  String get mostFollowed => 'الأكثر متابعة على ساوند بلاست';

  @override
  String get mostPlayed7Days => 'الأكثر تشغيلاً في آخر 7 أيام';

  @override
  String get mostPlayedWeek => 'الأكثر تشغيلًا هذا الأسبوع';

  @override
  String get myPlaylistsOffline => 'قوائم تشغيلي (بدون نت)';

  @override
  String get myPosts => 'منشوراتي';

  @override
  String get myReleases => 'إصداراتي';

  @override
  String get mySongs => 'أغانيّ';

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
  String get navProfileShort => 'ملفي';

  @override
  String get navTrendingSongs => 'الأغاني الرائجة';

  @override
  String get newInRoom => 'جديد في الغرفة';

  @override
  String get newLabel => 'جديد';

  @override
  String get newPasswordMin8 => 'كلمة المرور الجديدة (8 أحرف على الأقل)';

  @override
  String get newPlaylist => 'قائمة تشغيل جديدة';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get next => 'التالي';

  @override
  String get nextFavouriteWaiting => 'أغنيتك المفضلة القادمة بانتظارك';

  @override
  String get noAlbums => 'لا توجد ألبومات بعد';

  @override
  String get noArtistPosts => 'لم يشارك الفنانون أي منشورات عامة بعد.';

  @override
  String get noArtistPostsYet => 'لا توجد منشورات فنانين بعد.';

  @override
  String get noArtists => 'لا يوجد فنانون بعد';

  @override
  String get noAudioFound => 'لا توجد ملفات صوتية على هذا الجهاز.';

  @override
  String get noAuditEventsYet => 'لا توجد أحداث تدقيق بعد.';

  @override
  String get noCategorySongs => 'لا توجد أغانٍ على الجهاز في هذا التصنيف.';

  @override
  String get noComments => 'لا توجد تعليقات بعد — كن أول من يقول شيئًا.';

  @override
  String get noCommentsYet => 'لا توجد تعليقات بعد.';

  @override
  String get noDownloads => 'لا توجد تنزيلات بعد. استخدم ⋮ ← تنزيل للاستماع بدون نت لأي أغنية.';

  @override
  String get noDownloadsYet => 'لا توجد تنزيلات بعد. استخدم ⋮ ← تنزيل للاستماع بدون نت على أي أغنية.';

  @override
  String get noFavoritesYet => 'لا توجد مفضلة بعد';

  @override
  String get noFeedbackYet => 'لا توجد ملاحظات بعد.';

  @override
  String get noGenres => 'لا توجد أنواع بعد';

  @override
  String get noGenresEmpty => 'لا توجد أنواع بعد — المكتبة فارغة.';

  @override
  String get noLikedSongsYet => 'لا توجد أغانٍ معجبة بعد';

  @override
  String get noLyrics => 'لا توجد كلمات لهذه الأغنية';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get noNotificationsHint => 'عندما يصدر الفنانون الذين تتابعهم أغانٍ جديدة أو يشاركون منشورات، ستراها هنا.';

  @override
  String get noNotificationsRecorded => 'لم تُسجّل إشعارات بعد.';

  @override
  String get noOauthUsersYet => 'لا يوجد مستخدمو OAuth بعد.';

  @override
  String get noOfflinePlaylists => 'لا توجد قوائم تشغيل بدون نت بعد. أنشئ واحدة، ثم أضف أغانٍ بالضغط على ⋮ لأي أغنية على الجهاز.';

  @override
  String get noPendingActivation => 'لا توجد حالات تفعيل معلقة.';

  @override
  String get noPlaylists => 'لا توجد قوائم تشغيل بعد';

  @override
  String get noPlaylistsCreateFirst => 'لا توجد قوائم تشغيل بعد — أنشئ واحدة أولاً.';

  @override
  String get noPosts => 'لا توجد منشورات بعد';

  @override
  String get noPublicSongsArtist => 'لا توجد أغانٍ عامة من هذا الفنان بعد.';

  @override
  String get noPublicSongsGenre => 'لا توجد أغانٍ عامة في هذا النوع الآن.';

  @override
  String get noPublicSongsRelease => 'لا توجد أغانٍ عامة في هذا الإصدار بعد.';

  @override
  String get noReleasesYet => 'لا توجد إصدارات بعد.';

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
  String get noSongsMatchFilter => 'لا توجد أغانٍ تطابق هذا الفلتر. جرّب نوعًا آخر.';

  @override
  String get noSongsPublished => 'لم تنشر أي أغنية بعد.';

  @override
  String get noSongsShort => 'لا توجد أغانٍ.';

  @override
  String get noSongsYet => 'لا توجد أغانٍ بعد';

  @override
  String get noTrending => 'لا توجد أغانٍ رائجة بعد';

  @override
  String get noUsersYet => 'لا يوجد مستخدمون بعد.';

  @override
  String get noVisitorHistory => 'لا يوجد سجل زوار بعد.';

  @override
  String get noneOption => 'لا شيء';

  @override
  String get notFollowingArtists => 'لا تتابع أي فنان بعد.';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get notVerified => 'غير موثّق';

  @override
  String get nothingHere => 'لا شيء هنا بعد';

  @override
  String get nothingMatches => 'لا يوجد ما يطابق على هذا الجهاز.';

  @override
  String nothingMatchesQuery(String query) {
    return 'لا يوجد ما يطابق \"$query\" بعد. جرّب أغنية أو فنانًا أو نوعًا آخر.';
  }

  @override
  String get nothingPlaying => 'لا يوجد ما يعمل الآن';

  @override
  String get notifPreferences => 'تفضيلات الإشعارات';

  @override
  String get notifPrefsBelongAccount => 'تفضيلات الإشعارات خاصة بحسابك.';

  @override
  String get notificationSent => 'تم إرسال الإشعار.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsEmptyHint => 'تصل هنا الإصدارات الجديدة من الفنانين الذين تتابعهم.';

  @override
  String notificationsState(String state) {
    return 'الإشعارات: $state';
  }

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
  String oauthRoleLabel(String role) {
    return 'الدور: $role';
  }

  @override
  String get oauthServerStarting => 'الخادم يبدأ أو يتحدث الآن. انتظر لحظة واضغط إعادة المحاولة — صفحة GitHub تفتح داخل التطبيق.';

  @override
  String get oauthTitle => 'تسجيل الدخول مع GitHub';

  @override
  String get oauthUsers => 'مستخدمو OAuth';

  @override
  String get offlineShowingCache => 'أنت غير متصل — نعرض آخر مكتبة محفوظة.';

  @override
  String get offlineShowingSaved => 'أنت بدون إنترنت — نعرض آخر مكتبة محفوظة.';

  @override
  String get onDeviceSubtitle => 'ملفات صوتية موجودة على هاتفك';

  @override
  String get onDeviceTitle => 'على هذا الجهاز';

  @override
  String get onThisDevice => 'على هذا الجهاز';

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
  String get onlyArtistsUpload => 'حسابات الفنانين فقط تستطيع رفع الأغاني. سجّل كفنان لنشر الموسيقى.';

  @override
  String get onlyArtistsUploadListener => 'حسابات الفنانين فقط تستطيع رفع الأغاني. حسابك حساب مستمع — أنشئ حساب فنان لنشر الموسيقى.';

  @override
  String get openAdmin => 'فتح الإدارة';

  @override
  String get openAppSettings => 'فتح إعدادات التطبيق';

  @override
  String get openArtistStudio => 'فتح استوديو الفنان';

  @override
  String get openWebsite => 'فتح موقع ساوند بلاست';

  @override
  String get ownerLabel => 'المالك';

  @override
  String get ownerNote => 'حساب المالك (ADMIN_EMAIL) لا يمكن لأي مسؤول آخر تخفيضه أو إيقافه أو حذفه، والمالك وحده من يستطيع منح صلاحية المسؤول للآخرين.';

  @override
  String get pageNotFound => 'الصفحة غير موجودة';

  @override
  String get pageNotFoundBody => 'هذه الصفحة غير موجودة على ساوند بلاست.';

  @override
  String get passwordMin8 => 'كلمة المرور (8 أحرف على الأقل)';

  @override
  String get passwordResetNotConfigured => 'بريد إعادة تعيين كلمة المرور غير مضبوط لساوند بلاست بعد. لحماية حسابك، لن يدّعي هذا التطبيق أن رسالة إعادة تعيين أُرسلت.';

  @override
  String get permAccessOffBody => 'بدون الوصول إلى ملفات الصوت، لا يستطيع ساوند بلاست عرض أو تشغيل الأغاني المخزنة على هذا الجهاز. أغاني ساوند بلاست المنزّلة ما زالت تعمل.\n\nيمكنك السماح بالوصول الآن — هذه آخر مرة نسأل فيها.';

  @override
  String get permAccessOffTitle => 'الوصول ما زال متوقفًا';

  @override
  String get permAllowAccess => 'السماح بالوصول';

  @override
  String get permAskAgain => 'السؤال مجددًا';

  @override
  String get permMediaBody => 'يستطيع ساوند بلاست تشغيل ملفات الصوت الموجودة على هذا الجهاز — أغانيك المنزّلة ومكتبة موسيقاك الخاصة — حتى بدون إنترنت.\n\nسنطلب الوصول إلى ملفات الصوت على هذا الجهاز، فقط لتشغيل موسيقاك. لا يُرفع أي شيء.';

  @override
  String get permMediaTitle => 'تشغيل الأغاني الموجودة على هاتفك';

  @override
  String get permNotifBody => 'عندما تعمل أغنية، يعرض ساوند بلاست مشغله في ستارة الإشعارات — العنوان والفنان والغلاف والتشغيل / الإيقاف / التالي — لتتحكم فيه بينما التطبيق مغلق.\n\nسنطلب مرة واحدة لعرض الإشعارات. إذا تخطيتها، تستمر الموسيقى بالعمل؛ فقط أزرار التحكم في الإشعارات ستكون مفقودة.';

  @override
  String get permNotifTitle => 'إبقاء المشغل في إشعاراتك';

  @override
  String get permShowPlayerControls => 'عرض أزرار المشغل';

  @override
  String get permanentlyDeletesData => 'سيؤدي هذا إلى حذف البيانات نهائيًا، ولا يمكن التراجع عنه.';

  @override
  String get permissionDeclinedTwice => 'رفضت إذن الصوت مرتين، لذا لن يسألك ساوند بلاست مجددًا. ما زال بإمكانك السماح في أي وقت من إعدادات التطبيق — أغاني ساوند بلاست المنزّلة تستمر بالعمل في كل الأحوال.';

  @override
  String get permissions => 'الأذونات';

  @override
  String get permissionsBody => 'يطلب التطبيق الوصول إلى التخزين فقط عندما تختار ملفًا صوتيًا أو صورة غلاف أو صورة شخصية للرفع. يستمر التشغيل أثناء وجود التطبيق في الخلفية حتى لا تنقطع موسيقاك.';

  @override
  String get photoSavedLocally => 'تم حفظ الصورة على هذا الهاتف، وستُزامَن مع ملفك عند جاهزية التخزين.';

  @override
  String get pickSongHint => 'اختر أغنية من الرئيسية أو اكتشف أو البحث لتبدأ الاستماع.';

  @override
  String get pickSongsOptional => 'اختر أغانٍ (اختياري — يمكنك حفظ قائمة فارغة كمسودة وإضافة أغانٍ لاحقًا).';

  @override
  String get play => 'تشغيل';

  @override
  String get playAlbum => 'تشغيل الألبوم';

  @override
  String get playAll => 'تشغيل الكل';

  @override
  String playEventsRolledUp(String result) {
    return 'تم تجميع أحداث التشغيل: $result';
  }

  @override
  String get playHistoryVisitors => 'سجل التشغيل (الزوار)';

  @override
  String get playNext => 'تشغيل التالي';

  @override
  String get playTodaysSignal => 'شغّل إشارة اليوم';

  @override
  String get playbackStopped => 'تم إيقاف التشغيل — تمت إزالة إشعار المشغل.';

  @override
  String get playlistNameHint => 'اسم قائمة التشغيل';

  @override
  String get playlistNotFound => 'قائمة التشغيل غير موجودة';

  @override
  String playsCount(String count) {
    return '$count تشغيل';
  }

  @override
  String get popularArtists => 'الفنانون المشهورون';

  @override
  String get postHint => 'أخبر متابعيك بشيء… (بحد أقصى 1000 حرف)';

  @override
  String get postKindPost => 'منشور';

  @override
  String get postKindRecommendation => 'توصية';

  @override
  String get postShared => 'تمت مشاركة المنشور.';

  @override
  String get posts => 'المنشورات';

  @override
  String postsFeedUnavailable(String error) {
    return 'خلاصة منشورات الفنانين غير متاحة على الخادم الآن ($error). منشورات الفنانين ما زالت تعمل في صفحة كل فنان.';
  }

  @override
  String presetNumber(int n) {
    return 'الإعداد $n';
  }

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacyBody => 'يخزّن حسابك اسمك وبريدك وصورتك الشخصية، إضافة إلى إعجاباتك ومفضلتك وقوائم تشغيلك ومتابعاتك وسجل استماعك حتى تعمل الخدمة عبر الأجهزة. تُحفظ جلستك في ملف تعريف ارتباط آمن على هذا الجهاز. ساوند بلاست لا يبيع بياناتك الشخصية.';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي.';

  @override
  String get publishButton => 'نشر';

  @override
  String get publishIntoReleaseOptional => 'انشر ضمن أحد إصداراتك (اختياري)';

  @override
  String get publishSong => 'نشر الأغنية';

  @override
  String get publishing => 'جارٍ النشر…';

  @override
  String get pushNotificationsDevice => 'الإشعارات الفورية على هذا الجهاز';

  @override
  String get pushNotificationsSent => 'الإشعارات الفورية المرسلة';

  @override
  String get queue => 'قائمة التشغيل';

  @override
  String get quickLinks => 'روابط سريعة';

  @override
  String get recompressLegacyAudio => 'إعادة ضغط الصوت القديم [جديد]';

  @override
  String recompressedBatch(String result) {
    return 'تمت إعادة ضغط الدفعة: $result';
  }

  @override
  String get reconcileSongSizes => 'مطابقة أحجام الأغاني';

  @override
  String reconciledSizes(String result) {
    return 'تمت مطابقة الأحجام: $result';
  }

  @override
  String get releasePrivate => 'قد يكون هذا الإصدار خاصًا أو محذوفًا.';

  @override
  String get releaseRadar => 'رادار الإصدارات';

  @override
  String get releasesAlbums => 'الإصدارات (الألبومات)';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get removeFromPlaylist => 'إزالة من قائمة التشغيل';

  @override
  String get removeVerifiedBadge => 'إزالة شارة التوثيق';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get renamePlaylist => 'إعادة تسمية قائمة التشغيل';

  @override
  String get resetButton => 'إعادة تعيين';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordAction => 'إعادة تعيين كلمة المرور';

  @override
  String resetPasswordFor(String name) {
    return 'إعادة تعيين كلمة المرور — $name';
  }

  @override
  String get resetVisitorCounter => 'إعادة تعيين عدّاد الزوّار';

  @override
  String get restore => 'استعادة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get revokeAdminOwner => 'سحب صلاحية المسؤول (المالك فقط)';

  @override
  String get roleAdmin => 'مدير النظام';

  @override
  String get roleArtist => 'فنان';

  @override
  String get roleListener => 'مستمع';

  @override
  String get rollUpPlayEvents => 'تجميع أحداث التشغيل (45 يومًا)';

  @override
  String get save => 'حفظ';

  @override
  String get saveToFavorites => 'حفظ في المفضلة';

  @override
  String get saving => 'جارٍ الحفظ…';

  @override
  String get scheduledMaintenanceMode => 'وضع الصيانة المجدول [جديد]';

  @override
  String get search => 'بحث';

  @override
  String get searchHint => 'ابحث عن أغاني، فنانين، أنواع…';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get sendFeedback => 'إرسال ملاحظات';

  @override
  String get sendNotification => 'إرسال إشعار';

  @override
  String get share => 'مشاركة';

  @override
  String get sharePost => 'مشاركة منشور';

  @override
  String get showLyrics => 'عرض الكلمات';

  @override
  String get shuffle => 'عشوائي';

  @override
  String get signalCardTitle => 'إشارة';

  @override
  String get signalOriginal => 'أصلي من SoundBlast';

  @override
  String get signalTitle => 'إشارة';

  @override
  String signalsLive(int count) {
    return '$count إشارة مباشرة';
  }

  @override
  String get sitemap => 'خريطة الموقع';

  @override
  String get skip => 'تخطي';

  @override
  String get skippedUnplayable => 'تعذّر تشغيل هذه الأغنية، تم الانتقال إلى التالية.';

  @override
  String get songNoAudio => 'هذه الأغنية بلا ملف صوتي.';

  @override
  String get songPublished => 'تم نشر الأغنية.';

  @override
  String get songTitle => 'عنوان الأغنية';

  @override
  String get songVisibilityHidden => 'مخفية';

  @override
  String get songVisibilityPublic => 'علنية';

  @override
  String get songs => 'الأغاني';

  @override
  String songsBy(String name) {
    return 'أغاني $name';
  }

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
  String get soundBlastRoom => 'غرفة ساوند بلاست';

  @override
  String get soundBlastSelection => 'اختيارات SoundBlast';

  @override
  String get soundblastOriginal => 'ساوند بلاست الأصلية';

  @override
  String get stageName => 'الاسم الفني';

  @override
  String get stageNameArtists => 'الاسم الفني (للفنانين)';

  @override
  String get stageNameRequired => 'أدخل الاسم الفني.';

  @override
  String get statFollowers => 'المتابعون';

  @override
  String get statLikes => 'الإعجابات';

  @override
  String get statListeners => 'المستمعون';

  @override
  String get statPlays => 'مرات التشغيل';

  @override
  String get statStreams => 'مرات التشغيل';

  @override
  String get statVisitors => 'الزوار';

  @override
  String get stopPlayback => 'إيقاف التشغيل (يزيل إشعار المشغل)';

  @override
  String get studioNeedsArtist => 'استوديو الفنان يحتاج حساب فنان.';

  @override
  String get suspendAccount => 'إيقاف الحساب';

  @override
  String get suspendArtist => 'إيقاف الفنان [جديد]';

  @override
  String get switchOff => 'متوقفة';

  @override
  String get switchOn => 'مفعّلة';

  @override
  String get tabDownloaded => 'المنزّلة';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabLiked => 'المعجبة';

  @override
  String get tabPlaylists => 'قوائم التشغيل';

  @override
  String get tapBookmarkHint => 'اضغط الإشارة على أي أغنية لحفظها هنا.';

  @override
  String get tapBookmarkToSave => 'اضغط على الإشارة في أي أغنية لتحفظها هنا.';

  @override
  String get tapHeartHint => 'اضغط القلب على أي أغنية للاحتفاظ بها هنا.';

  @override
  String get tapHeartToKeep => 'اضغط على القلب في أي أغنية لتحفظها هنا.';

  @override
  String get tellUsWhatYouThink => 'أخبرنا برأيك';

  @override
  String get termsBody => 'باستخدامك ساوند بلاست فأنت توافق على استخدام المنصة باحترام: انشر فقط الموسيقى التي تملك حقوقها، ولا ترفع محتوى ينتهك حقوق النشر، ولا تضايق المستخدمين الآخرين. يؤكد الفنانون أنهم يملكون حقوق كل أغنية ينشرونها.';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get termsPrivacyPermissions => 'الشروط والخصوصية والأذونات';

  @override
  String get trending => 'الرائج';

  @override
  String get trendingExplainer => 'يُحسب الرائج من مرات التشغيل في آخر 7 أيام. عندما يبدأ الناس بالاستماع، يمتلئ المخطط هنا.';

  @override
  String typeToConfirm(String word) {
    return 'اكتب \"$word\" للتأكيد.';
  }

  @override
  String get unknownAlbum => 'ألبوم غير معروف';

  @override
  String get unknownArtist => 'فنان غير معروف';

  @override
  String get unknownComposer => 'ملحن غير معروف';

  @override
  String get unknownFolder => 'مجلد غير معروف';

  @override
  String get unknownGenre => 'نوع غير معروف';

  @override
  String get unknownTitle => 'عنوان غير معروف';

  @override
  String get unlikeAction => 'إلغاء الإعجاب';

  @override
  String get upNext => 'التالي';

  @override
  String get uploadMissingFields => 'أضف عنوانًا وملفًا صوتيًا وصورة غلاف للمتابعة.';

  @override
  String get uploadNewSong => 'رفع أغنية جديدة';

  @override
  String get uploadNote => 'يُرفع الصوت إلى نفس تخزين الموقع، ثم يتحقق الخادم منه ويحسّنه. قد تستغرق الملفات الكبيرة وقتًا على اتصال بطيء.';

  @override
  String get uploadSong => 'رفع أغنية';

  @override
  String get uploadStorageUnavailable => 'الرفع غير متاح حاليًا: تخزين الخادم غير مهيأ بعد.';

  @override
  String get uploadingArtwork => 'جارٍ رفع صورة الغلاف…';

  @override
  String get uploadingAudio => 'جارٍ رفع الملف الصوتي…';

  @override
  String get userLabel => 'مستخدم';

  @override
  String get verified => 'موثّق';

  @override
  String viewLiveAnalytics(String plays) {
    return 'عرض التحليلات المباشرة · $plays تشغيل / 7 أيام';
  }

  @override
  String get viewSongs => 'عرض الأغاني';

  @override
  String get visibilityPublic => 'عام';

  @override
  String get visitorCounterReset => 'تمت إعادة تعيين عدّاد الزوار.';

  @override
  String get webPushUnavailable => 'إشعارات الويب (إشعارات المتصفح) غير متاحة في تطبيق أندرويد بعد — الإصدارات الجديدة ما زالت تصل إلى صندوق إشعاراتك داخل التطبيق.';

  @override
  String get weeklyTop => 'الأفضل هذا الأسبوع';

  @override
  String welcomeBackName(String name) {
    return 'أهلاً بعودتك، $name';
  }

  @override
  String get wipePlatformContent => 'مسح محتوى المنصة';

  @override
  String get writeComment => 'اكتب تعليقًا… (بحد أقصى 500 حرف)';

  @override
  String get yourLibrary => 'مكتبتك';

  @override
  String get yourMessage => 'رسالتك';

  @override
  String get authInvalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get accountSuspended => 'هذا الحساب موقوف. تواصل مع دعم SoundBlast.';

  @override
  String get accountExists => 'يوجد حساب بهذا البريد الإلكتروني بالفعل.';

  @override
  String get createAccountFailed => 'تعذّر إنشاء الحساب. حاول مرة أخرى.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get playlistCreated => 'تم إنشاء قائمة التشغيل.';

  @override
  String get playlistPrivateOrGone => 'هذه القائمة خاصة أو لم تعد موجودة.';

  @override
  String get playlist => 'قائمة تشغيل';

  @override
  String appVersion(String version) {
    return 'الإصدار $version — تطبيق أندرويد';
  }

  @override
  String get all => 'الكل';

  @override
  String get album => 'ألبوم';

  @override
  String get artist => 'فنان';

  @override
  String get backgroundAudioReady => 'الصوت بالخلفية: جاهز — الموسيقى تستمر بعد إغلاق التطبيق.';

  @override
  String get backgroundAudioUnavailable => 'الصوت بالخلفية: غير متاح — الموسيقى تتوقف عند إغلاق التطبيق.';

  @override
  String get heroSubtitle => 'اعثر على الصوت الذي يبقى معك. موسيقى جديدة وفنانون مباشرون وغرفة تستمع إليك.';

  @override
  String get pathsChart => 'المخطط';

  @override
  String get pathsMoveMoment => 'تحرّك مع اللحظة';

  @override
  String pathsTracksRotation(int count) {
    return '$count أغنية في القائمة';
  }

  @override
  String get pathsArtistRoster => 'قائمة الفنانين';

  @override
  String get pathsStepInside => 'ادخل إلى عالمهم';

  @override
  String pathsVoicesFollow(int count) {
    return '$count صوت للمتابعة';
  }

  @override
  String get pathsReleaseLibrary => 'مكتبة الإصدارات';

  @override
  String get pathsListenChapters => 'استمع على فصول';

  @override
  String pathsReleasesWaiting(int count) {
    return '$count إصدار بانتظارك';
  }

  @override
  String get pathsOpen => 'افتح';

  @override
  String get recentPlays => 'تشغيلاتك الأخيرة';

  @override
  String get listenAgain => 'استمع مجددًا';

  @override
  String get lastPlaysEmpty => 'ستظهر آخر تشغيلاتك هنا.';

  @override
  String get lastPlaysHint => 'شغّل أغنية وسيحتفظ SoundBlast بهذا المكان جاهزًا لجلستك القادمة.';

  @override
  String get exploreMoving => 'اكتشف ما يتحرك الآن';

  @override
  String get privateAccount => 'خاص بحسابك';

  @override
  String get trendingNow => 'الرائج الآن';

  @override
  String get onEveryoneEars => 'على أسماع الجميع';

  @override
  String get seeTheChart => 'شاهد المخطط';

  @override
  String get artistVoice => 'صوت الفنان';

  @override
  String get straightFromArtists => 'مباشرة من الفنانين';

  @override
  String get seeAllPosts => 'شاهد كل المنشورات';

  @override
  String get viewArtistProfile => 'عرض ملف الفنان';

  @override
  String get theRoster => 'القائمة';

  @override
  String get featuredArtists => 'فنانون مميزون';

  @override
  String get browseEveryone => 'تصفح الجميع';

  @override
  String signedCount(int count) {
    return '$count موقّع';
  }

  @override
  String streamsCount(int count) {
    return '$count استماع';
  }

  @override
  String get albumsEyebrow => 'ألبومات';

  @override
  String get albumSpotlight => 'تسليط على الألبومات';

  @override
  String get allAlbums => 'كل الألبومات';

  @override
  String tracksCount(int count) {
    return '$count أغنية';
  }

  @override
  String get trackOne => 'أغنية واحدة';

  @override
  String get likedRecently => 'أُعجبت بها مؤخرًا';

  @override
  String get openFavorites => 'افتح المفضلة';

  @override
  String get likedEmpty => 'ستتجمع الأغاني التي تعجبك هنا. اضغط القلب على أي أغنية لتبدأ مجموعتك.';

  @override
  String get loadingLikes => 'جارٍ تحميل إعجاباتك…';

  @override
  String get followToStay => 'تابِع لتبقى على اطلاع';

  @override
  String get whenYouFollow => 'عندما تتابع فنانًا';

  @override
  String get followToGetUpdates => 'تابِع لتصلك تحديثاتهم هنا';

  @override
  String get yourSound => 'صوتك';

  @override
  String get keepClose => 'احتفظ بالقرب';

  @override
  String get viewCollection => 'عرض مجموعتك';

  @override
  String get liveReleases => 'إصدارات حية';

  @override
  String get streamsSoFar => 'استماعات حتى الآن';

  @override
  String get onTheRoster => 'في القائمة';

  @override
  String backgroundAudioError(String error) => 'خطأ الصوت بالخلفية: $error';

  @override
  String get backgroundBatteryBody =>
      'قد يوقف سامسونج الموسيقى عند إغلاق التطبيق. اسمح لساوند بلاست بالعمل بدون قيود البطارية.';

  @override
  String get backgroundBatteryButton => 'السماح بالتشغيل في الخلفية';

  @override
  String get backgroundBatteryOff =>
      'تحسين البطارية: متوقف — لن يوقف النظام موسيقى الخلفية.';

  @override
  String get backgroundBatteryOn =>
      'تحسين البطارية: مفعّل — قد يوقف النظام الموسيقى عند إغلاق التطبيق.';

  @override
  String get backgroundBatteryTitle => 'استمر بالتشغيل في الخلفية';
}
