// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get menuTagline => '90 सेकंड. 8 कारतूस. ढेर सारी बत्तखें.';

  @override
  String get menuPlay => 'खेलें';

  @override
  String get menuSkins => 'स्किन';

  @override
  String get menuLeaderboard => 'लीडरबोर्ड';

  @override
  String get menuSettings => 'सेटिंग्स';

  @override
  String get menuOnlineLeaderboard => 'ऑनलाइन लीडरबोर्ड';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get pause => 'रोकें';

  @override
  String get pauseResume => 'जारी रखें';

  @override
  String get pauseRestart => 'फिर से शुरू करें';

  @override
  String get backToMenu => 'मेन्यू';

  @override
  String get hudReloading => 'रीलोड हो रहा है…';

  @override
  String get hudReloadHint => 'नीचे स्वाइप करें या यहाँ टैप करें';

  @override
  String get settingsSound => 'आवाज़';

  @override
  String get settingsHaptics => 'वाइब्रेशन';

  @override
  String get settingsAutoReload => 'अपने-आप रीलोड';

  @override
  String get settingsAutoReloadHint =>
      'वरना नीचे स्वाइप करके या कारतूसों पर टैप करके रीलोड करें.';

  @override
  String get settingsDebug => 'डीबग: हिटबॉक्स और शॉट';

  @override
  String get settingsDebugHint => 'सिर्फ़ डीबग बिल्ड में.';

  @override
  String get settingsRestore => 'ख़रीदारी बहाल करें';

  @override
  String get leaderboardThisPhone => 'यह फ़ोन';

  @override
  String get leaderboardOnline => 'ऑनलाइन';

  @override
  String get leaderboardEmpty =>
      'अभी कोई स्कोर नहीं. जाइए, कुछ बत्तखें गिराइए!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · सटीकता $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games पर सभी खिलाड़ियों के स्कोर.';

  @override
  String get leaderboardSignInInfo =>
      'साइन इन करें और दूसरों से मुक़ाबला करें.';

  @override
  String get leaderboardOpen => 'खोलें';

  @override
  String get leaderboardSignIn => 'साइन इन';

  @override
  String get gameOverTitle => 'राउंड ख़त्म';

  @override
  String get gameOverNewRecord => 'नया रिकॉर्ड!';

  @override
  String get gameOverInitials =>
      'आप लीडरबोर्ड में आ गए! अपने नाम के पहले अक्षर:';

  @override
  String get gameOverReplay => 'फिर से';

  @override
  String get statBest => 'सर्वश्रेष्ठ';

  @override
  String get statAccuracy => 'सटीकता';

  @override
  String get statStreak => 'लगातार';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'स्किन ($count)';
  }

  @override
  String get skinsFree => 'मुफ़्त';

  @override
  String get skinsOwned => 'आपकी';

  @override
  String get skinsAnimated => 'पंख फड़फड़ाए';

  @override
  String skinsUnlock(String price) {
    return '$price में अनलॉक करें';
  }

  @override
  String get skinsUnlockNoPrice => 'अनलॉक करें';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count स्किन, हर एक में बत्तख और उसका अपना बैकग्राउंड. हमेशा के लिए आपकी, आपके सभी डिवाइस पर.',
      one:
          '$count स्किन: एक बत्तख और उसका अपना बैकग्राउंड. हमेशा के लिए आपकी, आपके सभी डिवाइस पर.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'स्टोर अभी उपलब्ध नहीं है. बाद में फिर कोशिश करें.';

  @override
  String get skinsRestore => 'ख़रीदारी बहाल करें';

  @override
  String get skinsRestoreDone => 'ख़रीदारी बहाल हो गई.';

  @override
  String get skinsThanks => 'धन्यवाद! पैक अब आपका है.';

  @override
  String get skinsAllTitle => 'सभी पैक';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'सभी $packs पैक की $skins स्किन एक साथ, लगभग आधी क़ीमत में. हमेशा के लिए आपकी, आपके सभी डिवाइस पर.';
  }
}
