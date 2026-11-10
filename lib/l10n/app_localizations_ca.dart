// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get menuTagline => '90 segons. 8 cartutxos. Molts ànecs.';

  @override
  String get menuPlay => 'JUGA';

  @override
  String get menuSkins => 'Aparences';

  @override
  String get menuLeaderboard => 'Classificació';

  @override
  String get menuSettings => 'Configuració';

  @override
  String get menuOnlineLeaderboard => 'Classificació en línia';

  @override
  String get signIn => 'Inicia la sessió';

  @override
  String get pause => 'Pausa';

  @override
  String get pauseResume => 'Continua';

  @override
  String get pauseRestart => 'Torna a començar';

  @override
  String get backToMenu => 'Menú';

  @override
  String get hudReloading => 'recarregant…';

  @override
  String get hudReloadHint => 'llisca avall o toca aquí';

  @override
  String get settingsSound => 'So';

  @override
  String get settingsHaptics => 'Vibració';

  @override
  String get settingsAutoReload => 'Recàrrega automàtica';

  @override
  String get settingsAutoReloadHint =>
      'Si no, recarrega lliscant avall o tocant els cartutxos.';

  @override
  String get settingsDebug => 'Depuració: zones d’impacte i trets';

  @override
  String get settingsDebugHint => 'Només en la compilació de depuració.';

  @override
  String get settingsRestore => 'Restaura les compres';

  @override
  String get leaderboardThisPhone => 'Aquest telèfon';

  @override
  String get leaderboardOnline => 'En línia';

  @override
  String get leaderboardEmpty =>
      'Encara no hi ha puntuacions. Vés a disparar ànecs!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precisió $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Puntuacions de tots els jugadors a Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Inicia la sessió i compara’t amb els altres.';

  @override
  String get leaderboardOpen => 'Obre';

  @override
  String get leaderboardSignIn => 'Inicia la sessió';

  @override
  String get gameOverTitle => 'Fi de la ronda';

  @override
  String get gameOverNewRecord => 'NOU RÈCORD!';

  @override
  String get gameOverInitials =>
      'Has entrat a la classificació! Les teves inicials:';

  @override
  String get gameOverReplay => 'Una altra';

  @override
  String get statBest => 'millor';

  @override
  String get statAccuracy => 'precisió';

  @override
  String get statStreak => 'ratxa';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Aparences ($count)';
  }

  @override
  String get skinsFree => 'gratis';

  @override
  String get skinsOwned => 'teva';

  @override
  String get skinsAnimated => 'aleteja';

  @override
  String skinsUnlock(String price) {
    return 'Desbloqueja per $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Desbloqueja';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count aparences, cadascuna amb un ànec i el seu propi fons. Teves per sempre, a tots els teus dispositius.',
      one:
          '$count aparença: un ànec amb el seu propi fons. Teva per sempre, a tots els teus dispositius.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'La botiga no està disponible ara mateix. Torna-ho a provar més tard.';

  @override
  String get skinsRestore => 'Restaura les compres';

  @override
  String get skinsRestoreDone => 'S’han restaurat les compres.';

  @override
  String get skinsThanks => 'Gràcies! El paquet és teu.';

  @override
  String get skinsAllTitle => 'Tots els paquets';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins aparences de tots els $packs paquets alhora, per la meitat del preu, més o menys. Teves per sempre, a tots els teus dispositius.';
  }
}
