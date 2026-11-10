// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get menuTagline => '90 सेकंद. 8 काडतुसे. भरपूर बदके.';

  @override
  String get menuPlay => 'खेळा';

  @override
  String get menuSkins => 'स्किन';

  @override
  String get menuLeaderboard => 'लीडरबोर्ड';

  @override
  String get menuSettings => 'सेटिंग्ज';

  @override
  String get menuOnlineLeaderboard => 'ऑनलाइन लीडरबोर्ड';

  @override
  String get signIn => 'साइन इन करा';

  @override
  String get pause => 'थांबवा';

  @override
  String get pauseResume => 'पुढे सुरू ठेवा';

  @override
  String get pauseRestart => 'पुन्हा सुरुवात करा';

  @override
  String get backToMenu => 'मेनू';

  @override
  String get hudReloading => 'रीलोड होत आहे…';

  @override
  String get hudReloadHint => 'खाली स्वाइप करा किंवा इथे टॅप करा';

  @override
  String get settingsSound => 'आवाज';

  @override
  String get settingsHaptics => 'कंपन';

  @override
  String get settingsAutoReload => 'आपोआप रीलोड';

  @override
  String get settingsAutoReloadHint =>
      'नाहीतर खाली स्वाइप करून किंवा काडतुसांवर टॅप करून रीलोड करा.';

  @override
  String get settingsDebug => 'डीबग: हिटबॉक्स आणि शॉट';

  @override
  String get settingsDebugHint => 'फक्त डीबग बिल्डमध्ये.';

  @override
  String get settingsRestore => 'खरेदी पुनर्संचयित करा';

  @override
  String get leaderboardThisPhone => 'हा फोन';

  @override
  String get leaderboardOnline => 'ऑनलाइन';

  @override
  String get leaderboardEmpty =>
      'अजून कोणताही स्कोअर नाही. चला, काही बदके पाडा!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · अचूकता $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games वरील सर्व खेळाडूंचे स्कोअर.';

  @override
  String get leaderboardSignInInfo => 'साइन इन करा आणि इतरांशी तुलना करा.';

  @override
  String get leaderboardOpen => 'उघडा';

  @override
  String get leaderboardSignIn => 'साइन इन';

  @override
  String get gameOverTitle => 'फेरी संपली';

  @override
  String get gameOverNewRecord => 'नवा विक्रम!';

  @override
  String get gameOverInitials => 'तुम्ही लीडरबोर्डवर आलात! तुमची आद्याक्षरे:';

  @override
  String get gameOverReplay => 'पुन्हा';

  @override
  String get statBest => 'सर्वोत्तम';

  @override
  String get statAccuracy => 'अचूकता';

  @override
  String get statStreak => 'सलग';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'स्किन ($count)';
  }

  @override
  String get skinsFree => 'मोफत';

  @override
  String get skinsOwned => 'तुमची';

  @override
  String get skinsAnimated => 'पंख फडफडतात';

  @override
  String skinsUnlock(String price) {
    return '$price ला अनलॉक करा';
  }

  @override
  String get skinsUnlockNoPrice => 'अनलॉक करा';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count स्किन, प्रत्येकात एक बदक आणि स्वतःची पार्श्वभूमी. कायमच्या तुमच्या, तुमच्या सर्व डिव्हाइसवर.',
      one:
          '$count स्किन: एक बदक आणि त्याची स्वतःची पार्श्वभूमी. कायमची तुमची, तुमच्या सर्व डिव्हाइसवर.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'स्टोअर सध्या उपलब्ध नाही. नंतर पुन्हा प्रयत्न करा.';

  @override
  String get skinsRestore => 'खरेदी पुनर्संचयित करा';

  @override
  String get skinsRestoreDone => 'खरेदी पुनर्संचयित झाली.';

  @override
  String get skinsThanks => 'धन्यवाद! पॅक आता तुमचा आहे.';

  @override
  String get skinsAllTitle => 'सर्व पॅक';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'सर्व $packs पॅकमधील $skins स्किन एकाच वेळी, साधारण अर्ध्या किमतीत. कायमच्या तुमच्या, तुमच्या सर्व डिव्हाइसवर.';
  }
}
