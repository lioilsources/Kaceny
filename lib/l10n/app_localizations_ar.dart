// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get menuTagline => '90 ثانية. 8 طلقات. بطّ كثير.';

  @override
  String get menuPlay => 'العب';

  @override
  String get menuSkins => 'المظاهر';

  @override
  String get menuLeaderboard => 'لوحة الصدارة';

  @override
  String get menuSettings => 'الإعدادات';

  @override
  String get menuOnlineLeaderboard => 'لوحة الصدارة عبر الإنترنت';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get pauseResume => 'متابعة';

  @override
  String get pauseRestart => 'البدء من جديد';

  @override
  String get backToMenu => 'القائمة';

  @override
  String get hudReloading => 'جارٍ التلقيم…';

  @override
  String get hudReloadHint => 'اسحب للأسفل أو انقر هنا';

  @override
  String get settingsSound => 'الصوت';

  @override
  String get settingsHaptics => 'الاهتزاز';

  @override
  String get settingsAutoReload => 'تلقيم تلقائي';

  @override
  String get settingsAutoReloadHint =>
      'وإلا فلقِّم بالسحب للأسفل أو بالنقر على الطلقات.';

  @override
  String get settingsDebug => 'تصحيح: مناطق الإصابة والطلقات';

  @override
  String get settingsDebugHint => 'في نسخة التصحيح فقط.';

  @override
  String get settingsRestore => 'استعادة المشتريات';

  @override
  String get leaderboardThisPhone => 'هذا الهاتف';

  @override
  String get leaderboardOnline => 'عبر الإنترنت';

  @override
  String get leaderboardEmpty => 'لا نتائج بعد. هيا اصطد بعض البط!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · الدقة $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'نتائج جميع اللاعبين في Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'سجّل الدخول وقارن نفسك بالآخرين.';

  @override
  String get leaderboardOpen => 'فتح';

  @override
  String get leaderboardSignIn => 'تسجيل الدخول';

  @override
  String get gameOverTitle => 'انتهت الجولة';

  @override
  String get gameOverNewRecord => 'رقم قياسي جديد!';

  @override
  String get gameOverInitials => 'دخلت لوحة الصدارة! أحرفك الأولى:';

  @override
  String get gameOverReplay => 'مرة أخرى';

  @override
  String get statBest => 'الأفضل';

  @override
  String get statAccuracy => 'الدقة';

  @override
  String get statStreak => 'سلسلة';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'المظاهر ($count)';
  }

  @override
  String get skinsFree => 'مجاني';

  @override
  String get skinsOwned => 'لك';

  @override
  String get skinsAnimated => 'يرفرف';

  @override
  String skinsUnlock(String price) {
    return 'افتح مقابل $price';
  }

  @override
  String get skinsUnlockNoPrice => 'فتح';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count مظهر، لكل منها بطة وخلفية خاصة. لك إلى الأبد، على جميع أجهزتك.',
      many:
          '$count مظهرًا، لكل منها بطة وخلفية خاصة. لك إلى الأبد، على جميع أجهزتك.',
      few:
          '$count مظاهر، لكل منها بطة وخلفية خاصة. لك إلى الأبد، على جميع أجهزتك.',
      two: 'مظهران، لكل منهما بطة وخلفية خاصة. لك إلى الأبد، على جميع أجهزتك.',
      one: 'مظهر واحد: بطة بخلفيتها الخاصة. لك إلى الأبد، على جميع أجهزتك.',
      zero: 'لا مظاهر في هذه الحزمة.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'المتجر غير متاح الآن. حاول لاحقًا.';

  @override
  String get skinsRestore => 'استعادة المشتريات';

  @override
  String get skinsRestoreDone => 'تمت استعادة المشتريات.';

  @override
  String get skinsThanks => 'شكرًا! الحزمة لك الآن.';

  @override
  String get skinsAllTitle => 'كل الحزم';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'كل المظاهر ($skins) من كل الحزم ($packs) دفعة واحدة، بنحو نصف السعر. لك إلى الأبد، على جميع أجهزتك.';
  }
}
