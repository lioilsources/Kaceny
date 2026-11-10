// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get menuTagline => '90 másodperc. 8 töltény. Rengeteg kacsa.';

  @override
  String get menuPlay => 'JÁTÉK';

  @override
  String get menuSkins => 'Kinézetek';

  @override
  String get menuLeaderboard => 'Ranglista';

  @override
  String get menuSettings => 'Beállítások';

  @override
  String get menuOnlineLeaderboard => 'Online ranglista';

  @override
  String get signIn => 'Bejelentkezés';

  @override
  String get pause => 'Szünet';

  @override
  String get pauseResume => 'Folytatás';

  @override
  String get pauseRestart => 'Újrakezdés';

  @override
  String get backToMenu => 'Menü';

  @override
  String get hudReloading => 'töltés…';

  @override
  String get hudReloadHint => 'húzd lefelé vagy koppints ide';

  @override
  String get settingsSound => 'Hang';

  @override
  String get settingsHaptics => 'Rezgés';

  @override
  String get settingsAutoReload => 'Automatikus újratöltés';

  @override
  String get settingsAutoReloadHint =>
      'Különben lefelé húzással vagy a töltényekre koppintva töltesz újra.';

  @override
  String get settingsDebug => 'Debug: találati zónák és lövések';

  @override
  String get settingsDebugHint => 'Csak debug buildben.';

  @override
  String get settingsRestore => 'Vásárlások visszaállítása';

  @override
  String get leaderboardThisPhone => 'Ez a telefon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Még nincs eredmény. Irány kacsát lőni!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · pontosság $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Minden játékos eredménye a Game Centerben / Play Gamesben.';

  @override
  String get leaderboardSignInInfo =>
      'Jelentkezz be, és mérd össze magad másokkal.';

  @override
  String get leaderboardOpen => 'Megnyitás';

  @override
  String get leaderboardSignIn => 'Bejelentkezés';

  @override
  String get gameOverTitle => 'Vége a körnek';

  @override
  String get gameOverNewRecord => 'ÚJ REKORD!';

  @override
  String get gameOverInitials => 'Felkerültél a ranglistára! A monogramod:';

  @override
  String get gameOverReplay => 'Újra';

  @override
  String get statBest => 'legjobb';

  @override
  String get statAccuracy => 'pontosság';

  @override
  String get statStreak => 'sorozat';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Kinézetek ($count)';
  }

  @override
  String get skinsFree => 'ingyenes';

  @override
  String get skinsOwned => 'a tiéd';

  @override
  String get skinsAnimated => 'csapkod';

  @override
  String skinsUnlock(String price) {
    return 'Feloldás: $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Feloldás';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count kinézet, mindegyik egy kacsa saját háttérrel. Örökre a tiéd, minden eszközödön.',
      one:
          '$count kinézet: egy kacsa saját háttérrel. Örökre a tiéd, minden eszközödön.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'A bolt most nem érhető el. Próbáld újra később.';

  @override
  String get skinsRestore => 'Vásárlások visszaállítása';

  @override
  String get skinsRestoreDone => 'Vásárlások visszaállítva.';

  @override
  String get skinsThanks => 'Köszönjük! A csomag a tiéd.';

  @override
  String get skinsAllTitle => 'Minden csomag';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins kinézet mind a(z) $packs csomagból egyszerre, nagyjából fél áron. Örökre a tiéd, minden eszközödön.';
  }
}
