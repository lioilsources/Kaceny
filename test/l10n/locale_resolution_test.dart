import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaceny/l10n/app_localizations.dart';
import 'package:kaceny/l10n/locale_resolution.dart';

void main() {
  const supported = AppLocalizations.supportedLocales;
  Locale resolve(List<Locale> device) => resolveAppLocale(device, supported);

  test('a language the game speaks wins, anything else is English', () {
    expect(resolve([const Locale('de', 'AT')]), const Locale('de'));
    expect(resolve([const Locale('sw'), const Locale('cs', 'CZ')]), const Locale('cs'));
    expect(resolve([const Locale('sw')]), const Locale('en'));
    expect(resolve([]), const Locale('en'));
  });

  test('Chinese: Traditional for Hant or Taiwan / Hong Kong, else Simplified', () {
    const hant = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    expect(resolve([const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')]), hant);
    expect(resolve([const Locale('zh', 'HK')]), hant);
    expect(resolve([const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')]),
        const Locale('zh'));
    expect(resolve([const Locale('zh')]), const Locale('zh'));
  });

  test('Portuguese: Portugal gets European, everyone else Brazilian', () {
    expect(resolve([const Locale('pt', 'PT')]), const Locale('pt', 'PT'));
    expect(resolve([const Locale('pt', 'BR')]), const Locale('pt'));
    expect(resolve([const Locale('pt', 'AO')]), const Locale('pt'));
  });

  test('old codes map to the current ones', () {
    expect(resolve([const Locale('no', 'NO')]), const Locale('nb'));
    expect(resolve([const Locale('iw', 'IL')]), const Locale('he'));
    expect(resolve([const Locale('in', 'ID')]), const Locale('id'));
  });

  test('every language of the set is supported', () {
    final keys = {for (final l in supported) localeKey(l)};
    for (final code in 'cs en ar bn ca da de el es fi fr gu he hi hr hu id it ja kn ko ml mr ms nb nl or pa pt '
            'pt_PT pl ro ru sk sl sv ta te th tr uk ur vi zh zh_Hant'
        .split(' ')) {
      expect(keys, contains(code));
    }
  });
}
