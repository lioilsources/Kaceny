import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Subtitle under the game title in the main menu.
  ///
  /// In en, this message translates to:
  /// **'90 seconds. 8 shells. Lots of ducks.'**
  String get menuTagline;

  /// No description provided for @menuPlay.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get menuPlay;

  /// No description provided for @menuSkins.
  ///
  /// In en, this message translates to:
  /// **'Skins'**
  String get menuSkins;

  /// No description provided for @menuLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get menuLeaderboard;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// Tooltip of the trophy icon in the menu (Game Center / Play Games).
  ///
  /// In en, this message translates to:
  /// **'Online leaderboard'**
  String get menuOnlineLeaderboard;

  /// Tooltip: sign in to Game Center / Play Games.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @pauseResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get pauseResume;

  /// No description provided for @pauseRestart.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get pauseRestart;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get backToMenu;

  /// No description provided for @hudReloading.
  ///
  /// In en, this message translates to:
  /// **'reloading…'**
  String get hudReloading;

  /// Shown over the empty ammo bar at the bottom: how to reload. Lowercase, short.
  ///
  /// In en, this message translates to:
  /// **'swipe down or tap here'**
  String get hudReloadHint;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSound;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsHaptics;

  /// No description provided for @settingsAutoReload.
  ///
  /// In en, this message translates to:
  /// **'Automatic reload'**
  String get settingsAutoReload;

  /// No description provided for @settingsAutoReloadHint.
  ///
  /// In en, this message translates to:
  /// **'Otherwise reload by swiping down or tapping the shells.'**
  String get settingsAutoReloadHint;

  /// No description provided for @settingsDebug.
  ///
  /// In en, this message translates to:
  /// **'Debug: hitboxes and shots'**
  String get settingsDebug;

  /// No description provided for @settingsDebugHint.
  ///
  /// In en, this message translates to:
  /// **'Debug build only.'**
  String get settingsDebugHint;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestore;

  /// No description provided for @leaderboardThisPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get leaderboardThisPhone;

  /// No description provided for @leaderboardOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get leaderboardOnline;

  /// No description provided for @leaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scores yet. Go shoot some ducks!'**
  String get leaderboardEmpty;

  /// Subtitle of a local leaderboard row. accuracy is already formatted, e.g. 87 %.
  ///
  /// In en, this message translates to:
  /// **'{date} · accuracy {accuracy}'**
  String leaderboardEntry(String date, String accuracy);

  /// No description provided for @leaderboardOnlineInfo.
  ///
  /// In en, this message translates to:
  /// **'Scores of all players in Game Center / Play Games.'**
  String get leaderboardOnlineInfo;

  /// No description provided for @leaderboardSignInInfo.
  ///
  /// In en, this message translates to:
  /// **'Sign in and compare yourself with others.'**
  String get leaderboardSignInInfo;

  /// No description provided for @leaderboardOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get leaderboardOpen;

  /// No description provided for @leaderboardSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get leaderboardSignIn;

  /// No description provided for @gameOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Round over'**
  String get gameOverTitle;

  /// No description provided for @gameOverNewRecord.
  ///
  /// In en, this message translates to:
  /// **'NEW RECORD!'**
  String get gameOverNewRecord;

  /// No description provided for @gameOverInitials.
  ///
  /// In en, this message translates to:
  /// **'You made the leaderboard! Your initials:'**
  String get gameOverInitials;

  /// No description provided for @gameOverReplay.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get gameOverReplay;

  /// No description provided for @statBest.
  ///
  /// In en, this message translates to:
  /// **'best'**
  String get statBest;

  /// No description provided for @statAccuracy.
  ///
  /// In en, this message translates to:
  /// **'accuracy'**
  String get statAccuracy;

  /// Longest run of hits in a row. Lowercase label under a number.
  ///
  /// In en, this message translates to:
  /// **'streak'**
  String get statStreak;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// No description provided for @skinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skins ({count})'**
  String skinsTitle(int count);

  /// No description provided for @skinsFree.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get skinsFree;

  /// Tag on a pack the player has bought. Lowercase, one short word.
  ///
  /// In en, this message translates to:
  /// **'yours'**
  String get skinsOwned;

  /// Tag on a skin whose duck has animated wings. Lowercase, one short word.
  ///
  /// In en, this message translates to:
  /// **'flaps'**
  String get skinsAnimated;

  /// No description provided for @skinsUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock for {price}'**
  String skinsUnlock(String price);

  /// No description provided for @skinsUnlockNoPrice.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get skinsUnlockNoPrice;

  /// No description provided for @skinsPackBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} skin, a duck and its own background. Yours forever, on all your devices.} other{{count} skins, each a duck and its own background. Yours forever, on all your devices.}}'**
  String skinsPackBody(int count);

  /// No description provided for @skinsStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The store isn\'t available right now. Try again later.'**
  String get skinsStoreUnavailable;

  /// No description provided for @skinsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get skinsRestore;

  /// No description provided for @skinsRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored.'**
  String get skinsRestoreDone;

  /// No description provided for @skinsThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks! The pack is yours.'**
  String get skinsThanks;

  /// Card above the packs that sells every paid pack in one purchase.
  ///
  /// In en, this message translates to:
  /// **'All packs'**
  String get skinsAllTitle;

  /// No description provided for @skinsAllBody.
  ///
  /// In en, this message translates to:
  /// **'{skins} skins from all {packs} packs at once, for about half the price. Yours forever, on all your devices.'**
  String skinsAllBody(int skins, int packs);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'ml',
    'mr',
    'ms',
    'nb',
    'nl',
    'or',
    'pa',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'ta',
    'te',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
