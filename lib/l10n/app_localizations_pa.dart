// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get menuTagline => '90 ਸਕਿੰਟ। 8 ਕਾਰਤੂਸ। ਢੇਰ ਸਾਰੀਆਂ ਬੱਤਖਾਂ।';

  @override
  String get menuPlay => 'ਖੇਡੋ';

  @override
  String get menuSkins => 'ਸਕਿਨ';

  @override
  String get menuLeaderboard => 'ਲੀਡਰਬੋਰਡ';

  @override
  String get menuSettings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get menuOnlineLeaderboard => 'ਆਨਲਾਈਨ ਲੀਡਰਬੋਰਡ';

  @override
  String get signIn => 'ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get pause => 'ਰੋਕੋ';

  @override
  String get pauseResume => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get pauseRestart => 'ਮੁੜ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get backToMenu => 'ਮੀਨੂ';

  @override
  String get hudReloading => 'ਰੀਲੋਡ ਹੋ ਰਿਹਾ ਹੈ…';

  @override
  String get hudReloadHint => 'ਹੇਠਾਂ ਸਵਾਈਪ ਕਰੋ ਜਾਂ ਇੱਥੇ ਟੈਪ ਕਰੋ';

  @override
  String get settingsSound => 'ਆਵਾਜ਼';

  @override
  String get settingsHaptics => 'ਥਰਥਰਾਹਟ';

  @override
  String get settingsAutoReload => 'ਆਪਣੇ-ਆਪ ਰੀਲੋਡ';

  @override
  String get settingsAutoReloadHint =>
      'ਨਹੀਂ ਤਾਂ ਹੇਠਾਂ ਸਵਾਈਪ ਕਰਕੇ ਜਾਂ ਕਾਰਤੂਸਾਂ ਉੱਤੇ ਟੈਪ ਕਰਕੇ ਰੀਲੋਡ ਕਰੋ।';

  @override
  String get settingsDebug => 'ਡੀਬੱਗ: ਹਿੱਟਬਾਕਸ ਅਤੇ ਸ਼ਾਟ';

  @override
  String get settingsDebugHint => 'ਸਿਰਫ਼ ਡੀਬੱਗ ਬਿਲਡ ਵਿੱਚ।';

  @override
  String get settingsRestore => 'ਖਰੀਦਾਂ ਬਹਾਲ ਕਰੋ';

  @override
  String get leaderboardThisPhone => 'ਇਹ ਫ਼ੋਨ';

  @override
  String get leaderboardOnline => 'ਆਨਲਾਈਨ';

  @override
  String get leaderboardEmpty => 'ਅਜੇ ਕੋਈ ਸਕੋਰ ਨਹੀਂ। ਜਾਓ, ਕੁਝ ਬੱਤਖਾਂ ਡੇਗੋ!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ਸ਼ੁੱਧਤਾ $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games ਉੱਤੇ ਸਾਰੇ ਖਿਡਾਰੀਆਂ ਦੇ ਸਕੋਰ।';

  @override
  String get leaderboardSignInInfo => 'ਸਾਈਨ ਇਨ ਕਰੋ ਅਤੇ ਦੂਜਿਆਂ ਨਾਲ ਮੁਕਾਬਲਾ ਕਰੋ।';

  @override
  String get leaderboardOpen => 'ਖੋਲ੍ਹੋ';

  @override
  String get leaderboardSignIn => 'ਸਾਈਨ ਇਨ';

  @override
  String get gameOverTitle => 'ਰਾਊਂਡ ਖ਼ਤਮ';

  @override
  String get gameOverNewRecord => 'ਨਵਾਂ ਰਿਕਾਰਡ!';

  @override
  String get gameOverInitials =>
      'ਤੁਸੀਂ ਲੀਡਰਬੋਰਡ ਵਿੱਚ ਆ ਗਏ! ਤੁਹਾਡੇ ਨਾਂ ਦੇ ਪਹਿਲੇ ਅੱਖਰ:';

  @override
  String get gameOverReplay => 'ਫਿਰ ਤੋਂ';

  @override
  String get statBest => 'ਸਭ ਤੋਂ ਵਧੀਆ';

  @override
  String get statAccuracy => 'ਸ਼ੁੱਧਤਾ';

  @override
  String get statStreak => 'ਲਗਾਤਾਰ';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'ਸਕਿਨ ($count)';
  }

  @override
  String get skinsFree => 'ਮੁਫ਼ਤ';

  @override
  String get skinsOwned => 'ਤੁਹਾਡੀ';

  @override
  String get skinsAnimated => 'ਖੰਭ ਫੜਫੜਾਏ';

  @override
  String skinsUnlock(String price) {
    return '$price ਵਿੱਚ ਅਨਲੌਕ ਕਰੋ';
  }

  @override
  String get skinsUnlockNoPrice => 'ਅਨਲੌਕ ਕਰੋ';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ਸਕਿਨ, ਹਰ ਇੱਕ ਵਿੱਚ ਬੱਤਖ ਅਤੇ ਉਸਦਾ ਆਪਣਾ ਪਿਛੋਕੜ। ਹਮੇਸ਼ਾ ਲਈ ਤੁਹਾਡੀਆਂ, ਤੁਹਾਡੇ ਸਾਰੇ ਡਿਵਾਈਸਾਂ ਉੱਤੇ।',
      one:
          '$count ਸਕਿਨ: ਇੱਕ ਬੱਤਖ ਅਤੇ ਉਸਦਾ ਆਪਣਾ ਪਿਛੋਕੜ। ਹਮੇਸ਼ਾ ਲਈ ਤੁਹਾਡੀ, ਤੁਹਾਡੇ ਸਾਰੇ ਡਿਵਾਈਸਾਂ ਉੱਤੇ।',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'ਸਟੋਰ ਹੁਣ ਉਪਲਬਧ ਨਹੀਂ। ਬਾਅਦ ਵਿੱਚ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get skinsRestore => 'ਖਰੀਦਾਂ ਬਹਾਲ ਕਰੋ';

  @override
  String get skinsRestoreDone => 'ਖਰੀਦਾਂ ਬਹਾਲ ਹੋ ਗਈਆਂ।';

  @override
  String get skinsThanks => 'ਧੰਨਵਾਦ! ਪੈਕ ਹੁਣ ਤੁਹਾਡਾ ਹੈ।';

  @override
  String get skinsAllTitle => 'ਸਾਰੇ ਪੈਕ';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'ਸਾਰੇ $packs ਪੈਕਾਂ ਦੀਆਂ $skins ਸਕਿਨਾਂ ਇੱਕੋ ਵਾਰ, ਲਗਭਗ ਅੱਧੀ ਕੀਮਤ ਉੱਤੇ। ਹਮੇਸ਼ਾ ਲਈ ਤੁਹਾਡੀਆਂ, ਤੁਹਾਡੇ ਸਾਰੇ ਡਿਵਾਈਸਾਂ ਉੱਤੇ।';
  }
}
