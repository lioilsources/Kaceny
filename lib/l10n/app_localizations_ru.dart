// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get menuTagline => '90 секунд. 8 патронов. Куча уток.';

  @override
  String get menuPlay => 'ИГРАТЬ';

  @override
  String get menuSkins => 'Скины';

  @override
  String get menuLeaderboard => 'Рекорды';

  @override
  String get menuSettings => 'Настройки';

  @override
  String get menuOnlineLeaderboard => 'Онлайн-рейтинг';

  @override
  String get signIn => 'Войти';

  @override
  String get pause => 'Пауза';

  @override
  String get pauseResume => 'Продолжить';

  @override
  String get pauseRestart => 'Начать заново';

  @override
  String get backToMenu => 'Меню';

  @override
  String get hudReloading => 'перезарядка…';

  @override
  String get hudReloadHint => 'смахни вниз или нажми сюда';

  @override
  String get settingsSound => 'Звук';

  @override
  String get settingsHaptics => 'Вибрация';

  @override
  String get settingsAutoReload => 'Автоперезарядка';

  @override
  String get settingsAutoReloadHint =>
      'Иначе перезаряжай, смахнув вниз или нажав на патроны.';

  @override
  String get settingsDebug => 'Отладка: хитбоксы и выстрелы';

  @override
  String get settingsDebugHint => 'Только в отладочной сборке.';

  @override
  String get settingsRestore => 'Восстановить покупки';

  @override
  String get leaderboardThisPhone => 'Этот телефон';

  @override
  String get leaderboardOnline => 'Онлайн';

  @override
  String get leaderboardEmpty => 'Пока нет результатов. Иди постреляй уток!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · точность $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Результаты всех игроков в Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Войди и сравни себя с другими.';

  @override
  String get leaderboardOpen => 'Открыть';

  @override
  String get leaderboardSignIn => 'Войти';

  @override
  String get gameOverTitle => 'Раунд окончен';

  @override
  String get gameOverNewRecord => 'НОВЫЙ РЕКОРД!';

  @override
  String get gameOverInitials => 'Ты попал в рекорды! Твои инициалы:';

  @override
  String get gameOverReplay => 'Ещё раз';

  @override
  String get statBest => 'лучший';

  @override
  String get statAccuracy => 'точность';

  @override
  String get statStreak => 'серия';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Скины ($count)';
  }

  @override
  String get skinsFree => 'бесплатно';

  @override
  String get skinsOwned => 'твой';

  @override
  String get skinsAnimated => 'машет';

  @override
  String skinsUnlock(String price) {
    return 'Открыть за $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Открыть';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count скина, каждый — утка со своим фоном. Твои навсегда, на всех твоих устройствах.',
      many:
          '$count скинов, каждый — утка со своим фоном. Твои навсегда, на всех твоих устройствах.',
      few:
          '$count скина, каждый — утка со своим фоном. Твои навсегда, на всех твоих устройствах.',
      one:
          '$count скин: утка со своим фоном. Твой навсегда, на всех твоих устройствах.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Магазин сейчас недоступен. Попробуй позже.';

  @override
  String get skinsRestore => 'Восстановить покупки';

  @override
  String get skinsRestoreDone => 'Покупки восстановлены.';

  @override
  String get skinsThanks => 'Спасибо! Набор твой.';

  @override
  String get skinsAllTitle => 'Все наборы';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'Скины из всех наборов сразу ($skins шт., наборов: $packs) примерно за полцены. Твои навсегда, на всех твоих устройствах.';
  }
}
