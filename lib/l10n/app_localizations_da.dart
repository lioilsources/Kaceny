// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get menuTagline => '90 sekunder. 8 patroner. Masser af ænder.';

  @override
  String get menuPlay => 'SPIL';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Rangliste';

  @override
  String get menuSettings => 'Indstillinger';

  @override
  String get menuOnlineLeaderboard => 'Online rangliste';

  @override
  String get signIn => 'Log ind';

  @override
  String get pause => 'Pause';

  @override
  String get pauseResume => 'Fortsæt';

  @override
  String get pauseRestart => 'Start forfra';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'lader…';

  @override
  String get hudReloadHint => 'stryg ned eller tryk her';

  @override
  String get settingsSound => 'Lyd';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAutoReload => 'Automatisk genladning';

  @override
  String get settingsAutoReloadHint =>
      'Ellers lader du ved at stryge ned eller trykke på patronerne.';

  @override
  String get settingsDebug => 'Debug: hitbokse og skud';

  @override
  String get settingsDebugHint => 'Kun i debug-build.';

  @override
  String get settingsRestore => 'Gendan køb';

  @override
  String get leaderboardThisPhone => 'Denne telefon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty =>
      'Ingen point endnu. Gå ud og skyd nogle ænder!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · præcision $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Alle spilleres point i Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Log ind og sammenlign dig med andre.';

  @override
  String get leaderboardOpen => 'Åbn';

  @override
  String get leaderboardSignIn => 'Log ind';

  @override
  String get gameOverTitle => 'Runden er slut';

  @override
  String get gameOverNewRecord => 'NY REKORD!';

  @override
  String get gameOverInitials => 'Du kom på ranglisten! Dine initialer:';

  @override
  String get gameOverReplay => 'Igen';

  @override
  String get statBest => 'bedste';

  @override
  String get statAccuracy => 'præcision';

  @override
  String get statStreak => 'stime';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'gratis';

  @override
  String get skinsOwned => 'din';

  @override
  String get skinsAnimated => 'basker';

  @override
  String skinsUnlock(String price) {
    return 'Lås op for $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Lås op';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, hver med en and og sin egen baggrund. Dine for altid, på alle dine enheder.',
      one:
          '$count skin: en and med sin egen baggrund. Din for altid, på alle dine enheder.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Butikken er ikke tilgængelig lige nu. Prøv igen senere.';

  @override
  String get skinsRestore => 'Gendan køb';

  @override
  String get skinsRestoreDone => 'Køb gendannet.';

  @override
  String get skinsThanks => 'Tak! Pakken er din.';

  @override
  String get skinsAllTitle => 'Alle pakker';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skins fra alle $packs pakker på én gang, til cirka halv pris. Dine for altid, på alle dine enheder.';
  }
}
