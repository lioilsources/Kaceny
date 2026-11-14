// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get menuTagline => '90 sekúnd. 8 nábojov. Kopa kačíc.';

  @override
  String get menuPlay => 'HRAŤ';

  @override
  String get menuSkins => 'Skiny';

  @override
  String get menuLeaderboard => 'Rebríček';

  @override
  String get menuSettings => 'Nastavenia';

  @override
  String get menuOnlineLeaderboard => 'Online rebríček';

  @override
  String get signIn => 'Prihlásiť sa';

  @override
  String get pause => 'Pauza';

  @override
  String get pauseResume => 'Pokračovať';

  @override
  String get pauseRestart => 'Znova od začiatku';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'nabíjam…';

  @override
  String get hudReloadHint => 'potiahni dole alebo ťukni sem';

  @override
  String get settingsSound => 'Zvuk';

  @override
  String get settingsHaptics => 'Vibrácie';

  @override
  String get settingsAutoReload => 'Automatické nabíjanie';

  @override
  String get settingsAutoReloadHint => 'Inak nabiješ potiahnutím prsta dole alebo ťuknutím na náboje.';

  @override
  String get settingsDebug => 'Debug: hitboxy a výstrely';

  @override
  String get settingsDebugHint => 'Len v debug builde.';

  @override
  String get settingsRestore => 'Obnoviť nákupy';

  @override
  String get settingsStats => 'Anonymné štatistiky';

  @override
  String get settingsStatsHint => 'Aké obrazovky a kolá sa hrajú, nič, čo by ťa identifikovalo. Pomáha vylepšiť hru.';

  @override
  String get leaderboardThisPhone => 'Tento telefón';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Zatiaľ žiadne skóre. Choď strieľať!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · presnosť $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Výsledky všetkých hráčov v Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Prihlás sa a porovnaj sa s ostatnými.';

  @override
  String get leaderboardOpen => 'Otvoriť';

  @override
  String get leaderboardSignIn => 'Prihlásiť';

  @override
  String get gameOverTitle => 'Koniec kola';

  @override
  String get gameOverNewRecord => 'NOVÝ REKORD!';

  @override
  String get gameOverInitials => 'Do rebríčka! Tvoje iniciály:';

  @override
  String get gameOverReplay => 'Znova';

  @override
  String get statBest => 'najlepšie';

  @override
  String get statAccuracy => 'presnosť';

  @override
  String get statStreak => 'séria';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Skiny ($count)';
  }

  @override
  String get skinsFree => 'zadarmo';

  @override
  String get skinsOwned => 'tvoje';

  @override
  String get skinsAnimated => 'máva';

  @override
  String skinsUnlock(String price) {
    return 'Odomknúť za $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Odomknúť';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skinov, každý s kačicou a vlastným pozadím. Navždy tvoje, na všetkých tvojich zariadeniach.',
      few: '$count skiny, každý s kačicou a vlastným pozadím. Navždy tvoje, na všetkých tvojich zariadeniach.',
      one: '$count skin: kačica a jej vlastné pozadie. Navždy tvoj, na všetkých tvojich zariadeniach.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'Obchod teraz nie je dostupný. Skús to neskôr.';

  @override
  String get skinsRestore => 'Obnoviť nákupy';

  @override
  String get skinsRestoreDone => 'Nákupy obnovené.';

  @override
  String get skinsThanks => 'Vďaka! Balík je tvoj.';

  @override
  String get skinsAllTitle => 'Všetky balíčky';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skinov zo všetkých $packs balíčkov naraz, zhruba za polovicu. Navždy tvoje, na všetkých zariadeniach.';
  }
}
