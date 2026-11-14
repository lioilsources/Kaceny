// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get menuTagline => '90 sekund. 8 nabojów. Mnóstwo kaczek.';

  @override
  String get menuPlay => 'GRAJ';

  @override
  String get menuSkins => 'Skórki';

  @override
  String get menuLeaderboard => 'Ranking';

  @override
  String get menuSettings => 'Ustawienia';

  @override
  String get menuOnlineLeaderboard => 'Ranking online';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get pause => 'Pauza';

  @override
  String get pauseResume => 'Wznów';

  @override
  String get pauseRestart => 'Od nowa';

  @override
  String get backToMenu => 'Menu';

  @override
  String get hudReloading => 'przeładowuję…';

  @override
  String get hudReloadHint => 'przesuń w dół lub stuknij tutaj';

  @override
  String get settingsSound => 'Dźwięk';

  @override
  String get settingsHaptics => 'Wibracje';

  @override
  String get settingsAutoReload => 'Automatyczne przeładowanie';

  @override
  String get settingsAutoReloadHint => 'Inaczej przeładujesz, przesuwając palcem w dół lub stukając w naboje.';

  @override
  String get settingsDebug => 'Debug: hitboxy i strzały';

  @override
  String get settingsDebugHint => 'Tylko w wersji debug.';

  @override
  String get settingsRestore => 'Przywróć zakupy';

  @override
  String get settingsStats => 'Anonimowe statystyki';

  @override
  String get settingsStatsHint => 'Jakie ekrany i rundy są grane, nic, co by cię identyfikowało. Pomaga ulepszać grę.';

  @override
  String get leaderboardThisPhone => 'Ten telefon';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Brak wyników. Idź postrzelać!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · celność $accuracy';
  }

  @override
  String get leaderboardOnlineInfo => 'Wyniki wszystkich graczy w Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Zaloguj się i porównaj z innymi.';

  @override
  String get leaderboardOpen => 'Otwórz';

  @override
  String get leaderboardSignIn => 'Zaloguj';

  @override
  String get gameOverTitle => 'Koniec rundy';

  @override
  String get gameOverNewRecord => 'NOWY REKORD!';

  @override
  String get gameOverInitials => 'Jesteś w rankingu! Twoje inicjały:';

  @override
  String get gameOverReplay => 'Jeszcze raz';

  @override
  String get statBest => 'najlepszy';

  @override
  String get statAccuracy => 'celność';

  @override
  String get statStreak => 'seria';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Skórki ($count)';
  }

  @override
  String get skinsFree => 'za darmo';

  @override
  String get skinsOwned => 'twoje';

  @override
  String get skinsAnimated => 'macha';

  @override
  String skinsUnlock(String price) {
    return 'Odblokuj za $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Odblokuj';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skórki, każda z kaczką i własnym tłem. Twoje na zawsze, na wszystkich twoich urządzeniach.',
      many: '$count skórek, każda z kaczką i własnym tłem. Twoje na zawsze, na wszystkich twoich urządzeniach.',
      few: '$count skórki, każda z kaczką i własnym tłem. Twoje na zawsze, na wszystkich twoich urządzeniach.',
      one: '$count skórka: kaczka z własnym tłem. Twoja na zawsze, na wszystkich twoich urządzeniach.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable => 'Sklep jest teraz niedostępny. Spróbuj później.';

  @override
  String get skinsRestore => 'Przywróć zakupy';

  @override
  String get skinsRestoreDone => 'Zakupy przywrócone.';

  @override
  String get skinsThanks => 'Dzięki! Pakiet jest twój.';

  @override
  String get skinsAllTitle => 'Wszystkie pakiety';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skórek ze wszystkich $packs pakietów naraz, za mniej więcej połowę ceny. Na zawsze twoje, na wszystkich urządzeniach.';
  }
}
