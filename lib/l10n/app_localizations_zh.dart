// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get menuTagline => '90 秒。8 发子弹。好多鸭子。';

  @override
  String get menuPlay => '开始';

  @override
  String get menuSkins => '皮肤';

  @override
  String get menuLeaderboard => '排行榜';

  @override
  String get menuSettings => '设置';

  @override
  String get menuOnlineLeaderboard => '在线排行榜';

  @override
  String get signIn => '登录';

  @override
  String get pause => '暂停';

  @override
  String get pauseResume => '继续';

  @override
  String get pauseRestart => '重新开始';

  @override
  String get backToMenu => '菜单';

  @override
  String get hudReloading => '装弹中…';

  @override
  String get hudReloadHint => '向下滑动或点这里';

  @override
  String get settingsSound => '声音';

  @override
  String get settingsHaptics => '振动';

  @override
  String get settingsAutoReload => '自动装弹';

  @override
  String get settingsAutoReloadHint => '关闭时，向下滑动或点子弹来装弹。';

  @override
  String get settingsDebug => '调试：判定框和射击';

  @override
  String get settingsDebugHint => '仅限调试版本。';

  @override
  String get settingsRestore => '恢复购买';

  @override
  String get leaderboardThisPhone => '本机';

  @override
  String get leaderboardOnline => '在线';

  @override
  String get leaderboardEmpty => '还没有成绩。快去打鸭子吧！';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · 命中率 $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Game Center / Play Games 中所有玩家的成绩。';

  @override
  String get leaderboardSignInInfo => '登录后和其他玩家比一比。';

  @override
  String get leaderboardOpen => '打开';

  @override
  String get leaderboardSignIn => '登录';

  @override
  String get gameOverTitle => '本轮结束';

  @override
  String get gameOverNewRecord => '新纪录！';

  @override
  String get gameOverInitials => '你上榜了！输入你的姓名缩写：';

  @override
  String get gameOverReplay => '再来';

  @override
  String get statBest => '最佳';

  @override
  String get statAccuracy => '命中率';

  @override
  String get statStreak => '连中';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return '皮肤（$count）';
  }

  @override
  String get skinsFree => '免费';

  @override
  String get skinsOwned => '已拥有';

  @override
  String get skinsAnimated => '扇翅';

  @override
  String skinsUnlock(String price) {
    return '$price 解锁';
  }

  @override
  String get skinsUnlockNoPrice => '解锁';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 款皮肤，每款都有一只鸭子和专属背景。永久拥有，所有设备通用。',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => '商店暂时无法使用，请稍后再试。';

  @override
  String get skinsRestore => '恢复购买';

  @override
  String get skinsRestoreDone => '已恢复购买。';

  @override
  String get skinsThanks => '谢谢！这个皮肤包归你了。';

  @override
  String get skinsAllTitle => '全部皮肤包';

  @override
  String skinsAllBody(int skins, int packs) {
    return '一次获得全部 $packs 个皮肤包的 $skins 款皮肤，约半价。永久拥有，所有设备通用。';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get menuTagline => '90 秒。8 發子彈。一大堆鴨子。';

  @override
  String get menuPlay => '開始';

  @override
  String get menuSkins => '造型';

  @override
  String get menuLeaderboard => '排行榜';

  @override
  String get menuSettings => '設定';

  @override
  String get menuOnlineLeaderboard => '線上排行榜';

  @override
  String get signIn => '登入';

  @override
  String get pause => '暫停';

  @override
  String get pauseResume => '繼續';

  @override
  String get pauseRestart => '重新開始';

  @override
  String get backToMenu => '選單';

  @override
  String get hudReloading => '裝彈中…';

  @override
  String get hudReloadHint => '向下滑或點這裡';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsHaptics => '震動';

  @override
  String get settingsAutoReload => '自動裝彈';

  @override
  String get settingsAutoReloadHint => '關閉時，向下滑或點子彈來裝彈。';

  @override
  String get settingsDebug => '除錯：判定範圍與射擊';

  @override
  String get settingsDebugHint => '僅限除錯版本。';

  @override
  String get settingsRestore => '恢復購買項目';

  @override
  String get leaderboardThisPhone => '這支手機';

  @override
  String get leaderboardOnline => '線上';

  @override
  String get leaderboardEmpty => '還沒有成績。快去打鴨子吧！';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · 命中率 $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Game Center / Play Games 中所有玩家的成績。';

  @override
  String get leaderboardSignInInfo => '登入後和其他玩家比一比。';

  @override
  String get leaderboardOpen => '開啟';

  @override
  String get leaderboardSignIn => '登入';

  @override
  String get gameOverTitle => '本回合結束';

  @override
  String get gameOverNewRecord => '新紀錄！';

  @override
  String get gameOverInitials => '你上榜了！輸入你的姓名縮寫：';

  @override
  String get gameOverReplay => '再來';

  @override
  String get statBest => '最佳';

  @override
  String get statAccuracy => '命中率';

  @override
  String get statStreak => '連中';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return '造型（$count）';
  }

  @override
  String get skinsFree => '免費';

  @override
  String get skinsOwned => '已擁有';

  @override
  String get skinsAnimated => '拍翅';

  @override
  String skinsUnlock(String price) {
    return '以 $price 解鎖';
  }

  @override
  String get skinsUnlockNoPrice => '解鎖';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 款造型，每款都有一隻鴨子和專屬背景。永久擁有，所有裝置通用。',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => '商店目前無法使用，請稍後再試。';

  @override
  String get skinsRestore => '恢復購買項目';

  @override
  String get skinsRestoreDone => '已恢復購買項目。';

  @override
  String get skinsThanks => '謝謝！這個造型包是你的了。';

  @override
  String get skinsAllTitle => '全部造型包';

  @override
  String skinsAllBody(int skins, int packs) {
    return '一次取得全部 $packs 個造型包的 $skins 款造型，約半價。永久擁有，所有裝置通用。';
  }
}
