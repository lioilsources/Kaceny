// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get menuTagline => '90 секунд. 8 набоїв. Безліч качок.';

  @override
  String get menuPlay => 'ГРАТИ';

  @override
  String get menuSkins => 'Скіни';

  @override
  String get menuLeaderboard => 'Рекорди';

  @override
  String get menuSettings => 'Налаштування';

  @override
  String get menuOnlineLeaderboard => 'Онлайн-рейтинг';

  @override
  String get signIn => 'Увійти';

  @override
  String get pause => 'Пауза';

  @override
  String get pauseResume => 'Продовжити';

  @override
  String get pauseRestart => 'Почати знову';

  @override
  String get backToMenu => 'Меню';

  @override
  String get hudReloading => 'перезаряджання…';

  @override
  String get hudReloadHint => 'проведи вниз або торкнися тут';

  @override
  String get settingsSound => 'Звук';

  @override
  String get settingsHaptics => 'Вібрація';

  @override
  String get settingsAutoReload => 'Автоперезаряджання';

  @override
  String get settingsAutoReloadHint =>
      'Інакше перезаряджай, провівши вниз або торкнувшись набоїв.';

  @override
  String get settingsDebug => 'Налагодження: хітбокси й постріли';

  @override
  String get settingsDebugHint => 'Лише в налагоджувальній збірці.';

  @override
  String get settingsRestore => 'Відновити покупки';

  @override
  String get leaderboardThisPhone => 'Цей телефон';

  @override
  String get leaderboardOnline => 'Онлайн';

  @override
  String get leaderboardEmpty => 'Поки немає результатів. Іди постріляй качок!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · влучність $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Результати всіх гравців у Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Увійди й порівняй себе з іншими.';

  @override
  String get leaderboardOpen => 'Відкрити';

  @override
  String get leaderboardSignIn => 'Увійти';

  @override
  String get gameOverTitle => 'Раунд завершено';

  @override
  String get gameOverNewRecord => 'НОВИЙ РЕКОРД!';

  @override
  String get gameOverInitials => 'Ти потрапив до рекордів! Твої ініціали:';

  @override
  String get gameOverReplay => 'Ще раз';

  @override
  String get statBest => 'найкращий';

  @override
  String get statAccuracy => 'влучність';

  @override
  String get statStreak => 'серія';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Скіни ($count)';
  }

  @override
  String get skinsFree => 'безкоштовно';

  @override
  String get skinsOwned => 'твій';

  @override
  String get skinsAnimated => 'махає';

  @override
  String skinsUnlock(String price) {
    return 'Відкрити за $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Відкрити';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count скіна, кожен — качка з власним тлом. Твої назавжди, на всіх твоїх пристроях.',
      many:
          '$count скінів, кожен — качка з власним тлом. Твої назавжди, на всіх твоїх пристроях.',
      few:
          '$count скіни, кожен — качка з власним тлом. Твої назавжди, на всіх твоїх пристроях.',
      one:
          '$count скін: качка з власним тлом. Твій назавжди, на всіх твоїх пристроях.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Магазин зараз недоступний. Спробуй пізніше.';

  @override
  String get skinsRestore => 'Відновити покупки';

  @override
  String get skinsRestoreDone => 'Покупки відновлено.';

  @override
  String get skinsThanks => 'Дякуємо! Набір твій.';

  @override
  String get skinsAllTitle => 'Усі набори';

  @override
  String skinsAllBody(int skins, int packs) {
    return 'Скіни з усіх наборів одразу ($skins шт., наборів: $packs) приблизно за пів ціни. Твої назавжди, на всіх твоїх пристроях.';
  }
}
