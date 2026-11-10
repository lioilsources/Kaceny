// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get menuTagline => '90 Sekunden. 8 Patronen. Jede Menge Enten.';

  @override
  String get menuPlay => 'SPIELEN';

  @override
  String get menuSkins => 'Skins';

  @override
  String get menuLeaderboard => 'Bestenliste';

  @override
  String get menuSettings => 'Einstellungen';

  @override
  String get menuOnlineLeaderboard => 'Online-Bestenliste';

  @override
  String get signIn => 'Anmelden';

  @override
  String get pause => 'Pause';

  @override
  String get pauseResume => 'Weiter';

  @override
  String get pauseRestart => 'Neu starten';

  @override
  String get backToMenu => 'Menü';

  @override
  String get hudReloading => 'lade nach…';

  @override
  String get hudReloadHint => 'nach unten wischen oder hier tippen';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAutoReload => 'Automatisch nachladen';

  @override
  String get settingsAutoReloadHint =>
      'Sonst lädst du nach, indem du nach unten wischst oder auf die Patronen tippst.';

  @override
  String get settingsDebug => 'Debug: Hitboxen und Schüsse';

  @override
  String get settingsDebugHint => 'Nur im Debug-Build.';

  @override
  String get settingsRestore => 'Käufe wiederherstellen';

  @override
  String get leaderboardThisPhone => 'Dieses Handy';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty => 'Noch keine Punkte. Los, ab auf Entenjagd!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · Trefferquote $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Ergebnisse aller Spieler in Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Melde dich an und miss dich mit anderen.';

  @override
  String get leaderboardOpen => 'Öffnen';

  @override
  String get leaderboardSignIn => 'Anmelden';

  @override
  String get gameOverTitle => 'Runde vorbei';

  @override
  String get gameOverNewRecord => 'NEUER REKORD!';

  @override
  String get gameOverInitials => 'Ab in die Bestenliste! Deine Initialen:';

  @override
  String get gameOverReplay => 'Nochmal';

  @override
  String get statBest => 'Bestwert';

  @override
  String get statAccuracy => 'Trefferquote';

  @override
  String get statStreak => 'Serie';

  @override
  String percent(int value) {
    return '$value %';
  }

  @override
  String skinsTitle(int count) {
    return 'Skins ($count)';
  }

  @override
  String get skinsFree => 'gratis';

  @override
  String get skinsOwned => 'deins';

  @override
  String get skinsAnimated => 'flattert';

  @override
  String skinsUnlock(String price) {
    return 'Freischalten für $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Freischalten';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Skins, jeder eine Ente mit eigenem Hintergrund. Für immer deine, auf all deinen Geräten.',
      one:
          '$count Skin: eine Ente mit eigenem Hintergrund. Für immer deins, auf all deinen Geräten.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Der Store ist gerade nicht erreichbar. Versuch es später noch mal.';

  @override
  String get skinsRestore => 'Käufe wiederherstellen';

  @override
  String get skinsRestoreDone => 'Käufe wiederhergestellt.';

  @override
  String get skinsThanks => 'Danke! Das Paket gehört dir.';

  @override
  String get skinsAllTitle => 'Alle Pakete';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins Skins aus allen $packs Paketen auf einmal, für etwa den halben Preis. Für immer deins, auf all deinen Geräten.';
  }
}
