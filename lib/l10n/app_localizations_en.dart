// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get menuTagline => '90 seconds. 8 shells. Lots of ducks.';

  @override
  String get menuPlay => 'PLAY';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Leaderboard';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuOnlineLeaderboard => 'Online leaderboard';

  @override
  String get signIn => 'Sign in';

  @override
  String get pause => 'Pause';

  @override
  String get pauseResume => 'Resume';

  @override
  String get pauseRestart => 'Start over';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'reloading…';

  @override
  String get hudReloadHint => 'swipe down or tap here';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAutoReload => 'Automatic reload';

  @override
  String get settingsAutoReloadHint => 'Otherwise reload by swiping down or tapping the shells.';

  @override
  String get settingsDebug => 'Debug: hitboxes and shots';

  @override
  String get settingsDebugHint => 'Debug build only.';

  @override
  String get settingsRestore => 'Restore purchases';

  @override
  String get leaderboardThisPhone => 'This phone';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'No scores yet. Go shoot some ducks!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · accuracy $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Scores of all players in Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Sign in and compare yourself with others.';

  @override
  String get leaderboardOpen => 'Open';

  @override
  String get leaderboardSignIn => 'Sign in';

  @override
  String get gameOverTitle => 'Round over';

  @override
  String get gameOverNewRecord => 'NEW RECORD!';

  @override
  String get gameOverInitials => 'You made the leaderboard! Your initials:';

  @override
  String get gameOverReplay => 'Again';

  @override
  String get statBest => 'best';

  @override
  String get statAccuracy => 'accuracy';

  @override
  String get statStreak => 'streak';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'free';

  @override
  String get skinsOwned => 'yours';

  @override
  String get skinsAnimated => 'flaps';

  @override
  String skinsUnlock(String price) {
    return 'Unlock for $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Unlock';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skins, each a duck and its own background. Yours forever, on all your devices.',
      one: '$count skin, a duck and its own background. Yours forever, on all your devices.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'The store isn\'t available right now. Try again later.';

  @override
  String get skinsRestore => 'Restore purchases';

  @override
  String get skinsRestoreDone => 'Purchases restored.';

  @override
  String get skinsThanks => 'Thanks! The pack is yours.';
}
