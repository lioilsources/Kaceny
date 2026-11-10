// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get menuTagline => '90 வினாடிகள். 8 தோட்டாக்கள். நிறைய வாத்துகள்.';

  @override
  String get menuPlay => 'விளையாடு';

  @override
  String get menuSkins => 'ஸ்கின்கள்';

  @override
  String get menuLeaderboard => 'தரவரிசை';

  @override
  String get menuSettings => 'அமைப்புகள்';

  @override
  String get menuOnlineLeaderboard => 'ஆன்லைன் தரவரிசை';

  @override
  String get signIn => 'உள்நுழை';

  @override
  String get pause => 'இடைநிறுத்து';

  @override
  String get pauseResume => 'தொடர்';

  @override
  String get pauseRestart => 'மீண்டும் தொடங்கு';

  @override
  String get backToMenu => 'மெனு';

  @override
  String get hudReloading => 'நிரப்புகிறது…';

  @override
  String get hudReloadHint => 'கீழே ஸ்வைப் செய் அல்லது இங்கே தட்டு';

  @override
  String get settingsSound => 'ஒலி';

  @override
  String get settingsHaptics => 'அதிர்வு';

  @override
  String get settingsAutoReload => 'தானியங்கு நிரப்புதல்';

  @override
  String get settingsAutoReloadHint =>
      'இல்லையெனில் கீழே ஸ்வைப் செய்து அல்லது தோட்டாக்களைத் தட்டி நிரப்பு.';

  @override
  String get settingsDebug => 'டீபக்: ஹிட்பாக்ஸ்களும் சுடுதல்களும்';

  @override
  String get settingsDebugHint => 'டீபக் பில்டில் மட்டும்.';

  @override
  String get settingsRestore => 'வாங்கியவற்றை மீட்டமை';

  @override
  String get leaderboardThisPhone => 'இந்த ஃபோன்';

  @override
  String get leaderboardOnline => 'ஆன்லைன்';

  @override
  String get leaderboardEmpty =>
      'இன்னும் மதிப்பெண் இல்லை. போய் சில வாத்துகளைச் சுடு!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · துல்லியம் $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games இல் எல்லா வீரர்களின் மதிப்பெண்கள்.';

  @override
  String get leaderboardSignInInfo =>
      'உள்நுழைந்து மற்றவர்களுடன் ஒப்பிட்டுப் பார்.';

  @override
  String get leaderboardOpen => 'திற';

  @override
  String get leaderboardSignIn => 'உள்நுழை';

  @override
  String get gameOverTitle => 'சுற்று முடிந்தது';

  @override
  String get gameOverNewRecord => 'புதிய சாதனை!';

  @override
  String get gameOverInitials =>
      'நீ தரவரிசையில் இடம்பிடித்தாய்! உன் முதலெழுத்துகள்:';

  @override
  String get gameOverReplay => 'மீண்டும்';

  @override
  String get statBest => 'சிறந்தது';

  @override
  String get statAccuracy => 'துல்லியம்';

  @override
  String get statStreak => 'தொடர்';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'ஸ்கின்கள் ($count)';
  }

  @override
  String get skinsFree => 'இலவசம்';

  @override
  String get skinsOwned => 'உன்னுடையது';

  @override
  String get skinsAnimated => 'சிறகடிக்கும்';

  @override
  String skinsUnlock(String price) {
    return '$priceக்குத் திற';
  }

  @override
  String get skinsUnlockNoPrice => 'திற';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ஸ்கின்கள், ஒவ்வொன்றிலும் ஒரு வாத்தும் சொந்தப் பின்னணியும். என்றும் உன்னுடையவை, உன் எல்லா சாதனங்களிலும்.',
      one:
          '$count ஸ்கின்: ஒரு வாத்தும் அதன் சொந்தப் பின்னணியும். என்றும் உன்னுடையது, உன் எல்லா சாதனங்களிலும்.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'ஸ்டோர் இப்போது கிடைக்கவில்லை. பிறகு முயற்சி செய்.';

  @override
  String get skinsRestore => 'வாங்கியவற்றை மீட்டமை';

  @override
  String get skinsRestoreDone => 'வாங்கியவை மீட்டமைக்கப்பட்டன.';

  @override
  String get skinsThanks => 'நன்றி! தொகுப்பு இப்போது உன்னுடையது.';

  @override
  String get skinsAllTitle => 'எல்லா தொகுப்புகளும்';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'எல்லா $packs தொகுப்புகளின் $skins ஸ்கின்களும் ஒரே நேரத்தில், ஏறக்குறைய பாதி விலையில். என்றும் உன்னுடையவை, உன் எல்லா சாதனங்களிலும்.';
  }
}
