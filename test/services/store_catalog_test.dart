import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaceny/game/skins/skin.dart';
import 'package:kaceny/l10n/app_localizations.dart';
import 'package:kaceny/l10n/locale_resolution.dart';
import 'package:kaceny/l10n/skin_names.dart';
import 'package:kaceny/services/skin_store.dart';

void main() {
  test('ten paid packs, one product each, the free pack sells nothing', () {
    expect(SkinStore.paidPacks, hasLength(10));
    expect(SkinStore.paidPacks, isNot(contains('free')));
    expect(SkinStore.productId('retro'), 'com.ol1n.kaceny.pack.retro');
    expect(Skin.all.where((s) => s.free), hasLength(13));
  });

  test('the bundle is its own product, not a pack of skins', () {
    expect(SkinStore.productId(SkinStore.allPacks), 'com.ol1n.kaceny.pack.all');
    expect(SkinStore.paidPacks, isNot(contains(SkinStore.allPacks)));
    expect(Skin.all.where((s) => s.packId == SkinStore.allPacks), isEmpty);
  });

  test('every skin and pack is named in every language the app speaks', () {
    for (final locale in AppLocalizations.supportedLocales.where((l) => l.languageCode != 'cs')) {
      final code = localeKey(locale);
      expect(skinNames[code]?.keys.toSet(), {for (final s in Skin.all) s.id}, reason: code);
      expect(packNames[code]?.keys.toSet(), {for (final s in Skin.all) s.packId}, reason: code);
    }
    expect(Skin.byId('rubber').nameIn(const Locale('cs')), 'Gumová kachnička');
    expect(Skin.byId('classic').packNameIn(const Locale('cs')), 'Základ');
    expect(Skin.byId('rubber').nameIn(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')),
        skinNames['zh_Hant']!['rubber']);
    expect(Skin.byId('rubber').nameIn(const Locale('pt', 'PT')), skinNames['pt_PT']!['rubber']);
    // Anything else falls back to English.
    expect(Skin.byId('rubber').nameIn(const Locale('sw')), skinNames['en']!['rubber']);
  });
}
