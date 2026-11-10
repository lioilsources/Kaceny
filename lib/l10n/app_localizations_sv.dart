// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get menuTagline => '90 sekunder. 8 patroner. Massor av ankor.';

  @override
  String get menuPlay => 'SPELA';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Topplista';

  @override
  String get menuSettings => 'Inställningar';

  @override
  String get menuOnlineLeaderboard => 'Topplista online';

  @override
  String get signIn => 'Logga in';

  @override
  String get pause => 'Paus';

  @override
  String get pauseResume => 'Fortsätt';

  @override
  String get pauseRestart => 'Börja om';

  @override
  String get backToMenu => 'Meny';

  @override
  String get hudReloading => 'laddar om…';

  @override
  String get hudReloadHint => 'svep nedåt eller tryck här';

  @override
  String get settingsSound => 'Ljud';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAutoReload => 'Automatisk omladdning';

  @override
  String get settingsAutoReloadHint =>
      'Annars laddar du om genom att svepa nedåt eller trycka på patronerna.';

  @override
  String get settingsDebug => 'Debug: träffytor och skott';

  @override
  String get settingsDebugHint => 'Bara i debugbygge.';

  @override
  String get settingsRestore => 'Återställ köp';

  @override
  String get leaderboardThisPhone => 'Den här telefonen';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Inga poäng än. Gå och skjut några ankor!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · träffsäkerhet $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Alla spelares poäng i Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Logga in och jämför dig med andra.';

  @override
  String get leaderboardOpen => 'Öppna';

  @override
  String get leaderboardSignIn => 'Logga in';

  @override
  String get gameOverTitle => 'Rundan är slut';

  @override
  String get gameOverNewRecord => 'NYTT REKORD!';

  @override
  String get gameOverInitials => 'Du kom in på topplistan! Dina initialer:';

  @override
  String get gameOverReplay => 'Igen';

  @override
  String get statBest => 'bästa';

  @override
  String get statAccuracy => 'träffsäkerhet';

  @override
  String get statStreak => 'svit';

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
  String get skinsAnimated => 'flaxar';

  @override
  String skinsUnlock(String price) {
    return 'Lås upp för $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Lås upp';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, var och en en anka med egen bakgrund. Dina för alltid, på alla dina enheter.',
      one:
          '$count skin: en anka med egen bakgrund. Din för alltid, på alla dina enheter.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Butiken är inte tillgänglig just nu. Försök igen senare.';

  @override
  String get skinsRestore => 'Återställ köp';

  @override
  String get skinsRestoreDone => 'Köpen har återställts.';

  @override
  String get skinsThanks => 'Tack! Paketet är ditt.';

  @override
  String get skinsAllTitle => 'Alla paket';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skins från alla $packs paket på en gång, för ungefär halva priset. Dina för alltid, på alla dina enheter.';
  }
}
