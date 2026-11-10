// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get menuTagline => '90 sekund. 8 nabojev. Kup rac.';

  @override
  String get menuPlay => 'IGRAJ';

  @override
  String get menuSkins => 'Videzi';

  @override
  String get menuLeaderboard => 'Lestvica';

  @override
  String get menuSettings => 'Nastavitve';

  @override
  String get menuOnlineLeaderboard => 'Spletna lestvica';

  @override
  String get signIn => 'Prijava';

  @override
  String get pause => 'Premor';

  @override
  String get pauseResume => 'Nadaljuj';

  @override
  String get pauseRestart => 'Začni znova';

  @override
  String get backToMenu => 'Meni';

  @override
  String get hudReloading => 'polnim…';

  @override
  String get hudReloadHint => 'podrsaj navzdol ali tapni tukaj';

  @override
  String get settingsSound => 'Zvok';

  @override
  String get settingsHaptics => 'Vibriranje';

  @override
  String get settingsAutoReload => 'Samodejno polnjenje';

  @override
  String get settingsAutoReloadHint =>
      'Sicer napolniš s podrsom navzdol ali tapom na naboje.';

  @override
  String get settingsDebug => 'Debug: območja zadetkov in streli';

  @override
  String get settingsDebugHint => 'Samo v razhroščevalni različici.';

  @override
  String get settingsRestore => 'Obnovi nakupe';

  @override
  String get leaderboardThisPhone => 'Ta telefon';

  @override
  String get leaderboardOnline => 'Na spletu';

  @override
  String get leaderboardEmpty => 'Še ni rezultatov. Pojdi streljat race!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · natančnost $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Rezultati vseh igralcev v Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'Prijavi se in se primerjaj z drugimi.';

  @override
  String get leaderboardOpen => 'Odpri';

  @override
  String get leaderboardSignIn => 'Prijava';

  @override
  String get gameOverTitle => 'Konec kroga';

  @override
  String get gameOverNewRecord => 'NOV REKORD!';

  @override
  String get gameOverInitials => 'Prišel si na lestvico! Tvoje začetnice:';

  @override
  String get gameOverReplay => 'Še enkrat';

  @override
  String get statBest => 'najboljše';

  @override
  String get statAccuracy => 'natančnost';

  @override
  String get statStreak => 'niz';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Videzi ($count)';
  }

  @override
  String get skinsFree => 'brezplačno';

  @override
  String get skinsOwned => 'tvoje';

  @override
  String get skinsAnimated => 'maha';

  @override
  String skinsUnlock(String price) {
    return 'Odkleni za $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Odkleni';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count videzov, vsak z raco in lastnim ozadjem. Tvoji za vedno, na vseh tvojih napravah.',
      few:
          '$count videzi, vsak z raco in lastnim ozadjem. Tvoji za vedno, na vseh tvojih napravah.',
      two:
          '$count videza, vsak z raco in lastnim ozadjem. Tvoja za vedno, na vseh tvojih napravah.',
      one:
          '$count videz: raca z lastnim ozadjem. Tvoj za vedno, na vseh tvojih napravah.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Trgovina trenutno ni na voljo. Poskusi pozneje.';

  @override
  String get skinsRestore => 'Obnovi nakupe';

  @override
  String get skinsRestoreDone => 'Nakupi so obnovljeni.';

  @override
  String get skinsThanks => 'Hvala! Paket je tvoj.';

  @override
  String get skinsAllTitle => 'Vsi paketi';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins videzov iz vseh $packs paketov naenkrat, za približno polovično ceno. Tvoji za vedno, na vseh tvojih napravah.';
  }
}
