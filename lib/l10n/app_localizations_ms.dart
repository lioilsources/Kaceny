// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get menuTagline => '90 saat. 8 peluru. Banyak itik.';

  @override
  String get menuPlay => 'MAIN';

  @override
  String get menuSkins => 'Kulit';

  @override
  String get menuLeaderboard => 'Papan pendahulu';

  @override
  String get menuSettings => 'Tetapan';

  @override
  String get menuOnlineLeaderboard => 'Papan pendahulu dalam talian';

  @override
  String get signIn => 'Log masuk';

  @override
  String get pause => 'Jeda';

  @override
  String get pauseResume => 'Sambung';

  @override
  String get pauseRestart => 'Mula semula';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'mengisi semula…';

  @override
  String get hudReloadHint => 'leret ke bawah atau ketik di sini';

  @override
  String get settingsSound => 'Bunyi';

  @override
  String get settingsHaptics => 'Getaran';

  @override
  String get settingsAutoReload => 'Isi semula automatik';

  @override
  String get settingsAutoReloadHint =>
      'Jika tidak, isi semula dengan meleret ke bawah atau mengetik peluru.';

  @override
  String get settingsDebug => 'Nyahpepijat: kotak kena dan tembakan';

  @override
  String get settingsDebugHint => 'Hanya dalam binaan nyahpepijat.';

  @override
  String get settingsRestore => 'Pulihkan pembelian';

  @override
  String get leaderboardThisPhone => 'Telefon ini';

  @override
  String get leaderboardOnline => 'Dalam talian';

  @override
  String get leaderboardEmpty => 'Belum ada skor. Pergi tembak itik!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ketepatan $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Skor semua pemain di Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Log masuk dan bandingkan diri anda dengan orang lain.';

  @override
  String get leaderboardOpen => 'Buka';

  @override
  String get leaderboardSignIn => 'Log masuk';

  @override
  String get gameOverTitle => 'Pusingan tamat';

  @override
  String get gameOverNewRecord => 'REKOD BAHARU!';

  @override
  String get gameOverInitials => 'Anda masuk papan pendahulu! Huruf awal anda:';

  @override
  String get gameOverReplay => 'Lagi';

  @override
  String get statBest => 'terbaik';

  @override
  String get statAccuracy => 'ketepatan';

  @override
  String get statStreak => 'berturut';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Kulit ($count)';
  }

  @override
  String get skinsFree => 'percuma';

  @override
  String get skinsOwned => 'milik anda';

  @override
  String get skinsAnimated => 'mengepak';

  @override
  String skinsUnlock(String price) {
    return 'Buka dengan $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Buka';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count kulit, setiap satu itik dengan latarnya sendiri. Milik anda selamanya, pada semua peranti anda.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Kedai tidak tersedia sekarang. Cuba lagi nanti.';

  @override
  String get skinsRestore => 'Pulihkan pembelian';

  @override
  String get skinsRestoreDone => 'Pembelian dipulihkan.';

  @override
  String get skinsThanks => 'Terima kasih! Pek ini milik anda.';

  @override
  String get skinsAllTitle => 'Semua pek';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins kulit daripada semua $packs pek sekali gus, pada kira-kira separuh harga. Milik anda selamanya, pada semua peranti anda.';
  }
}
