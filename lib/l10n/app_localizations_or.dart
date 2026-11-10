// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get menuTagline => '90 ସେକେଣ୍ଡ। 8ଟି କାର୍ତ୍ତୁଜ। ଅନେକ ବତକ।';

  @override
  String get menuPlay => 'ଖେଳନ୍ତୁ';

  @override
  String get menuSkins => 'ସ୍କିନ୍';

  @override
  String get menuLeaderboard => 'ଲିଡରବୋର୍ଡ';

  @override
  String get menuSettings => 'ସେଟିଂସ';

  @override
  String get menuOnlineLeaderboard => 'ଅନଲାଇନ୍ ଲିଡରବୋର୍ଡ';

  @override
  String get signIn => 'ସାଇନ୍ ଇନ୍ କରନ୍ତୁ';

  @override
  String get pause => 'ବିରତି';

  @override
  String get pauseResume => 'ଜାରି ରଖନ୍ତୁ';

  @override
  String get pauseRestart => 'ପୁଣି ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get backToMenu => 'ମେନୁ';

  @override
  String get hudReloading => 'ରିଲୋଡ୍ ହେଉଛି…';

  @override
  String get hudReloadHint => 'ତଳକୁ ସ୍ୱାଇପ୍ କରନ୍ତୁ ବା ଏଠାରେ ଟ୍ୟାପ୍ କରନ୍ତୁ';

  @override
  String get settingsSound => 'ଶବ୍ଦ';

  @override
  String get settingsHaptics => 'କମ୍ପନ';

  @override
  String get settingsAutoReload => 'ସ୍ୱୟଂଚାଳିତ ରିଲୋଡ୍';

  @override
  String get settingsAutoReloadHint =>
      'ନଚେତ୍ ତଳକୁ ସ୍ୱାଇପ୍ କରି ବା କାର୍ତ୍ତୁଜରେ ଟ୍ୟାପ୍ କରି ରିଲୋଡ୍ କରନ୍ତୁ।';

  @override
  String get settingsDebug => 'ଡିବଗ୍: ହିଟବକ୍ସ ଓ ଶଟ୍';

  @override
  String get settingsDebugHint => 'କେବଳ ଡିବଗ୍ ବିଲ୍ଡରେ।';

  @override
  String get settingsRestore => 'କ୍ରୟ ପୁନଃସ୍ଥାପନ କରନ୍ତୁ';

  @override
  String get leaderboardThisPhone => 'ଏହି ଫୋନ୍';

  @override
  String get leaderboardOnline => 'ଅନଲାଇନ୍';

  @override
  String get leaderboardEmpty =>
      'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସ୍କୋର ନାହିଁ। ଯାଆନ୍ତୁ, କିଛି ବତକ ଶିକାର କରନ୍ତୁ!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ସଠିକତା $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games ରେ ସମସ୍ତ ଖେଳାଳିଙ୍କ ସ୍କୋର।';

  @override
  String get leaderboardSignInInfo =>
      'ସାଇନ୍ ଇନ୍ କରି ଅନ୍ୟମାନଙ୍କ ସହ ତୁଳନା କରନ୍ତୁ।';

  @override
  String get leaderboardOpen => 'ଖୋଲନ୍ତୁ';

  @override
  String get leaderboardSignIn => 'ସାଇନ୍ ଇନ୍';

  @override
  String get gameOverTitle => 'ରାଉଣ୍ଡ ଶେଷ';

  @override
  String get gameOverNewRecord => 'ନୂଆ ରେକର୍ଡ!';

  @override
  String get gameOverInitials =>
      'ଆପଣ ଲିଡରବୋର୍ଡରେ ପହଞ୍ଚିଲେ! ଆପଣଙ୍କ ନାମର ପ୍ରଥମ ଅକ୍ଷର:';

  @override
  String get gameOverReplay => 'ପୁଣି';

  @override
  String get statBest => 'ସର୍ବୋତ୍ତମ';

  @override
  String get statAccuracy => 'ସଠିକତା';

  @override
  String get statStreak => 'କ୍ରମାଗତ';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'ସ୍କିନ୍ ($count)';
  }

  @override
  String get skinsFree => 'ମାଗଣା';

  @override
  String get skinsOwned => 'ଆପଣଙ୍କର';

  @override
  String get skinsAnimated => 'ଡେଣା ହଲାଏ';

  @override
  String skinsUnlock(String price) {
    return '$price ରେ ଅନଲକ୍ କରନ୍ତୁ';
  }

  @override
  String get skinsUnlockNoPrice => 'ଅନଲକ୍ କରନ୍ତୁ';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countଟି ସ୍କିନ୍, ପ୍ରତ୍ୟେକରେ ଗୋଟିଏ ବତକ ଓ ନିଜସ୍ୱ ପୃଷ୍ଠଭୂମି। ସବୁଦିନ ପାଇଁ ଆପଣଙ୍କର, ଆପଣଙ୍କ ସମସ୍ତ ଡିଭାଇସରେ।',
      one:
          '$countଟି ସ୍କିନ୍: ଗୋଟିଏ ବତକ ଓ ତାର ନିଜସ୍ୱ ପୃଷ୍ଠଭୂମି। ସବୁଦିନ ପାଇଁ ଆପଣଙ୍କର, ଆପଣଙ୍କ ସମସ୍ତ ଡିଭାଇସରେ।',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'ଷ୍ଟୋର ଏବେ ଉପଲବ୍ଧ ନାହିଁ। ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get skinsRestore => 'କ୍ରୟ ପୁନଃସ୍ଥାପନ କରନ୍ତୁ';

  @override
  String get skinsRestoreDone => 'କ୍ରୟ ପୁନଃସ୍ଥାପିତ ହେଲା।';

  @override
  String get skinsThanks => 'ଧନ୍ୟବାଦ! ପ୍ୟାକଟି ଏବେ ଆପଣଙ୍କର।';

  @override
  String get skinsAllTitle => 'ସମସ୍ତ ପ୍ୟାକ';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'ସମସ୍ତ $packsଟି ପ୍ୟାକର $skinsଟି ସ୍କିନ୍ ଏକାଥରେ, ପ୍ରାୟ ଅଧା ଦାମରେ। ସବୁଦିନ ପାଇଁ ଆପଣଙ୍କର, ଆପଣଙ୍କ ସମସ୍ତ ଡିଭାଇସରେ।';
  }
}
