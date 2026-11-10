// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get menuTagline => '90 sekundi. 8 metaka. Puno pataka.';

  @override
  String get menuPlay => 'IGRAJ';

  @override
  String get menuSkins => 'Izgledi';

  @override
  String get menuLeaderboard => 'Ljestvica';

  @override
  String get menuSettings => 'Postavke';

  @override
  String get menuOnlineLeaderboard => 'Online ljestvica';

  @override
  String get signIn => 'Prijava';

  @override
  String get pause => 'Pauza';

  @override
  String get pauseResume => 'Nastavi';

  @override
  String get pauseRestart => 'Ispočetka';

  @override
  String get backToMenu => 'Izbornik';

  @override
  String get hudReloading => 'punim…';

  @override
  String get hudReloadHint => 'povuci prema dolje ili dodirni ovdje';

  @override
  String get settingsSound => 'Zvuk';

  @override
  String get settingsHaptics => 'Vibracija';

  @override
  String get settingsAutoReload => 'Automatsko punjenje';

  @override
  String get settingsAutoReloadHint =>
      'Inače puniš povlačenjem prema dolje ili dodirom na metke.';

  @override
  String get settingsDebug => 'Debug: zone pogotka i hici';

  @override
  String get settingsDebugHint => 'Samo u debug verziji.';

  @override
  String get settingsRestore => 'Vrati kupnje';

  @override
  String get leaderboardThisPhone => 'Ovaj telefon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Još nema rezultata. Idi pucati na patke!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · preciznost $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Rezultati svih igrača u Game Centeru / Play Gamesu.';

  @override
  String get leaderboardSignInInfo => 'Prijavi se i usporedi se s drugima.';

  @override
  String get leaderboardOpen => 'Otvori';

  @override
  String get leaderboardSignIn => 'Prijava';

  @override
  String get gameOverTitle => 'Kraj runde';

  @override
  String get gameOverNewRecord => 'NOVI REKORD!';

  @override
  String get gameOverInitials => 'Ušao si na ljestvicu! Tvoji inicijali:';

  @override
  String get gameOverReplay => 'Ponovno';

  @override
  String get statBest => 'najbolje';

  @override
  String get statAccuracy => 'preciznost';

  @override
  String get statStreak => 'niz';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Izgledi ($count)';
  }

  @override
  String get skinsFree => 'besplatno';

  @override
  String get skinsOwned => 'tvoje';

  @override
  String get skinsAnimated => 'maše';

  @override
  String skinsUnlock(String price) {
    return 'Otključaj za $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Otključaj';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count izgleda, svaki s patkom i vlastitom pozadinom. Tvoji zauvijek, na svim tvojim uređajima.',
      few:
          '$count izgleda, svaki s patkom i vlastitom pozadinom. Tvoji zauvijek, na svim tvojim uređajima.',
      one:
          '$count izgled: patka s vlastitom pozadinom. Tvoj zauvijek, na svim tvojim uređajima.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Trgovina trenutačno nije dostupna. Pokušaj kasnije.';

  @override
  String get skinsRestore => 'Vrati kupnje';

  @override
  String get skinsRestoreDone => 'Kupnje su vraćene.';

  @override
  String get skinsThanks => 'Hvala! Paket je tvoj.';

  @override
  String get skinsAllTitle => 'Svi paketi';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins izgleda iz svih $packs paketa odjednom, za otprilike pola cijene. Tvoji zauvijek, na svim tvojim uređajima.';
  }
}
