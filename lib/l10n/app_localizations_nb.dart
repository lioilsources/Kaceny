// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get menuTagline => '90 sekunder. 8 patroner. Masse ender.';

  @override
  String get menuPlay => 'SPILL';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Toppliste';

  @override
  String get menuSettings => 'Innstillinger';

  @override
  String get menuOnlineLeaderboard => 'Toppliste på nett';

  @override
  String get signIn => 'Logg på';

  @override
  String get pause => 'Pause';

  @override
  String get pauseResume => 'Fortsett';

  @override
  String get pauseRestart => 'Start på nytt';

  @override
  String get backToMenu => 'Meny';

  @override
  String get hudReloading => 'lader…';

  @override
  String get hudReloadHint => 'sveip ned eller trykk her';

  @override
  String get settingsSound => 'Lyd';

  @override
  String get settingsHaptics => 'Vibrering';

  @override
  String get settingsAutoReload => 'Automatisk lading';

  @override
  String get settingsAutoReloadHint =>
      'Ellers lader du ved å sveipe ned eller trykke på patronene.';

  @override
  String get settingsDebug => 'Debug: treffbokser og skudd';

  @override
  String get settingsDebugHint => 'Bare i debug-bygg.';

  @override
  String get settingsRestore => 'Gjenopprett kjøp';

  @override
  String get leaderboardThisPhone => 'Denne telefonen';

  @override
  String get leaderboardOnline => 'På nett';

  @override
  String get leaderboardEmpty => 'Ingen poeng ennå. Gå og skyt noen ender!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · treffsikkerhet $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Poengene til alle spillere i Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Logg på og sammenlign deg med andre.';

  @override
  String get leaderboardOpen => 'Åpne';

  @override
  String get leaderboardSignIn => 'Logg på';

  @override
  String get gameOverTitle => 'Runden er over';

  @override
  String get gameOverNewRecord => 'NY REKORD!';

  @override
  String get gameOverInitials => 'Du kom på topplisten! Initialene dine:';

  @override
  String get gameOverReplay => 'Igjen';

  @override
  String get statBest => 'beste';

  @override
  String get statAccuracy => 'treffsikkerhet';

  @override
  String get statStreak => 'rekke';

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
  String get skinsAnimated => 'flakser';

  @override
  String skinsUnlock(String price) {
    return 'Lås opp for $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Lås opp';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, hver med en and og egen bakgrunn. Dine for alltid, på alle enhetene dine.',
      one:
          '$count skin: en and med egen bakgrunn. Din for alltid, på alle enhetene dine.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Butikken er ikke tilgjengelig akkurat nå. Prøv igjen senere.';

  @override
  String get skinsRestore => 'Gjenopprett kjøp';

  @override
  String get skinsRestoreDone => 'Kjøpene er gjenopprettet.';

  @override
  String get skinsThanks => 'Takk! Pakken er din.';

  @override
  String get skinsAllTitle => 'Alle pakker';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skins fra alle $packs pakkene på én gang, for omtrent halv pris. Dine for alltid, på alle enhetene dine.';
  }
}
