// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get menuTagline => '90 segundos. 8 cartuchos. Montones de patos.';

  @override
  String get menuPlay => 'JUGAR';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Clasificación';

  @override
  String get menuSettings => 'Ajustes';

  @override
  String get menuOnlineLeaderboard => 'Clasificación online';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get pause => 'Pausa';

  @override
  String get pauseResume => 'Continuar';

  @override
  String get pauseRestart => 'Empezar de nuevo';

  @override
  String get backToMenu => 'Menú';

  @override
  String get hudReloading => 'recargando…';

  @override
  String get hudReloadHint => 'desliza abajo o toca aquí';

  @override
  String get settingsSound => 'Sonido';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsAutoReload => 'Recarga automática';

  @override
  String get settingsAutoReloadHint => 'Si no, recarga deslizando hacia abajo o tocando los cartuchos.';

  @override
  String get settingsDebug => 'Debug: hitboxes y disparos';

  @override
  String get settingsDebugHint => 'Solo en la build de debug.';

  @override
  String get settingsRestore => 'Restaurar compras';

  @override
  String get leaderboardThisPhone => 'Este teléfono';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Aún no hay puntuaciones. ¡A cazar patos!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · precisión $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Puntuaciones de todos los jugadores en Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Inicia sesión y compárate con los demás.';

  @override
  String get leaderboardOpen => 'Abrir';

  @override
  String get leaderboardSignIn => 'Entrar';

  @override
  String get gameOverTitle => 'Fin de la ronda';

  @override
  String get gameOverNewRecord => '¡NUEVO RÉCORD!';

  @override
  String get gameOverInitials => '¡Entras en la clasificación! Tus iniciales:';

  @override
  String get gameOverReplay => 'Otra vez';

  @override
  String get statBest => 'mejor';

  @override
  String get statAccuracy => 'precisión';

  @override
  String get statStreak => 'racha';

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
  String get skinsOwned => 'tuyo';

  @override
  String get skinsAnimated => 'aletea';

  @override
  String skinsUnlock(String price) {
    return 'Desbloquear por $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Desbloquear';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skins, cada uno un pato con su propio fondo. Tuyos para siempre, en todos tus dispositivos.',
      one: '$count skin: un pato con su propio fondo. Tuyo para siempre, en todos tus dispositivos.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'La tienda no está disponible ahora. Inténtalo más tarde.';

  @override
  String get skinsRestore => 'Restaurar compras';

  @override
  String get skinsRestoreDone => 'Compras restauradas.';

  @override
  String get skinsThanks => '¡Gracias! El pack es tuyo.';
}
