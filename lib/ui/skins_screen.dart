import 'package:flutter/material.dart';

import '../app_services.dart';
import '../game/render/duck_painter.dart';
import '../game/render/palette.dart';
import '../game/skins/skin.dart';
import 'theme.dart';

/// Skin picker: a preview per skin (its background with the duck on it),
/// grouped by pack. Test build: every skin is unlocked.
class SkinsScreen extends StatelessWidget {
  const SkinsScreen({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final packs = <String, List<Skin>>{};
    for (final skin in Skin.all) {
      packs.putIfAbsent(skin.packTitle, () => []).add(skin);
    }
    final settings = services.settings;
    return Scaffold(
      appBar: AppBar(title: Text('Skiny (${Skin.all.length})')),
      body: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => CustomScrollView(
          slivers: [
            for (final MapEntry(key: title, value: skins) in packs.entries) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (skins.first.free)
                        const _Tag('zdarma', KColors.green)
                      else
                        const _Tag('balíček', KColors.orange),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.52,
                  ),
                  itemCount: skins.length,
                  itemBuilder: (context, i) {
                    final skin = skins[i];
                    return _SkinTile(
                      skin: skin,
                      selected: settings.skin == skin.id,
                      onTap: () {
                        services.sfx.ui();
                        settings.skin = skin.id;
                      },
                    );
                  },
                ),
              ),
            ],
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}

class _SkinTile extends StatelessWidget {
  const _SkinTile({required this.skin, required this.selected, required this.onTap});

  final Skin skin;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? KColors.orange : Colors.transparent, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (skin.isVector)
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Palette.skyTop, Palette.skyBottom],
                          ),
                        ),
                      )
                    else
                      Image.asset('assets/${skin.backgroundAsset}', fit: BoxFit.cover, cacheWidth: 260),
                    Align(
                      alignment: const Alignment(0, -0.2),
                      child: FractionallySizedBox(
                        widthFactor: 0.62,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: skin.isVector
                              ? CustomPaint(painter: _VectorDuck())
                              : Image.asset('assets/${skin.duckAsset}', cacheWidth: 160),
                        ),
                      ),
                    ),
                    if (skin.animated) const Positioned(top: 6, left: 6, child: _Tag('mává', KColors.green)),
                    if (selected)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(Icons.check_circle, color: KColors.orange, size: 26),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            skin.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _VectorDuck extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    DuckPainter(height: size.height * 0.9).paint(canvas, 1);
  }

  @override
  bool shouldRepaint(_VectorDuck old) => false;
}
