// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get menuTagline => '90 secondes. 8 cartouches. Plein de canards.';

  @override
  String get menuPlay => 'JOUER';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Classement';

  @override
  String get menuSettings => 'Réglages';

  @override
  String get menuOnlineLeaderboard => 'Classement en ligne';

  @override
  String get signIn => 'Se connecter';

  @override
  String get pause => 'Pause';

  @override
  String get pauseResume => 'Reprendre';

  @override
  String get pauseRestart => 'Recommencer';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'rechargement…';

  @override
  String get hudReloadHint => 'glisse vers le bas ou touche ici';

  @override
  String get settingsSound => 'Son';

  @override
  String get settingsHaptics => 'Vibrations';

  @override
  String get settingsAutoReload => 'Rechargement auto';

  @override
  String get settingsAutoReloadHint =>
      'Sinon, recharge en glissant vers le bas ou en touchant les cartouches.';

  @override
  String get settingsDebug => 'Debug : hitbox et tirs';

  @override
  String get settingsDebugHint => 'Uniquement en build debug.';

  @override
  String get settingsRestore => 'Restaurer les achats';

  @override
  String get leaderboardThisPhone => 'Ce téléphone';

  @override
  String get leaderboardOnline => 'En ligne';

  @override
  String get leaderboardEmpty => 'Pas encore de score. Va tirer des canards !';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · précision $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Scores de tous les joueurs sur Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Connecte-toi et mesure-toi aux autres.';

  @override
  String get leaderboardOpen => 'Ouvrir';

  @override
  String get leaderboardSignIn => 'Connexion';

  @override
  String get gameOverTitle => 'Fin de la manche';

  @override
  String get gameOverNewRecord => 'NOUVEAU RECORD !';

  @override
  String get gameOverInitials => 'Tu entres au classement ! Tes initiales :';

  @override
  String get gameOverReplay => 'Rejouer';

  @override
  String get statBest => 'record';

  @override
  String get statAccuracy => 'précision';

  @override
  String get statStreak => 'série';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'gratuit';

  @override
  String get skinsOwned => 'à toi';

  @override
  String get skinsAnimated => 'animé';

  @override
  String skinsUnlock(String price) {
    return 'Débloquer pour $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Débloquer';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skins, chacun avec un canard et son propre décor. À toi pour toujours, sur tous tes appareils.',
      one:
          '$count skin : un canard et son propre décor. À toi pour toujours, sur tous tes appareils.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'La boutique n’est pas disponible pour le moment. Réessaie plus tard.';

  @override
  String get skinsRestore => 'Restaurer les achats';

  @override
  String get skinsRestoreDone => 'Achats restaurés.';

  @override
  String get skinsThanks => 'Merci ! Le pack est à toi.';
}
