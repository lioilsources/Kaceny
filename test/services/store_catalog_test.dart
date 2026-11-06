import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaceny/game/skins/skin.dart';
import 'package:kaceny/l10n/app_localizations.dart';
import 'package:kaceny/l10n/skin_names.dart';
import 'package:kaceny/services/skin_store.dart';

void main() {
  test('ten paid packs, one product each, the free pack sells nothing', () {
    expect(SkinStore.paidPacks, hasLength(10));
    expect(SkinStore.paidPacks, isNot(contains('free')));
    expect(SkinStore.productId('retro'), 'com.ol1n.kaceny.pack.retro');
    expect(Skin.all.where((s) => s.free), hasLength(13));
  });

  test('every skin and pack is named in every language the app speaks', () {
    for (final locale in AppLocalizations.supportedLocales.where((l) => l.languageCode != 'cs')) {
      final code = locale.languageCode;
      expect(skinNames[code]?.keys.toSet(), {for (final s in Skin.all) s.id}, reason: code);
      expect(packNames[code]?.keys.toSet(), {for (final s in Skin.all) s.packId}, reason: code);
    }
    expect(Skin.byId('rubber').nameIn(const Locale('cs')), 'Gumová kachnička');
    expect(Skin.byId('classic').packNameIn(const Locale('cs')), 'Základ');
    // Anything else falls back to English.
    expect(Skin.byId('rubber').nameIn(const Locale('ja')), skinNames['en']!['rubber']);
  });
}
