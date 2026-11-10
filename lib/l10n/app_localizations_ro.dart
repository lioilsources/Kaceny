// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get menuTagline => '90 de secunde. 8 cartușe. O grămadă de rațe.';

  @override
  String get menuPlay => 'JOACĂ';

  @override
  String get menuSkins => 'Skinuri';

  @override
  String get menuLeaderboard => 'Clasament';

  @override
  String get menuSettings => 'Setări';

  @override
  String get menuOnlineLeaderboard => 'Clasament online';

  @override
  String get signIn => 'Conectează-te';

  @override
  String get pause => 'Pauză';

  @override
  String get pauseResume => 'Continuă';

  @override
  String get pauseRestart => 'Ia-o de la capăt';

  @override
  String get backToMenu => 'Meniu';

  @override
  String get hudReloading => 'se reîncarcă…';

  @override
  String get hudReloadHint => 'glisează în jos sau atinge aici';

  @override
  String get settingsSound => 'Sunet';

  @override
  String get settingsHaptics => 'Vibrații';

  @override
  String get settingsAutoReload => 'Reîncărcare automată';

  @override
  String get settingsAutoReloadHint =>
      'Altfel reîncarci glisând în jos sau atingând cartușele.';

  @override
  String get settingsDebug => 'Debug: hitboxuri și focuri';

  @override
  String get settingsDebugHint => 'Doar în build-ul de debug.';

  @override
  String get settingsRestore => 'Restabilește achizițiile';

  @override
  String get leaderboardThisPhone => 'Acest telefon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty =>
      'Încă nu sunt scoruri. Du-te să împuști niște rațe!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precizie $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Scorurile tuturor jucătorilor în Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Conectează-te și compară-te cu ceilalți.';

  @override
  String get leaderboardOpen => 'Deschide';

  @override
  String get leaderboardSignIn => 'Conectare';

  @override
  String get gameOverTitle => 'Runda s-a terminat';

  @override
  String get gameOverNewRecord => 'RECORD NOU!';

  @override
  String get gameOverInitials => 'Ai intrat în clasament! Inițialele tale:';

  @override
  String get gameOverReplay => 'Din nou';

  @override
  String get statBest => 'cel mai bun';

  @override
  String get statAccuracy => 'precizie';

  @override
  String get statStreak => 'serie';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skinuri ($count)';
  }

  @override
  String get skinsFree => 'gratuit';

  @override
  String get skinsOwned => 'al tău';

  @override
  String get skinsAnimated => 'bate din aripi';

  @override
  String skinsUnlock(String price) {
    return 'Deblochează cu $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Deblochează';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count de skinuri, fiecare cu o rață și propriul fundal. Ale tale pentru totdeauna, pe toate dispozitivele tale.',
      few:
          '$count skinuri, fiecare cu o rață și propriul fundal. Ale tale pentru totdeauna, pe toate dispozitivele tale.',
      one:
          '$count skin: o rață cu propriul fundal. Al tău pentru totdeauna, pe toate dispozitivele tale.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Magazinul nu este disponibil acum. Încearcă mai târziu.';

  @override
  String get skinsRestore => 'Restabilește achizițiile';

  @override
  String get skinsRestoreDone => 'Achizițiile au fost restabilite.';

  @override
  String get skinsThanks => 'Mulțumim! Pachetul e al tău.';

  @override
  String get skinsAllTitle => 'Toate pachetele';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins de skinuri din toate cele $packs pachete deodată, pentru cam jumătate de preț. Ale tale pentru totdeauna, pe toate dispozitivele tale.';
  }
}
