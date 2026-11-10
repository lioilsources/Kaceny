// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get menuTagline => '90 سیکنڈ۔ 8 کارتوس۔ ڈھیروں بطخیں۔';

  @override
  String get menuPlay => 'کھیلیں';

  @override
  String get menuSkins => 'اسکنز';

  @override
  String get menuLeaderboard => 'لیڈر بورڈ';

  @override
  String get menuSettings => 'ترتیبات';

  @override
  String get menuOnlineLeaderboard => 'آن لائن لیڈر بورڈ';

  @override
  String get signIn => 'سائن ان کریں';

  @override
  String get pause => 'روکیں';

  @override
  String get pauseResume => 'جاری رکھیں';

  @override
  String get pauseRestart => 'دوبارہ شروع کریں';

  @override
  String get backToMenu => 'مینو';

  @override
  String get hudReloading => 'ری لوڈ ہو رہا ہے…';

  @override
  String get hudReloadHint => 'نیچے سوائپ کریں یا یہاں ٹیپ کریں';

  @override
  String get settingsSound => 'آواز';

  @override
  String get settingsHaptics => 'وائبریشن';

  @override
  String get settingsAutoReload => 'خودکار ری لوڈ';

  @override
  String get settingsAutoReloadHint =>
      'ورنہ نیچے سوائپ کر کے یا کارتوسوں پر ٹیپ کر کے ری لوڈ کریں۔';

  @override
  String get settingsDebug => 'ڈیبگ: ہٹ باکس اور شاٹس';

  @override
  String get settingsDebugHint => 'صرف ڈیبگ بلڈ میں۔';

  @override
  String get settingsRestore => 'خریداریاں بحال کریں';

  @override
  String get leaderboardThisPhone => 'یہ فون';

  @override
  String get leaderboardOnline => 'آن لائن';

  @override
  String get leaderboardEmpty =>
      'ابھی کوئی اسکور نہیں۔ جائیں، کچھ بطخیں گرائیں!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · درستگی $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games پر تمام کھلاڑیوں کے اسکور۔';

  @override
  String get leaderboardSignInInfo => 'سائن ان کریں اور دوسروں سے مقابلہ کریں۔';

  @override
  String get leaderboardOpen => 'کھولیں';

  @override
  String get leaderboardSignIn => 'سائن ان';

  @override
  String get gameOverTitle => 'راؤنڈ ختم';

  @override
  String get gameOverNewRecord => 'نیا ریکارڈ!';

  @override
  String get gameOverInitials =>
      'آپ لیڈر بورڈ میں آ گئے! آپ کے نام کے ابتدائی حروف:';

  @override
  String get gameOverReplay => 'پھر سے';

  @override
  String get statBest => 'بہترین';

  @override
  String get statAccuracy => 'درستگی';

  @override
  String get statStreak => 'لگاتار';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'اسکنز ($count)';
  }

  @override
  String get skinsFree => 'مفت';

  @override
  String get skinsOwned => 'آپ کی';

  @override
  String get skinsAnimated => 'پر پھڑپھڑائے';

  @override
  String skinsUnlock(String price) {
    return '$price میں ان لاک کریں';
  }

  @override
  String get skinsUnlockNoPrice => 'ان لاک کریں';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count اسکنز، ہر ایک میں بطخ اور اس کا اپنا پس منظر۔ ہمیشہ کے لیے آپ کی، آپ کے تمام آلات پر۔',
      one:
          '$count اسکن: ایک بطخ اور اس کا اپنا پس منظر۔ ہمیشہ کے لیے آپ کی، آپ کے تمام آلات پر۔',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'اسٹور ابھی دستیاب نہیں۔ بعد میں دوبارہ کوشش کریں۔';

  @override
  String get skinsRestore => 'خریداریاں بحال کریں';

  @override
  String get skinsRestoreDone => 'خریداریاں بحال ہو گئیں۔';

  @override
  String get skinsThanks => 'شکریہ! پیک اب آپ کا ہے۔';

  @override
  String get skinsAllTitle => 'تمام پیکس';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'تمام $packs پیکس کی $skins اسکنز ایک ساتھ، تقریباً آدھی قیمت پر۔ ہمیشہ کے لیے آپ کی، آپ کے تمام آلات پر۔';
  }
}
