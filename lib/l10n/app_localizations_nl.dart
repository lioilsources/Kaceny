// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get menuTagline => '90 seconden. 8 patronen. Heel veel eenden.';

  @override
  String get menuPlay => 'SPELEN';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Ranglijst';

  @override
  String get menuSettings => 'Instellingen';

  @override
  String get menuOnlineLeaderboard => 'Online ranglijst';

  @override
  String get signIn => 'Inloggen';

  @override
  String get pause => 'Pauze';

  @override
  String get pauseResume => 'Doorgaan';

  @override
  String get pauseRestart => 'Opnieuw beginnen';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'herladen…';

  @override
  String get hudReloadHint => 'veeg omlaag of tik hier';

  @override
  String get settingsSound => 'Geluid';

  @override
  String get settingsHaptics => 'Trillen';

  @override
  String get settingsAutoReload => 'Automatisch herladen';

  @override
  String get settingsAutoReloadHint =>
      'Anders herlaad je door omlaag te vegen of op de patronen te tikken.';

  @override
  String get settingsDebug => 'Debug: hitboxen en schoten';

  @override
  String get settingsDebugHint => 'Alleen in een debugbuild.';

  @override
  String get settingsRestore => 'Aankopen herstellen';

  @override
  String get leaderboardThisPhone => 'Deze telefoon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Nog geen scores. Ga eenden schieten!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precisie $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Scores van alle spelers in Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Log in en vergelijk je met anderen.';

  @override
  String get leaderboardOpen => 'Openen';

  @override
  String get leaderboardSignIn => 'Inloggen';

  @override
  String get gameOverTitle => 'Ronde voorbij';

  @override
  String get gameOverNewRecord => 'NIEUW RECORD!';

  @override
  String get gameOverInitials => 'Je staat in de ranglijst! Je initialen:';

  @override
  String get gameOverReplay => 'Nog een keer';

  @override
  String get statBest => 'beste';

  @override
  String get statAccuracy => 'precisie';

  @override
  String get statStreak => 'reeks';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'gratis';

  @override
  String get skinsOwned => 'van jou';

  @override
  String get skinsAnimated => 'fladdert';

  @override
  String skinsUnlock(String price) {
    return 'Ontgrendel voor $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Ontgrendelen';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, elk een eend met een eigen achtergrond. Voor altijd van jou, op al je apparaten.',
      one:
          '$count skin: een eend met een eigen achtergrond. Voor altijd van jou, op al je apparaten.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'De winkel is nu niet beschikbaar. Probeer het later opnieuw.';

  @override
  String get skinsRestore => 'Aankopen herstellen';

  @override
  String get skinsRestoreDone => 'Aankopen hersteld.';

  @override
  String get skinsThanks => 'Bedankt! Het pakket is van jou.';

  @override
  String get skinsAllTitle => 'Alle pakketten';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skins uit alle $packs pakketten tegelijk, voor ongeveer de helft van de prijs. Voor altijd van jou, op al je apparaten.';
  }
}
