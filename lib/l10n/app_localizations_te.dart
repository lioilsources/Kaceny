// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get menuTagline => '90 సెకన్లు. 8 తూటాలు. బోలెడు బాతులు.';

  @override
  String get menuPlay => 'ఆడండి';

  @override
  String get menuSkins => 'స్కిన్‌లు';

  @override
  String get menuLeaderboard => 'లీడర్‌బోర్డ్';

  @override
  String get menuSettings => 'సెట్టింగ్‌లు';

  @override
  String get menuOnlineLeaderboard => 'ఆన్‌లైన్ లీడర్‌బోర్డ్';

  @override
  String get signIn => 'సైన్ ఇన్ చేయండి';

  @override
  String get pause => 'ఆపండి';

  @override
  String get pauseResume => 'కొనసాగించండి';

  @override
  String get pauseRestart => 'మళ్లీ మొదలుపెట్టండి';

  @override
  String get backToMenu => 'మెనూ';

  @override
  String get hudReloading => 'రీలోడ్ అవుతోంది…';

  @override
  String get hudReloadHint => 'కిందకు స్వైప్ చేయండి లేదా ఇక్కడ ట్యాప్ చేయండి';

  @override
  String get settingsSound => 'శబ్దం';

  @override
  String get settingsHaptics => 'వైబ్రేషన్';

  @override
  String get settingsAutoReload => 'ఆటోమేటిక్ రీలోడ్';

  @override
  String get settingsAutoReloadHint =>
      'లేకపోతే కిందకు స్వైప్ చేసి లేదా తూటాలపై ట్యాప్ చేసి రీలోడ్ చేయండి.';

  @override
  String get settingsDebug => 'డీబగ్: హిట్‌బాక్స్‌లు, షాట్‌లు';

  @override
  String get settingsDebugHint => 'డీబగ్ బిల్డ్‌లో మాత్రమే.';

  @override
  String get settingsRestore => 'కొనుగోళ్లను పునరుద్ధరించండి';

  @override
  String get leaderboardThisPhone => 'ఈ ఫోన్';

  @override
  String get leaderboardOnline => 'ఆన్‌లైన్';

  @override
  String get leaderboardEmpty =>
      'ఇంకా స్కోర్‌లు లేవు. వెళ్లి కొన్ని బాతులను కొట్టండి!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ఖచ్చితత్వం $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Gamesలో అందరు ఆటగాళ్ల స్కోర్‌లు.';

  @override
  String get leaderboardSignInInfo => 'సైన్ ఇన్ చేసి ఇతరులతో పోల్చుకోండి.';

  @override
  String get leaderboardOpen => 'తెరవండి';

  @override
  String get leaderboardSignIn => 'సైన్ ఇన్';

  @override
  String get gameOverTitle => 'రౌండ్ ముగిసింది';

  @override
  String get gameOverNewRecord => 'కొత్త రికార్డ్!';

  @override
  String get gameOverInitials =>
      'మీరు లీడర్‌బోర్డ్‌లోకి వచ్చారు! మీ పేరు మొదటి అక్షరాలు:';

  @override
  String get gameOverReplay => 'మళ్లీ';

  @override
  String get statBest => 'ఉత్తమం';

  @override
  String get statAccuracy => 'ఖచ్చితత్వం';

  @override
  String get statStreak => 'వరుస';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'స్కిన్‌లు ($count)';
  }

  @override
  String get skinsFree => 'ఉచితం';

  @override
  String get skinsOwned => 'మీది';

  @override
  String get skinsAnimated => 'రెక్కలాడిస్తుంది';

  @override
  String skinsUnlock(String price) {
    return '$priceకు అన్‌లాక్ చేయండి';
  }

  @override
  String get skinsUnlockNoPrice => 'అన్‌లాక్ చేయండి';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count స్కిన్‌లు, ప్రతి దానిలో ఒక బాతు, సొంత నేపథ్యం. ఎప్పటికీ మీవే, మీ అన్ని పరికరాల్లో.',
      one:
          '$count స్కిన్: ఒక బాతు, దాని సొంత నేపథ్యం. ఎప్పటికీ మీదే, మీ అన్ని పరికరాల్లో.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'స్టోర్ ఇప్పుడు అందుబాటులో లేదు. తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get skinsRestore => 'కొనుగోళ్లను పునరుద్ధరించండి';

  @override
  String get skinsRestoreDone => 'కొనుగోళ్లు పునరుద్ధరించబడ్డాయి.';

  @override
  String get skinsThanks => 'ధన్యవాదాలు! ప్యాక్ ఇప్పుడు మీది.';

  @override
  String get skinsAllTitle => 'అన్ని ప్యాక్‌లు';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'అన్ని $packs ప్యాక్‌ల నుండి $skins స్కిన్‌లు ఒకేసారి, దాదాపు సగం ధరకు. ఎప్పటికీ మీవే, మీ అన్ని పరికరాల్లో.';
  }
}
