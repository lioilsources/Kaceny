// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get menuTagline => '90 સેકન્ડ. 8 કારતૂસ. ઢગલો બતક.';

  @override
  String get menuPlay => 'રમો';

  @override
  String get menuSkins => 'સ્કિન';

  @override
  String get menuLeaderboard => 'લીડરબોર્ડ';

  @override
  String get menuSettings => 'સેટિંગ્સ';

  @override
  String get menuOnlineLeaderboard => 'ઓનલાઇન લીડરબોર્ડ';

  @override
  String get signIn => 'સાઇન ઇન કરો';

  @override
  String get pause => 'થોભો';

  @override
  String get pauseResume => 'ચાલુ રાખો';

  @override
  String get pauseRestart => 'ફરી શરૂ કરો';

  @override
  String get backToMenu => 'મેનૂ';

  @override
  String get hudReloading => 'રીલોડ થઈ રહ્યું છે…';

  @override
  String get hudReloadHint => 'નીચે સ્વાઇપ કરો અથવા અહીં ટૅપ કરો';

  @override
  String get settingsSound => 'અવાજ';

  @override
  String get settingsHaptics => 'વાઇબ્રેશન';

  @override
  String get settingsAutoReload => 'આપોઆપ રીલોડ';

  @override
  String get settingsAutoReloadHint =>
      'નહીંતર નીચે સ્વાઇપ કરીને અથવા કારતૂસ પર ટૅપ કરીને રીલોડ કરો.';

  @override
  String get settingsDebug => 'ડીબગ: હિટબૉક્સ અને શૉટ';

  @override
  String get settingsDebugHint => 'ફક્ત ડીબગ બિલ્ડમાં.';

  @override
  String get settingsRestore => 'ખરીદી પુનઃસ્થાપિત કરો';

  @override
  String get leaderboardThisPhone => 'આ ફોન';

  @override
  String get leaderboardOnline => 'ઓનલાઇન';

  @override
  String get leaderboardEmpty => 'હજી કોઈ સ્કોર નથી. ચાલો, થોડાં બતક પાડો!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ચોકસાઈ $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games પર બધા ખેલાડીઓના સ્કોર.';

  @override
  String get leaderboardSignInInfo => 'સાઇન ઇન કરો અને બીજાઓ સાથે સરખામણી કરો.';

  @override
  String get leaderboardOpen => 'ખોલો';

  @override
  String get leaderboardSignIn => 'સાઇન ઇન';

  @override
  String get gameOverTitle => 'રાઉન્ડ પૂરો';

  @override
  String get gameOverNewRecord => 'નવો રેકોર્ડ!';

  @override
  String get gameOverInitials =>
      'તમે લીડરબોર્ડમાં આવી ગયા! તમારા નામના આદ્યાક્ષરો:';

  @override
  String get gameOverReplay => 'ફરીથી';

  @override
  String get statBest => 'શ્રેષ્ઠ';

  @override
  String get statAccuracy => 'ચોકસાઈ';

  @override
  String get statStreak => 'સતત';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'સ્કિન ($count)';
  }

  @override
  String get skinsFree => 'મફત';

  @override
  String get skinsOwned => 'તમારી';

  @override
  String get skinsAnimated => 'પાંખ ફફડાવે';

  @override
  String skinsUnlock(String price) {
    return '$priceમાં અનલૉક કરો';
  }

  @override
  String get skinsUnlockNoPrice => 'અનલૉક કરો';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count સ્કિન, દરેકમાં એક બતક અને પોતાની પૃષ્ઠભૂમિ. હંમેશ માટે તમારી, તમારાં બધાં ઉપકરણો પર.',
      one:
          '$count સ્કિન: એક બતક અને તેની પોતાની પૃષ્ઠભૂમિ. હંમેશ માટે તમારી, તમારાં બધાં ઉપકરણો પર.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'સ્ટોર અત્યારે ઉપલબ્ધ નથી. પછી ફરી પ્રયાસ કરો.';

  @override
  String get skinsRestore => 'ખરીદી પુનઃસ્થાપિત કરો';

  @override
  String get skinsRestoreDone => 'ખરીદી પુનઃસ્થાપિત થઈ.';

  @override
  String get skinsThanks => 'આભાર! પૅક હવે તમારું છે.';

  @override
  String get skinsAllTitle => 'બધાં પૅક';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'બધાં $packs પૅકની $skins સ્કિન એકસાથે, લગભગ અડધી કિંમતે. હંમેશ માટે તમારી, તમારાં બધાં ઉપકરણો પર.';
  }
}
