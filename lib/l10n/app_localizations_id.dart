// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get menuTagline => '90 detik. 8 peluru. Banyak bebek.';

  @override
  String get menuPlay => 'MAIN';

  @override
  String get menuSkins => 'Skin';

  @override
  String get menuLeaderboard => 'Papan skor';

  @override
  String get menuSettings => 'Pengaturan';

  @override
  String get menuOnlineLeaderboard => 'Papan skor online';

  @override
  String get signIn => 'Masuk';

  @override
  String get pause => 'Jeda';

  @override
  String get pauseResume => 'Lanjutkan';

  @override
  String get pauseRestart => 'Mulai ulang';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'mengisi ulang…';

  @override
  String get hudReloadHint => 'geser ke bawah atau ketuk di sini';

  @override
  String get settingsSound => 'Suara';

  @override
  String get settingsHaptics => 'Getar';

  @override
  String get settingsAutoReload => 'Isi ulang otomatis';

  @override
  String get settingsAutoReloadHint =>
      'Jika tidak, isi ulang dengan menggeser ke bawah atau mengetuk peluru.';

  @override
  String get settingsDebug => 'Debug: hitbox dan tembakan';

  @override
  String get settingsDebugHint => 'Hanya di build debug.';

  @override
  String get settingsRestore => 'Pulihkan pembelian';

  @override
  String get leaderboardThisPhone => 'Ponsel ini';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Belum ada skor. Ayo tembak bebek!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · akurasi $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Skor semua pemain di Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Masuk dan bandingkan dirimu dengan pemain lain.';

  @override
  String get leaderboardOpen => 'Buka';

  @override
  String get leaderboardSignIn => 'Masuk';

  @override
  String get gameOverTitle => 'Ronde selesai';

  @override
  String get gameOverNewRecord => 'REKOR BARU!';

  @override
  String get gameOverInitials => 'Kamu masuk papan skor! Inisialmu:';

  @override
  String get gameOverReplay => 'Lagi';

  @override
  String get statBest => 'terbaik';

  @override
  String get statAccuracy => 'akurasi';

  @override
  String get statStreak => 'beruntun';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skin ($count)';
  }

  @override
  String get skinsFree => 'gratis';

  @override
  String get skinsOwned => 'milikmu';

  @override
  String get skinsAnimated => 'mengepak';

  @override
  String skinsUnlock(String price) {
    return 'Buka seharga $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Buka';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skin, masing-masing bebek dengan latarnya sendiri. Milikmu selamanya, di semua perangkatmu.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Toko sedang tidak tersedia. Coba lagi nanti.';

  @override
  String get skinsRestore => 'Pulihkan pembelian';

  @override
  String get skinsRestoreDone => 'Pembelian dipulihkan.';

  @override
  String get skinsThanks => 'Terima kasih! Paket ini milikmu.';

  @override
  String get skinsAllTitle => 'Semua paket';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skin dari semua $packs paket sekaligus, sekitar setengah harga. Milikmu selamanya, di semua perangkatmu.';
  }
}
