// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get menuTagline => '90초. 탄환 8발. 오리는 잔뜩.';

  @override
  String get menuPlay => '플레이';

  @override
  String get menuSkins => '스킨';

  @override
  String get menuLeaderboard => '순위표';

  @override
  String get menuSettings => '설정';

  @override
  String get menuOnlineLeaderboard => '온라인 순위표';

  @override
  String get signIn => '로그인';

  @override
  String get pause => '일시정지';

  @override
  String get pauseResume => '계속하기';

  @override
  String get pauseRestart => '처음부터';

  @override
  String get backToMenu => '메뉴';

  @override
  String get hudReloading => '재장전 중…';

  @override
  String get hudReloadHint => '아래로 스와이프하거나 여기를 탭';

  @override
  String get settingsSound => '사운드';

  @override
  String get settingsHaptics => '진동';

  @override
  String get settingsAutoReload => '자동 재장전';

  @override
  String get settingsAutoReloadHint => '끄면 아래로 스와이프하거나 탄환을 탭해서 재장전합니다.';

  @override
  String get settingsDebug => '디버그: 히트박스와 사격';

  @override
  String get settingsDebugHint => '디버그 빌드 전용.';

  @override
  String get settingsRestore => '구매 복원';

  @override
  String get leaderboardThisPhone => '이 기기';

  @override
  String get leaderboardOnline => '온라인';

  @override
  String get leaderboardEmpty => '아직 점수가 없어요. 오리 사냥을 떠나 보세요!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · 명중률 $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Game Center / Play Games의 모든 플레이어 점수.';

  @override
  String get leaderboardSignInInfo => '로그인하고 다른 사람과 겨뤄 보세요.';

  @override
  String get leaderboardOpen => '열기';

  @override
  String get leaderboardSignIn => '로그인';

  @override
  String get gameOverTitle => '라운드 종료';

  @override
  String get gameOverNewRecord => '신기록!';

  @override
  String get gameOverInitials => '순위표에 올랐어요! 이니셜을 입력하세요:';

  @override
  String get gameOverReplay => '다시';

  @override
  String get statBest => '최고';

  @override
  String get statAccuracy => '명중률';

  @override
  String get statStreak => '연속';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return '스킨 ($count)';
  }

  @override
  String get skinsFree => '무료';

  @override
  String get skinsOwned => '보유';

  @override
  String get skinsAnimated => '날갯짓';

  @override
  String skinsUnlock(String price) {
    return '$price에 잠금 해제';
  }

  @override
  String get skinsUnlockNoPrice => '잠금 해제';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '스킨 $count개, 각각 오리와 전용 배경이 함께 있어요. 영원히 내 것, 모든 기기에서.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => '지금은 스토어를 사용할 수 없어요. 나중에 다시 시도하세요.';

  @override
  String get skinsRestore => '구매 복원';

  @override
  String get skinsRestoreDone => '구매를 복원했어요.';

  @override
  String get skinsThanks => '감사합니다! 팩이 이제 당신 것이에요.';

  @override
  String get skinsAllTitle => '모든 팩';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$packs개 팩의 스킨 $skins개를 한 번에, 약 절반 가격으로. 영원히 내 것, 모든 기기에서.';
  }
}
