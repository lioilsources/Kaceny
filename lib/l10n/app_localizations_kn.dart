// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get menuTagline => '90 ಸೆಕೆಂಡುಗಳು. 8 ಗುಂಡುಗಳು. ಸಾಕಷ್ಟು ಬಾತುಕೋಳಿಗಳು.';

  @override
  String get menuPlay => 'ಆಡಿ';

  @override
  String get menuSkins => 'ಸ್ಕಿನ್‌ಗಳು';

  @override
  String get menuLeaderboard => 'ಲೀಡರ್‌ಬೋರ್ಡ್';

  @override
  String get menuSettings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get menuOnlineLeaderboard => 'ಆನ್‌ಲೈನ್ ಲೀಡರ್‌ಬೋರ್ಡ್';

  @override
  String get signIn => 'ಸೈನ್ ಇನ್ ಮಾಡಿ';

  @override
  String get pause => 'ವಿರಾಮ';

  @override
  String get pauseResume => 'ಮುಂದುವರಿಸಿ';

  @override
  String get pauseRestart => 'ಮತ್ತೆ ಆರಂಭಿಸಿ';

  @override
  String get backToMenu => 'ಮೆನು';

  @override
  String get hudReloading => 'ರೀಲೋಡ್ ಆಗುತ್ತಿದೆ…';

  @override
  String get hudReloadHint => 'ಕೆಳಗೆ ಸ್ವೈಪ್ ಮಾಡಿ ಅಥವಾ ಇಲ್ಲಿ ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get settingsSound => 'ಧ್ವನಿ';

  @override
  String get settingsHaptics => 'ಕಂಪನ';

  @override
  String get settingsAutoReload => 'ಸ್ವಯಂ ರೀಲೋಡ್';

  @override
  String get settingsAutoReloadHint =>
      'ಇಲ್ಲದಿದ್ದರೆ ಕೆಳಗೆ ಸ್ವೈಪ್ ಮಾಡಿ ಅಥವಾ ಗುಂಡುಗಳ ಮೇಲೆ ಟ್ಯಾಪ್ ಮಾಡಿ ರೀಲೋಡ್ ಮಾಡಿ.';

  @override
  String get settingsDebug => 'ಡೀಬಗ್: ಹಿಟ್‌ಬಾಕ್ಸ್‌ಗಳು ಮತ್ತು ಶಾಟ್‌ಗಳು';

  @override
  String get settingsDebugHint => 'ಡೀಬಗ್ ಬಿಲ್ಡ್‌ನಲ್ಲಿ ಮಾತ್ರ.';

  @override
  String get settingsRestore => 'ಖರೀದಿಗಳನ್ನು ಮರುಸ್ಥಾಪಿಸಿ';

  @override
  String get leaderboardThisPhone => 'ಈ ಫೋನ್';

  @override
  String get leaderboardOnline => 'ಆನ್‌ಲೈನ್';

  @override
  String get leaderboardEmpty =>
      'ಇನ್ನೂ ಯಾವುದೇ ಸ್ಕೋರ್ ಇಲ್ಲ. ಹೋಗಿ, ಕೆಲವು ಬಾತುಕೋಳಿಗಳನ್ನು ಉರುಳಿಸಿ!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ನಿಖರತೆ $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games ನಲ್ಲಿ ಎಲ್ಲಾ ಆಟಗಾರರ ಸ್ಕೋರ್‌ಗಳು.';

  @override
  String get leaderboardSignInInfo =>
      'ಸೈನ್ ಇನ್ ಮಾಡಿ ಮತ್ತು ಇತರರೊಂದಿಗೆ ಹೋಲಿಸಿಕೊಳ್ಳಿ.';

  @override
  String get leaderboardOpen => 'ತೆರೆಯಿರಿ';

  @override
  String get leaderboardSignIn => 'ಸೈನ್ ಇನ್';

  @override
  String get gameOverTitle => 'ಸುತ್ತು ಮುಗಿಯಿತು';

  @override
  String get gameOverNewRecord => 'ಹೊಸ ದಾಖಲೆ!';

  @override
  String get gameOverInitials =>
      'ನೀವು ಲೀಡರ್‌ಬೋರ್ಡ್‌ಗೆ ಬಂದಿರಿ! ನಿಮ್ಮ ಹೆಸರಿನ ಮೊದಲಕ್ಷರಗಳು:';

  @override
  String get gameOverReplay => 'ಮತ್ತೆ';

  @override
  String get statBest => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get statAccuracy => 'ನಿಖರತೆ';

  @override
  String get statStreak => 'ಸರಣಿ';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'ಸ್ಕಿನ್‌ಗಳು ($count)';
  }

  @override
  String get skinsFree => 'ಉಚಿತ';

  @override
  String get skinsOwned => 'ನಿಮ್ಮದು';

  @override
  String get skinsAnimated => 'ರೆಕ್ಕೆ ಬಡಿಯುತ್ತದೆ';

  @override
  String skinsUnlock(String price) {
    return '$priceಗೆ ಅನ್‌ಲಾಕ್ ಮಾಡಿ';
  }

  @override
  String get skinsUnlockNoPrice => 'ಅನ್‌ಲಾಕ್ ಮಾಡಿ';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ಸ್ಕಿನ್‌ಗಳು, ಪ್ರತಿಯೊಂದರಲ್ಲೂ ಒಂದು ಬಾತುಕೋಳಿ ಮತ್ತು ಸ್ವಂತ ಹಿನ್ನೆಲೆ. ಎಂದೆಂದಿಗೂ ನಿಮ್ಮವು, ನಿಮ್ಮ ಎಲ್ಲಾ ಸಾಧನಗಳಲ್ಲಿ.',
      one:
          '$count ಸ್ಕಿನ್: ಒಂದು ಬಾತುಕೋಳಿ ಮತ್ತು ಅದರ ಸ್ವಂತ ಹಿನ್ನೆಲೆ. ಎಂದೆಂದಿಗೂ ನಿಮ್ಮದು, ನಿಮ್ಮ ಎಲ್ಲಾ ಸಾಧನಗಳಲ್ಲಿ.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'ಸ್ಟೋರ್ ಈಗ ಲಭ್ಯವಿಲ್ಲ. ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get skinsRestore => 'ಖರೀದಿಗಳನ್ನು ಮರುಸ್ಥಾಪಿಸಿ';

  @override
  String get skinsRestoreDone => 'ಖರೀದಿಗಳನ್ನು ಮರುಸ್ಥಾಪಿಸಲಾಗಿದೆ.';

  @override
  String get skinsThanks => 'ಧನ್ಯವಾದಗಳು! ಪ್ಯಾಕ್ ಈಗ ನಿಮ್ಮದು.';

  @override
  String get skinsAllTitle => 'ಎಲ್ಲಾ ಪ್ಯಾಕ್‌ಗಳು';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'ಎಲ್ಲಾ $packs ಪ್ಯಾಕ್‌ಗಳ $skins ಸ್ಕಿನ್‌ಗಳು ಒಂದೇ ಬಾರಿಗೆ, ಸುಮಾರು ಅರ್ಧ ಬೆಲೆಗೆ. ಎಂದೆಂದಿಗೂ ನಿಮ್ಮವು, ನಿಮ್ಮ ಎಲ್ಲಾ ಸಾಧನಗಳಲ್ಲಿ.';
  }
}
