// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get menuTagline => '90 vteřin. 8 nábojů. Hodně kačen.';

  @override
  String get menuPlay => 'HRÁT';

  @override
  String get menuSkins => 'Skiny';

  @override
  String get menuLeaderboard => 'Žebříček';

  @override
  String get menuSettings => 'Nastavení';

  @override
  String get menuOnlineLeaderboard => 'Online žebříček';

  @override
  String get signIn => 'Přihlásit se';

  @override
  String get pause => 'Pauza';

  @override
  String get pauseResume => 'Pokračovat';

  @override
  String get pauseRestart => 'Znovu od začátku';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'nabíjím…';

  @override
  String get hudReloadHint => 'přejeď dolů nebo ťukni sem';

  @override
  String get settingsSound => 'Zvuk';

  @override
  String get settingsHaptics => 'Vibrace';

  @override
  String get settingsAutoReload => 'Automatické přebíjení';

  @override
  String get settingsAutoReloadHint => 'Jinak přebiješ přejetím prstu dolů nebo ťuknutím na náboje.';

  @override
  String get settingsDebug => 'Debug: hitboxy a výstřely';

  @override
  String get settingsDebugHint => 'Jen v debug buildu.';

  @override
  String get settingsRestore => 'Obnovit nákupy';

  @override
  String get leaderboardThisPhone => 'Tento telefon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Zatím žádné skóre. Jdi střílet!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · přesnost $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Výsledky všech hráčů v Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Přihlas se a porovnej se s ostatními.';

  @override
  String get leaderboardOpen => 'Otevřít';

  @override
  String get leaderboardSignIn => 'Přihlásit';

  @override
  String get gameOverTitle => 'Konec kola';

  @override
  String get gameOverNewRecord => 'NOVÝ REKORD!';

  @override
  String get gameOverInitials => 'Do žebříčku! Tvoje iniciály:';

  @override
  String get gameOverReplay => 'Znovu';

  @override
  String get statBest => 'nejlepší';

  @override
  String get statAccuracy => 'přesnost';

  @override
  String get statStreak => 'série';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Skiny ($count)';
  }

  @override
  String get skinsFree => 'zdarma';

  @override
  String get skinsOwned => 'tvoje';

  @override
  String get skinsAnimated => 'mává';

  @override
  String skinsUnlock(String price) {
    return 'Odemknout za $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Odemknout';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skinů, každý s kachnou a vlastním pozadím. Navždy tvoje, na všech tvých zařízeních.',
      few: '$count skiny, každý s kachnou a vlastním pozadím. Navždy tvoje, na všech tvých zařízeních.',
      one: '$count skin: kachna a její vlastní pozadí. Navždy tvůj, na všech tvých zařízeních.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'Obchod teď není dostupný. Zkus to později.';

  @override
  String get skinsRestore => 'Obnovit nákupy';

  @override
  String get skinsRestoreDone => 'Nákupy obnoveny.';

  @override
  String get skinsThanks => 'Díky! Balíček je tvůj.';

  @override
  String get skinsAllTitle => 'Všechny balíčky';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skinů ze všech $packs balíčků najednou, zhruba za polovinu. Navždy tvoje, na všech zařízeních.';
  }
}
