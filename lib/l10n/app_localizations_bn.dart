// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get menuTagline => '৯০ সেকেন্ড। ৮টি কার্তুজ। অনেক হাঁস।';

  @override
  String get menuPlay => 'খেলুন';

  @override
  String get menuSkins => 'স্কিন';

  @override
  String get menuLeaderboard => 'লিডারবোর্ড';

  @override
  String get menuSettings => 'সেটিংস';

  @override
  String get menuOnlineLeaderboard => 'অনলাইন লিডারবোর্ড';

  @override
  String get signIn => 'সাইন ইন করুন';

  @override
  String get pause => 'বিরতি';

  @override
  String get pauseResume => 'চালিয়ে যান';

  @override
  String get pauseRestart => 'আবার শুরু করুন';

  @override
  String get backToMenu => 'মেনু';

  @override
  String get hudReloading => 'রিলোড হচ্ছে…';

  @override
  String get hudReloadHint => 'নিচে সোয়াইপ করুন বা এখানে ট্যাপ করুন';

  @override
  String get settingsSound => 'শব্দ';

  @override
  String get settingsHaptics => 'কম্পন';

  @override
  String get settingsAutoReload => 'স্বয়ংক্রিয় রিলোড';

  @override
  String get settingsAutoReloadHint =>
      'না হলে নিচে সোয়াইপ করে বা কার্তুজে ট্যাপ করে রিলোড করুন।';

  @override
  String get settingsDebug => 'ডিবাগ: হিটবক্স ও শট';

  @override
  String get settingsDebugHint => 'শুধু ডিবাগ বিল্ডে।';

  @override
  String get settingsRestore => 'কেনাকাটা পুনরুদ্ধার করুন';

  @override
  String get leaderboardThisPhone => 'এই ফোন';

  @override
  String get leaderboardOnline => 'অনলাইন';

  @override
  String get leaderboardEmpty =>
      'এখনও কোনো স্কোর নেই। যান, কিছু হাঁস শিকার করুন!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · নির্ভুলতা $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Game Center / Play Games-এ সব খেলোয়াড়ের স্কোর।';

  @override
  String get leaderboardSignInInfo =>
      'সাইন ইন করে অন্যদের সঙ্গে নিজেকে মিলিয়ে দেখুন।';

  @override
  String get leaderboardOpen => 'খুলুন';

  @override
  String get leaderboardSignIn => 'সাইন ইন';

  @override
  String get gameOverTitle => 'রাউন্ড শেষ';

  @override
  String get gameOverNewRecord => 'নতুন রেকর্ড!';

  @override
  String get gameOverInitials =>
      'আপনি লিডারবোর্ডে উঠেছেন! আপনার নামের আদ্যক্ষর:';

  @override
  String get gameOverReplay => 'আবার';

  @override
  String get statBest => 'সেরা';

  @override
  String get statAccuracy => 'নির্ভুলতা';

  @override
  String get statStreak => 'টানা';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'স্কিন ($count)';
  }

  @override
  String get skinsFree => 'ফ্রি';

  @override
  String get skinsOwned => 'আপনার';

  @override
  String get skinsAnimated => 'ডানা ঝাপটায়';

  @override
  String skinsUnlock(String price) {
    return '$price-এ আনলক করুন';
  }

  @override
  String get skinsUnlockNoPrice => 'আনলক করুন';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countটি স্কিন, প্রতিটিতে একটি হাঁস ও তার নিজস্ব পটভূমি। চিরকাল আপনার, আপনার সব ডিভাইসে।',
      one:
          '$countটি স্কিন: একটি হাঁস ও তার নিজস্ব পটভূমি। চিরকাল আপনার, আপনার সব ডিভাইসে।',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'স্টোর এখন পাওয়া যাচ্ছে না। পরে আবার চেষ্টা করুন।';

  @override
  String get skinsRestore => 'কেনাকাটা পুনরুদ্ধার করুন';

  @override
  String get skinsRestoreDone => 'কেনাকাটা পুনরুদ্ধার হয়েছে।';

  @override
  String get skinsThanks => 'ধন্যবাদ! প্যাকটি এখন আপনার।';

  @override
  String get skinsAllTitle => 'সব প্যাক';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'সব $packsটি প্যাকের $skinsটি স্কিন একসঙ্গে, প্রায় অর্ধেক দামে। চিরকাল আপনার, আপনার সব ডিভাইসে।';
  }
}
