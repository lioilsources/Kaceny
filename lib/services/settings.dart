import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Player settings, persisted in shared_preferences.
class Settings extends ChangeNotifier {
  Settings._(this._prefs)
    : _sound = _prefs.getBool(_kSound) ?? true,
      _haptics = _prefs.getBool(_kHaptics) ?? true,
      _autoReload = _prefs.getBool(_kAutoReload) ?? false,
      _debugOverlay = kDebugMode && (_prefs.getBool(_kDebug) ?? false),
      _initials = _prefs.getString(_kInitials) ?? '';

  static Future<Settings> load() async => Settings._(await SharedPreferences.getInstance());

  static const _kSound = 'settings.sound';
  static const _kHaptics = 'settings.haptics';
  static const _kAutoReload = 'settings.autoReload';
  static const _kDebug = 'settings.debugOverlay';
  static const _kInitials = 'settings.initials';

  final SharedPreferences _prefs;

  bool _sound;
  bool _haptics;
  bool _autoReload;
  bool _debugOverlay;
  String _initials;

  bool get sound => _sound;
  bool get haptics => _haptics;

  /// Reload by itself when the magazine runs dry. Off by default: the manual
  /// reload is part of the rhythm.
  bool get autoReload => _autoReload;

  /// Hitboxes and shot markers; only ever on in debug builds.
  bool get debugOverlay => _debugOverlay;

  /// Last initials typed for the leaderboard, to prefill the next time.
  String get initials => _initials;

  set sound(bool v) => _set(_kSound, v, () => _sound = v);
  set haptics(bool v) => _set(_kHaptics, v, () => _haptics = v);
  set autoReload(bool v) => _set(_kAutoReload, v, () => _autoReload = v);
  set debugOverlay(bool v) => _set(_kDebug, v && kDebugMode, () => _debugOverlay = v && kDebugMode);

  set initials(String v) {
    _initials = v;
    _prefs.setString(_kInitials, v);
    notifyListeners();
  }

  void _set(String key, bool value, void Function() apply) {
    apply();
    _prefs.setBool(key, value);
    notifyListeners();
  }
}
