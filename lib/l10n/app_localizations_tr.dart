// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get menuTagline => '90 saniye. 8 fişek. Bir sürü ördek.';

  @override
  String get menuPlay => 'OYNA';

  @override
  String get menuSkins => 'Görünümler';

  @override
  String get menuLeaderboard => 'Sıralama';

  @override
  String get menuSettings => 'Ayarlar';

  @override
  String get menuOnlineLeaderboard => 'Çevrimiçi sıralama';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get pause => 'Duraklat';

  @override
  String get pauseResume => 'Devam et';

  @override
  String get pauseRestart => 'Baştan başla';

  @override
  String get backToMenu => 'Menü';

  @override
  String get hudReloading => 'dolduruluyor…';

  @override
  String get hudReloadHint => 'aşağı kaydır veya buraya dokun';

  @override
  String get settingsSound => 'Ses';

  @override
  String get settingsHaptics => 'Titreşim';

  @override
  String get settingsAutoReload => 'Otomatik doldurma';

  @override
  String get settingsAutoReloadHint =>
      'Aksi halde aşağı kaydırarak veya fişeklere dokunarak doldurursun.';

  @override
  String get settingsDebug => 'Debug: isabet alanları ve atışlar';

  @override
  String get settingsDebugHint => 'Yalnızca debug sürümünde.';

  @override
  String get settingsRestore => 'Satın alımları geri yükle';

  @override
  String get leaderboardThisPhone => 'Bu telefon';

  @override
  String get leaderboardOnline => 'Çevrimiçi';

  @override
  String get leaderboardEmpty => 'Henüz skor yok. Hadi biraz ördek vur!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · isabet $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games’teki tüm oyuncuların skorları.';

  @override
  String get leaderboardSignInInfo =>
      'Giriş yap ve kendini başkalarıyla karşılaştır.';

  @override
  String get leaderboardOpen => 'Aç';

  @override
  String get leaderboardSignIn => 'Giriş yap';

  @override
  String get gameOverTitle => 'Tur bitti';

  @override
  String get gameOverNewRecord => 'YENİ REKOR!';

  @override
  String get gameOverInitials => 'Sıralamaya girdin! Baş harflerin:';

  @override
  String get gameOverReplay => 'Tekrar';

  @override
  String get statBest => 'en iyi';

  @override
  String get statAccuracy => 'isabet';

  @override
  String get statStreak => 'seri';

  @override
  String percent(int value) {
    return '%$value';
  }

  @override
  String skinsTitle(int count) {
    return 'Görünümler ($count)';
  }

  @override
  String get skinsFree => 'ücretsiz';

  @override
  String get skinsOwned => 'senin';

  @override
  String get skinsAnimated => 'kanat çırpar';

  @override
  String skinsUnlock(String price) {
    return '$price karşılığında aç';
  }

  @override
  String get skinsUnlockNoPrice => 'Kilidi aç';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count görünüm, her biri kendi arka planıyla bir ördek. Sonsuza kadar senin, tüm cihazlarında.',
      one:
          '$count görünüm: kendi arka planıyla bir ördek. Sonsuza kadar senin, tüm cihazlarında.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Mağaza şu anda kullanılamıyor. Daha sonra tekrar dene.';

  @override
  String get skinsRestore => 'Satın alımları geri yükle';

  @override
  String get skinsRestoreDone => 'Satın alımlar geri yüklendi.';

  @override
  String get skinsThanks => 'Teşekkürler! Paket artık senin.';

  @override
  String get skinsAllTitle => 'Tüm paketler';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$packs paketin tamamından $skins görünüm bir arada, yaklaşık yarı fiyatına. Sonsuza kadar senin, tüm cihazlarında.';
  }
}
