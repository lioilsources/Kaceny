import 'dart:ui' show Locale;

/// Picks the app language for the device's preferred [locales]: the first
/// one the game speaks, English for anything else (the default would be the
/// first supported locale, alphabetically Arabic).
///
/// Regional variants win when the device asks for them: Traditional Chinese
/// for zh-Hant (or Taiwan, Hong Kong, Macao), European Portuguese for pt-PT;
/// otherwise the bare language (Simplified Chinese, Brazilian Portuguese).
Locale resolveAppLocale(List<Locale>? locales, Iterable<Locale> supported) {
  for (final raw in locales ?? const <Locale>[]) {
    final locale = _canonical(raw);
    final variants = [for (final s in supported) if (s.languageCode == locale.languageCode) s];
    if (variants.isEmpty) {
      continue;
    }
    final script = locale.scriptCode ??
        (locale.languageCode == 'zh' && const {'TW', 'HK', 'MO'}.contains(locale.countryCode) ? 'Hant' : null);
    for (final s in variants) {
      if (s.scriptCode != null && s.scriptCode == script) {
        return s;
      }
    }
    for (final s in variants) {
      if (s.countryCode != null && s.countryCode == locale.countryCode) {
        return s;
      }
    }
    return variants.firstWhere((s) => s.scriptCode == null && s.countryCode == null, orElse: () => variants.first);
  }
  return const Locale('en');
}

/// Old and macro-language codes some devices still report.
Locale _canonical(Locale locale) {
  const aliases = {'no': 'nb', 'nn': 'nb', 'iw': 'he', 'in': 'id'};
  final language = aliases[locale.languageCode];
  if (language == null) {
    return locale;
  }
  return Locale.fromSubtags(languageCode: language, scriptCode: locale.scriptCode, countryCode: locale.countryCode);
}

/// The key of a resolved app locale in the per-language name tables
/// (skin_names.dart) and store/listing.json: `zh_Hant`, `pt_PT`, else the
/// language code.
String localeKey(Locale locale) {
  if (locale.scriptCode != null && locale.languageCode == 'zh') {
    return locale.scriptCode == 'Hant' ? 'zh_Hant' : 'zh';
  }
  if (locale.languageCode == 'pt' && locale.countryCode == 'PT') {
    return 'pt_PT';
  }
  return locale.languageCode;
}
