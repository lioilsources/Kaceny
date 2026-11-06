import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_sk.dart';

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
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('sk'),
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
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
    'sk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'sk':
      return AppLocalizationsSk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
