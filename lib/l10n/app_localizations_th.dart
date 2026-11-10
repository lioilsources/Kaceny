// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get menuTagline => '90 วินาที กระสุน 8 นัด เป็ดเพียบ';

  @override
  String get menuPlay => 'เล่น';

  @override
  String get menuSkins => 'สกิน';

  @override
  String get menuLeaderboard => 'ตารางคะแนน';

  @override
  String get menuSettings => 'การตั้งค่า';

  @override
  String get menuOnlineLeaderboard => 'ตารางคะแนนออนไลน์';

  @override
  String get signIn => 'ลงชื่อเข้าใช้';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get pauseResume => 'เล่นต่อ';

  @override
  String get pauseRestart => 'เริ่มใหม่';

  @override
  String get backToMenu => 'เมนู';

  @override
  String get hudReloading => 'กำลังบรรจุกระสุน…';

  @override
  String get hudReloadHint => 'ปัดลงหรือแตะตรงนี้';

  @override
  String get settingsSound => 'เสียง';

  @override
  String get settingsHaptics => 'การสั่น';

  @override
  String get settingsAutoReload => 'บรรจุกระสุนอัตโนมัติ';

  @override
  String get settingsAutoReloadHint =>
      'หากปิดไว้ ให้บรรจุกระสุนโดยปัดลงหรือแตะที่กระสุน';

  @override
  String get settingsDebug => 'ดีบัก: พื้นที่โดนและการยิง';

  @override
  String get settingsDebugHint => 'เฉพาะบิลด์ดีบักเท่านั้น';

  @override
  String get settingsRestore => 'กู้คืนการซื้อ';

  @override
  String get leaderboardThisPhone => 'โทรศัพท์เครื่องนี้';

  @override
  String get leaderboardOnline => 'ออนไลน์';

  @override
  String get leaderboardEmpty => 'ยังไม่มีคะแนน ไปยิงเป็ดกันเลย!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ความแม่นยำ $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'คะแนนของผู้เล่นทุกคนใน Game Center / Play Games';

  @override
  String get leaderboardSignInInfo => 'ลงชื่อเข้าใช้แล้วมาเทียบคะแนนกับคนอื่น';

  @override
  String get leaderboardOpen => 'เปิด';

  @override
  String get leaderboardSignIn => 'ลงชื่อเข้าใช้';

  @override
  String get gameOverTitle => 'จบรอบ';

  @override
  String get gameOverNewRecord => 'สถิติใหม่!';

  @override
  String get gameOverInitials => 'คุณติดตารางคะแนน! ชื่อย่อของคุณ:';

  @override
  String get gameOverReplay => 'อีกครั้ง';

  @override
  String get statBest => 'ดีที่สุด';

  @override
  String get statAccuracy => 'ความแม่นยำ';

  @override
  String get statStreak => 'ต่อเนื่อง';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'สกิน ($count)';
  }

  @override
  String get skinsFree => 'ฟรี';

  @override
  String get skinsOwned => 'ของคุณ';

  @override
  String get skinsAnimated => 'กระพือปีก';

  @override
  String skinsUnlock(String price) {
    return 'ปลดล็อกในราคา $price';
  }

  @override
  String get skinsUnlockNoPrice => 'ปลดล็อก';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count สกิน แต่ละแบบมีเป็ดและฉากหลังของตัวเอง เป็นของคุณตลอดไปในทุกอุปกรณ์',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'ร้านค้าไม่พร้อมใช้งานในขณะนี้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get skinsRestore => 'กู้คืนการซื้อ';

  @override
  String get skinsRestoreDone => 'กู้คืนการซื้อแล้ว';

  @override
  String get skinsThanks => 'ขอบคุณ! แพ็กนี้เป็นของคุณแล้ว';

  @override
  String get skinsAllTitle => 'ทุกแพ็ก';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins สกินจากทั้ง $packs แพ็กในครั้งเดียว ในราคาราวครึ่งหนึ่ง เป็นของคุณตลอดไปในทุกอุปกรณ์';
  }
}
