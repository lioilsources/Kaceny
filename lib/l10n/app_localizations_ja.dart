// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get menuTagline => '90秒、弾は8発、カモはたくさん。';

  @override
  String get menuPlay => 'プレイ';

  @override
  String get menuSkins => 'スキン';

  @override
  String get menuLeaderboard => 'ランキング';

  @override
  String get menuSettings => '設定';

  @override
  String get menuOnlineLeaderboard => 'オンラインランキング';

  @override
  String get signIn => 'サインイン';

  @override
  String get pause => '一時停止';

  @override
  String get pauseResume => '再開';

  @override
  String get pauseRestart => '最初から';

  @override
  String get backToMenu => 'メニュー';

  @override
  String get hudReloading => 'リロード中…';

  @override
  String get hudReloadHint => '下にスワイプかここをタップ';

  @override
  String get settingsSound => 'サウンド';

  @override
  String get settingsHaptics => 'バイブレーション';

  @override
  String get settingsAutoReload => 'オートリロード';

  @override
  String get settingsAutoReloadHint => 'オフの場合は、下にスワイプするか弾をタップしてリロードします。';

  @override
  String get settingsDebug => 'デバッグ：当たり判定と射撃';

  @override
  String get settingsDebugHint => 'デバッグビルドのみ。';

  @override
  String get settingsRestore => '購入を復元';

  @override
  String get leaderboardThisPhone => 'この端末';

  @override
  String get leaderboardOnline => 'オンライン';

  @override
  String get leaderboardEmpty => 'まだスコアがありません。カモを撃ちに行こう！';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · 命中率 $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Game Center / Play Games の全プレイヤーのスコア。';

  @override
  String get leaderboardSignInInfo => 'サインインしてほかのプレイヤーと比べよう。';

  @override
  String get leaderboardOpen => '開く';

  @override
  String get leaderboardSignIn => 'サインイン';

  @override
  String get gameOverTitle => 'ラウンド終了';

  @override
  String get gameOverNewRecord => '新記録！';

  @override
  String get gameOverInitials => 'ランキング入り！イニシャルを入力：';

  @override
  String get gameOverReplay => 'もう一度';

  @override
  String get statBest => 'ベスト';

  @override
  String get statAccuracy => '命中率';

  @override
  String get statStreak => '連続';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'スキン（$count）';
  }

  @override
  String get skinsFree => '無料';

  @override
  String get skinsOwned => '購入済み';

  @override
  String get skinsAnimated => '羽ばたく';

  @override
  String skinsUnlock(String price) {
    return '$priceで解放';
  }

  @override
  String get skinsUnlockNoPrice => '解放';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'スキン$count種類、それぞれカモと専用の背景付き。ずっとあなたのもの、すべての端末で使えます。',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'ストアは現在利用できません。しばらくしてからお試しください。';

  @override
  String get skinsRestore => '購入を復元';

  @override
  String get skinsRestoreDone => '購入を復元しました。';

  @override
  String get skinsThanks => 'ありがとう！パックはあなたのものです。';

  @override
  String get skinsAllTitle => '全パック';

  @override
  String skinsAllBody(int skins, int packs) {
    return '全$packsパックのスキン$skins種類をまとめて、約半額で。ずっとあなたのもの、すべての端末で使えます。';
  }
}
