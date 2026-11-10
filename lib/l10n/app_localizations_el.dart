// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get menuTagline => '90 δευτερόλεπτα. 8 φυσίγγια. Πολλές πάπιες.';

  @override
  String get menuPlay => 'ΠΑΙΞΕ';

  @override
  String get menuSkins => 'Εμφανίσεις';

  @override
  String get menuLeaderboard => 'Κατάταξη';

  @override
  String get menuSettings => 'Ρυθμίσεις';

  @override
  String get menuOnlineLeaderboard => 'Online κατάταξη';

  @override
  String get signIn => 'Σύνδεση';

  @override
  String get pause => 'Παύση';

  @override
  String get pauseResume => 'Συνέχεια';

  @override
  String get pauseRestart => 'Από την αρχή';

  @override
  String get backToMenu => 'Μενού';

  @override
  String get hudReloading => 'γέμισμα…';

  @override
  String get hudReloadHint => 'σύρε προς τα κάτω ή πάτα εδώ';

  @override
  String get settingsSound => 'Ήχος';

  @override
  String get settingsHaptics => 'Δόνηση';

  @override
  String get settingsAutoReload => 'Αυτόματο γέμισμα';

  @override
  String get settingsAutoReloadHint =>
      'Αλλιώς γεμίζεις σέρνοντας προς τα κάτω ή πατώντας τα φυσίγγια.';

  @override
  String get settingsDebug => 'Debug: ζώνες βολής και πυροβολισμοί';

  @override
  String get settingsDebugHint => 'Μόνο σε debug build.';

  @override
  String get settingsRestore => 'Επαναφορά αγορών';

  @override
  String get leaderboardThisPhone => 'Αυτό το τηλέφωνο';

  @override
  String get leaderboardOnline => 'Online';

  @override
  String get leaderboardEmpty =>
      'Δεν υπάρχουν ακόμα σκορ. Πήγαινε να ρίξεις μερικές πάπιες!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · ευστοχία $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'Τα σκορ όλων των παικτών στο Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo =>
      'Συνδέσου και σύγκρινε τον εαυτό σου με τους άλλους.';

  @override
  String get leaderboardOpen => 'Άνοιγμα';

  @override
  String get leaderboardSignIn => 'Σύνδεση';

  @override
  String get gameOverTitle => 'Τέλος γύρου';

  @override
  String get gameOverNewRecord => 'ΝΕΟ ΡΕΚΟΡ!';

  @override
  String get gameOverInitials => 'Μπήκες στην κατάταξη! Τα αρχικά σου:';

  @override
  String get gameOverReplay => 'Ξανά';

  @override
  String get statBest => 'καλύτερο';

  @override
  String get statAccuracy => 'ευστοχία';

  @override
  String get statStreak => 'σερί';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'Εμφανίσεις ($count)';
  }

  @override
  String get skinsFree => 'δωρεάν';

  @override
  String get skinsOwned => 'δική σου';

  @override
  String get skinsAnimated => 'φτερουγίζει';

  @override
  String skinsUnlock(String price) {
    return 'Ξεκλείδωμα με $price';
  }

  @override
  String get skinsUnlockNoPrice => 'Ξεκλείδωμα';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count εμφανίσεις, η καθεμία με μια πάπια και δικό της φόντο. Δικές σου για πάντα, σε όλες τις συσκευές σου.',
      one:
          '$count εμφάνιση: μια πάπια με δικό της φόντο. Δική σου για πάντα, σε όλες τις συσκευές σου.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'Το κατάστημα δεν είναι διαθέσιμο αυτή τη στιγμή. Δοκίμασε αργότερα.';

  @override
  String get skinsRestore => 'Επαναφορά αγορών';

  @override
  String get skinsRestoreDone => 'Οι αγορές επανήλθαν.';

  @override
  String get skinsThanks => 'Ευχαριστούμε! Το πακέτο είναι δικό σου.';

  @override
  String get skinsAllTitle => 'Όλα τα πακέτα';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins εμφανίσεις από όλα τα $packs πακέτα μαζί, περίπου στη μισή τιμή. Δικές σου για πάντα, σε όλες τις συσκευές σου.';
  }
}
