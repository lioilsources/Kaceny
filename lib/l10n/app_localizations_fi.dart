// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get menuTagline => '90 sekuntia. 8 patruunaa. Paljon sorsia.';

  @override
  String get menuPlay => 'PELAA';

  @override
  String get menuSkins => 'Skinit';

  @override
  String get menuLeaderboard => 'Tulostaulu';

  @override
  String get menuSettings => 'Asetukset';

  @override
  String get menuOnlineLeaderboard => 'Verkon tulostaulu';

  @override
  String get signIn => 'Kirjaudu';

  @override
  String get pause => 'Tauko';

  @override
  String get pauseResume => 'Jatka';

  @override
  String get pauseRestart => 'Aloita alusta';

  @override
  String get backToMenu => 'Valikko';

  @override
  String get hudReloading => 'ladataan…';

  @override
  String get hudReloadHint => 'pyyhkäise alas tai napauta tästä';

  @override
  String get settingsSound => 'Ääni';

  @override
  String get settingsHaptics => 'Värinä';

  @override
  String get settingsAutoReload => 'Automaattinen lataus';

  @override
  String get settingsAutoReloadHint =>
      'Muuten lataat pyyhkäisemällä alas tai napauttamalla patruunoita.';

  @override
  String get settingsDebug => 'Debug: osuma-alueet ja laukaukset';

  @override
  String get settingsDebugHint => 'Vain debug-versiossa.';

  @override
  String get settingsRestore => 'Palauta ostot';

  @override
  String get leaderboardThisPhone => 'Tämä puhelin';

  @override
  String get leaderboardOnline => 'Verkossa';

  @override
  String get leaderboardEmpty => 'Ei vielä tuloksia. Mene ampumaan sorsia!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · tarkkuus $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Kaikkien pelaajien tulokset Game Centerissä / Play Gamesissa.';

  @override
  String get leaderboardSignInInfo => 'Kirjaudu ja vertaa itseäsi muihin.';

  @override
  String get leaderboardOpen => 'Avaa';

  @override
  String get leaderboardSignIn => 'Kirjaudu';

  @override
  String get gameOverTitle => 'Kierros ohi';

  @override
  String get gameOverNewRecord => 'UUSI ENNÄTYS!';

  @override
  String get gameOverInitials => 'Pääsit tulostauluun! Nimikirjaimesi:';

  @override
  String get gameOverReplay => 'Uudestaan';

  @override
  String get statBest => 'paras';

  @override
  String get statAccuracy => 'tarkkuus';

  @override
  String get statStreak => 'putki';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Skinit ($count)';
  }

  @override
  String get skinsFree => 'ilmainen';

  @override
  String get skinsOwned => 'sinun';

  @override
  String get skinsAnimated => 'räpyttää';

  @override
  String skinsUnlock(String price) {
    return 'Avaa hintaan $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Avaa';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count skiniä, jokaisessa sorsa ja oma tausta. Sinun ikuisesti, kaikilla laitteillasi.',
      one:
          '$count skini: sorsa ja oma tausta. Sinun ikuisesti, kaikilla laitteillasi.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Kauppa ei ole juuri nyt käytettävissä. Yritä myöhemmin uudelleen.';

  @override
  String get skinsRestore => 'Palauta ostot';

  @override
  String get skinsRestoreDone => 'Ostot palautettu.';

  @override
  String get skinsThanks => 'Kiitos! Paketti on sinun.';

  @override
  String get skinsAllTitle => 'Kaikki paketit';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins skiniä kaikista $packs paketista kerralla, noin puoleen hintaan. Sinun ikuisesti, kaikilla laitteillasi.';
  }
}
