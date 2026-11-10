// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get menuTagline => '90 സെക്കൻഡ്. 8 തിരകൾ. ഒരുപാട് താറാവുകൾ.';

  @override
  String get menuPlay => 'കളിക്കുക';

  @override
  String get menuSkins => 'സ്കിനുകൾ';

  @override
  String get menuLeaderboard => 'ലീഡർബോർഡ്';

  @override
  String get menuSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get menuOnlineLeaderboard => 'ഓൺലൈൻ ലീഡർബോർഡ്';

  @override
  String get signIn => 'സൈൻ ഇൻ ചെയ്യുക';

  @override
  String get pause => 'താൽക്കാലികമായി നിർത്തുക';

  @override
  String get pauseResume => 'തുടരുക';

  @override
  String get pauseRestart => 'വീണ്ടും തുടങ്ങുക';

  @override
  String get backToMenu => 'മെനു';

  @override
  String get hudReloading => 'റീലോഡ് ചെയ്യുന്നു…';

  @override
  String get hudReloadHint =>
      'താഴേക്ക് സ്വൈപ്പ് ചെയ്യുക അല്ലെങ്കിൽ ഇവിടെ ടാപ്പ് ചെയ്യുക';

  @override
  String get settingsSound => 'ശബ്ദം';

  @override
  String get settingsHaptics => 'വൈബ്രേഷൻ';

  @override
  String get settingsAutoReload => 'ഓട്ടോമാറ്റിക് റീലോഡ്';

  @override
  String get settingsAutoReloadHint =>
      'അല്ലെങ്കിൽ താഴേക്ക് സ്വൈപ്പ് ചെയ്തോ തിരകളിൽ ടാപ്പ് ചെയ്തോ റീലോഡ് ചെയ്യുക.';

  @override
  String get settingsDebug => 'ഡീബഗ്: ഹിറ്റ്ബോക്സുകളും വെടികളും';

  @override
  String get settingsDebugHint => 'ഡീബഗ് ബിൽഡിൽ മാത്രം.';

  @override
  String get settingsRestore => 'വാങ്ങലുകൾ പുനഃസ്ഥാപിക്കുക';

  @override
  String get leaderboardThisPhone => 'ഈ ഫോൺ';

  @override
  String get leaderboardOnline => 'ഓൺലൈൻ';

  @override
  String get leaderboardEmpty =>
      'ഇതുവരെ സ്കോറുകളില്ല. പോയി കുറച്ച് താറാവുകളെ വീഴ്ത്തൂ!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · കൃത്യത $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games-ലെ എല്ലാ കളിക്കാരുടെയും സ്കോറുകൾ.';

  @override
  String get leaderboardSignInInfo =>
      'സൈൻ ഇൻ ചെയ്ത് മറ്റുള്ളവരുമായി താരതമ്യം ചെയ്യൂ.';

  @override
  String get leaderboardOpen => 'തുറക്കുക';

  @override
  String get leaderboardSignIn => 'സൈൻ ഇൻ';

  @override
  String get gameOverTitle => 'റൗണ്ട് കഴിഞ്ഞു';

  @override
  String get gameOverNewRecord => 'പുതിയ റെക്കോർഡ്!';

  @override
  String get gameOverInitials =>
      'നിങ്ങൾ ലീഡർബോർഡിൽ എത്തി! നിങ്ങളുടെ ഇനിഷ്യലുകൾ:';

  @override
  String get gameOverReplay => 'വീണ്ടും';

  @override
  String get statBest => 'മികച്ചത്';

  @override
  String get statAccuracy => 'കൃത്യത';

  @override
  String get statStreak => 'തുടർച്ച';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'സ്കിനുകൾ ($count)';
  }

  @override
  String get skinsFree => 'സൗജന്യം';

  @override
  String get skinsOwned => 'നിങ്ങളുടേത്';

  @override
  String get skinsAnimated => 'ചിറകടിക്കും';

  @override
  String skinsUnlock(String price) {
    return '$price-ന് അൺലോക്ക് ചെയ്യുക';
  }

  @override
  String get skinsUnlockNoPrice => 'അൺലോക്ക് ചെയ്യുക';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count സ്കിനുകൾ, ഓരോന്നിലും ഒരു താറാവും സ്വന്തം പശ്ചാത്തലവും. എന്നും നിങ്ങളുടേത്, നിങ്ങളുടെ എല്ലാ ഉപകരണങ്ങളിലും.',
      one:
          '$count സ്കിൻ: ഒരു താറാവും അതിന്റെ സ്വന്തം പശ്ചാത്തലവും. എന്നും നിങ്ങളുടേത്, നിങ്ങളുടെ എല്ലാ ഉപകരണങ്ങളിലും.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'സ്റ്റോർ ഇപ്പോൾ ലഭ്യമല്ല. പിന്നീട് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get skinsRestore => 'വാങ്ങലുകൾ പുനഃസ്ഥാപിക്കുക';

  @override
  String get skinsRestoreDone => 'വാങ്ങലുകൾ പുനഃസ്ഥാപിച്ചു.';

  @override
  String get skinsThanks => 'നന്ദി! പായ്ക്ക് ഇനി നിങ്ങളുടേതാണ്.';

  @override
  String get skinsAllTitle => 'എല്ലാ പായ്ക്കുകളും';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'എല്ലാ $packs പായ്ക്കുകളിലെയും $skins സ്കിനുകൾ ഒറ്റയടിക്ക്, ഏകദേശം പകുതി വിലയ്ക്ക്. എന്നും നിങ്ങളുടേത്, നിങ്ങളുടെ എല്ലാ ഉപകരണങ്ങളിലും.';
  }
}
