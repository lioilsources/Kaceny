// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get menuTagline => '90 secondi. 8 cartucce. Un sacco di anatre.';

  @override
  String get menuPlay => 'GIOCA';

  @override
  String get menuSkins => 'Skin';

  @override
  String get menuLeaderboard => 'Classifica';

  @override
  String get menuSettings => 'Impostazioni';

  @override
  String get menuOnlineLeaderboard => 'Classifica online';

  @override
  String get signIn => 'Accedi';

  @override
  String get pause => 'Pausa';

  @override
  String get pauseResume => 'Riprendi';

  @override
  String get pauseRestart => 'Ricomincia';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'ricarica…';

  @override
  String get hudReloadHint => 'scorri giù o tocca qui';

  @override
  String get settingsSound => 'Suono';

  @override
  String get settingsHaptics => 'Vibrazione';

  @override
  String get settingsAutoReload => 'Ricarica automatica';

  @override
  String get settingsAutoReloadHint =>
      'Altrimenti ricarica scorrendo verso il basso o toccando le cartucce.';

  @override
  String get settingsDebug => 'Debug: hitbox e colpi';

  @override
  String get settingsDebugHint => 'Solo nella build di debug.';

  @override
  String get settingsRestore => 'Ripristina acquisti';

  @override
  String get leaderboardThisPhone => 'Questo telefono';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Ancora nessun punteggio. Vai a sparare!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precisione $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Punteggi di tutti i giocatori su Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Accedi e sfida gli altri.';

  @override
  String get leaderboardOpen => 'Apri';

  @override
  String get leaderboardSignIn => 'Accedi';

  @override
  String get gameOverTitle => 'Fine del round';

  @override
  String get gameOverNewRecord => 'NUOVO RECORD!';

  @override
  String get gameOverInitials => 'Sei in classifica! Le tue iniziali:';

  @override
  String get gameOverReplay => 'Ancora';

  @override
  String get statBest => 'record';

  @override
  String get statAccuracy => 'precisione';

  @override
  String get statStreak => 'serie';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skin ($count)';
  }

  @override
  String get skinsFree => 'gratis';

  @override
  String get skinsOwned => 'tuo';

  @override
  String get skinsAnimated => 'svolazza';

  @override
  String skinsUnlock(String price) {
    return 'Sblocca a $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Sblocca';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skin, ognuna con un’anatra e il suo sfondo. Tue per sempre, su tutti i tuoi dispositivi.',
      one:
          '$count skin: un’anatra con il suo sfondo. Tua per sempre, su tutti i tuoi dispositivi.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Lo store ora non è disponibile. Riprova più tardi.';

  @override
  String get skinsRestore => 'Ripristina acquisti';

  @override
  String get skinsRestoreDone => 'Acquisti ripristinati.';

  @override
  String get skinsThanks => 'Grazie! Il pacchetto è tuo.';
}
