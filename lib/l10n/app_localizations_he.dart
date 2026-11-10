// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get menuTagline => '90 שניות. 8 כדורים. המון ברווזים.';

  @override
  String get menuPlay => 'שחק';

  @override
  String get menuSkins => 'סקינים';

  @override
  String get menuLeaderboard => 'טבלת שיאים';

  @override
  String get menuSettings => 'הגדרות';

  @override
  String get menuOnlineLeaderboard => 'טבלת שיאים מקוונת';

  @override
  String get signIn => 'התחברות';

  @override
  String get pause => 'השהיה';

  @override
  String get pauseResume => 'המשך';

  @override
  String get pauseRestart => 'התחל מחדש';

  @override
  String get backToMenu => 'תפריט';

  @override
  String get hudReloading => 'טוען…';

  @override
  String get hudReloadHint => 'החלק למטה או הקש כאן';

  @override
  String get settingsSound => 'צליל';

  @override
  String get settingsHaptics => 'רטט';

  @override
  String get settingsAutoReload => 'טעינה אוטומטית';

  @override
  String get settingsAutoReloadHint =>
      'אחרת טוענים בהחלקה למטה או בהקשה על הכדורים.';

  @override
  String get settingsDebug => 'ניפוי באגים: אזורי פגיעה ויריות';

  @override
  String get settingsDebugHint => 'רק בגרסת ניפוי באגים.';

  @override
  String get settingsRestore => 'שחזור רכישות';

  @override
  String get leaderboardThisPhone => 'הטלפון הזה';

  @override
  String get leaderboardOnline => 'מקוון';

  @override
  String get leaderboardEmpty => 'עדיין אין תוצאות. לך לירות בכמה ברווזים!';

  @override
  String leaderboardEntry(String date, String accuracy) {
    return '$date · דיוק $accuracy';
  }

  @override
  String get leaderboardOnlineInfo =>
      'התוצאות של כל השחקנים ב-Game Center / Play Games.';

  @override
  String get leaderboardSignInInfo => 'התחבר והשווה את עצמך לאחרים.';

  @override
  String get leaderboardOpen => 'פתח';

  @override
  String get leaderboardSignIn => 'התחבר';

  @override
  String get gameOverTitle => 'הסיבוב נגמר';

  @override
  String get gameOverNewRecord => 'שיא חדש!';

  @override
  String get gameOverInitials => 'נכנסת לטבלת השיאים! ראשי התיבות שלך:';

  @override
  String get gameOverReplay => 'שוב';

  @override
  String get statBest => 'הכי טוב';

  @override
  String get statAccuracy => 'דיוק';

  @override
  String get statStreak => 'רצף';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String skinsTitle(int count) {
    return 'סקינים ($count)';
  }

  @override
  String get skinsFree => 'חינם';

  @override
  String get skinsOwned => 'שלך';

  @override
  String get skinsAnimated => 'מנפנף';

  @override
  String skinsUnlock(String price) {
    return 'פתח ב-$price';
  }

  @override
  String get skinsUnlockNoPrice => 'פתח';

  @override
  String skinsPackBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count סקינים, כל אחד ברווז עם רקע משלו. שלך לתמיד, בכל המכשירים שלך.',
      two: 'שני סקינים, כל אחד ברווז עם רקע משלו. שלך לתמיד, בכל המכשירים שלך.',
      one: 'סקין אחד: ברווז עם רקע משלו. שלך לתמיד, בכל המכשירים שלך.',
    );
    return '$_temp0';
  }

  @override
  String get skinsStoreUnavailable =>
      'החנות לא זמינה כרגע. נסה שוב מאוחר יותר.';

  @override
  String get skinsRestore => 'שחזור רכישות';

  @override
  String get skinsRestoreDone => 'הרכישות שוחזרו.';

  @override
  String get skinsThanks => 'תודה! החבילה שלך.';

  @override
  String get skinsAllTitle => 'כל החבילות';

  @override
  String skinsAllBody(int skins, int packs) {
    return '$skins סקינים מכל $packs החבילות בבת אחת, בערך בחצי מחיר. שלך לתמיד, בכל המכשירים שלך.';
  }
}
