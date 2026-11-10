import 'dart:async';

import 'package:flutter/material.dart';

import '../app_services.dart';
import '../game/render/duck_painter.dart';
import '../game/render/palette.dart';
import '../game/skins/skin.dart';
import '../l10n/l10n.dart';
import '../services/skin_store.dart';
import 'theme.dart';

/// Skin picker: a preview per skin (its background with the duck on it),
/// grouped by pack. Paid packs show locked until bought; tapping a locked
/// skin offers its pack.
class SkinsScreen extends StatefulWidget {
  const SkinsScreen({super.key, required this.services, this.scrollToPack});

  final AppServices services;

  /// Pack to scroll to on open (the in-app purchase review screenshot).
  final String? scrollToPack;

  @override
  State<SkinsScreen> createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  late final StreamSubscription<(String, PurchaseOutcome)> _outcomes;

  /// Skin to select once its pack is bought (the one tapped to buy it).
  Skin? _wanted;

  final _packKey = GlobalKey();
  final _scroll = ScrollController();

  AppServices get services => widget.services;

  @override
  void initState() {
    super.initState();
    _outcomes = services.store.outcomes.listen(_onOutcome);
    if (widget.scrollToPack != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPack());
    }
  }

  /// The pack sits below the fold, so its header isn't built yet: step down
  /// until it is, then bring it to the top.
  Future<void> _scrollToPack() async {
    for (var i = 0; i < 40 && _scroll.hasClients && _packKey.currentContext == null; i++) {
      _scroll.jumpTo(_scroll.offset + 400);
      await WidgetsBinding.instance.endOfFrame;
    }
    final pack = _packKey.currentContext;
    if (pack != null && pack.mounted) {
      await Scrollable.ensureVisible(pack);
    }
  }

  @override
  void dispose() {
    _outcomes.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _onOutcome((String, PurchaseOutcome) outcome) {
    final (pack, result) = outcome;
    final l10n = context.l10n;
    final message = switch (result) {
      PurchaseOutcome.bought => l10n.skinsThanks,
      PurchaseOutcome.restored => l10n.skinsRestoreDone,
      PurchaseOutcome.failed => l10n.skinsStoreUnavailable,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    final wanted = _wanted;
    if (result == PurchaseOutcome.bought && wanted != null && (wanted.packId == pack || pack == SkinStore.allPacks)) {
      services.settings.skin = wanted.id;
      _wanted = null;
    }
  }

  Future<void> _buy(String packId, {Skin? skin}) async {
    services.sfx.ui();
    _wanted = skin;
    if (!await services.store.buy(packId) && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.skinsStoreUnavailable)));
    }
  }

  void _offer(Skin skin, List<Skin> pack) {
    services.sfx.ui();
    final locale = Localizations.localeOf(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skin.packNameIn(locale),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pack.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => SizedBox(width: 62, child: _Preview(skin: pack[i])),
                ),
              ),
              const SizedBox(height: 12),
              Text(context.l10n.skinsPackBody(pack.length), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              _BuyButton(
                store: services.store,
                packId: skin.packId,
                onPressed: () {
                  Navigator.of(context).pop();
                  _buy(skin.packId, skin: skin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final packs = <String, List<Skin>>{};
    for (final skin in Skin.all) {
      packs.putIfAbsent(skin.packId, () => []).add(skin);
    }
    final settings = services.settings;
    final store = services.store;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.skinsTitle(Skin.all.length)),
        actions: [
          if (store.supported)
            IconButton(
              tooltip: l10n.skinsRestore,
              icon: const Icon(Icons.restore),
              onPressed: () {
                services.sfx.ui();
                store.restore();
              },
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([settings, store]),
        builder: (context, _) => CustomScrollView(
          controller: _scroll,
          slivers: [
            if (store.supported && !store.ownsEverything)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                sliver: SliverToBoxAdapter(
                  child: _AllPacksCard(store: store, onBuy: () => _buy(SkinStore.allPacks)),
                ),
              ),
            for (final MapEntry(key: packId, value: skins) in packs.entries) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                sliver: SliverToBoxAdapter(
                  key: packId == widget.scrollToPack ? _packKey : null,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          skins.first.packNameIn(locale),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (skins.first.free)
                        _Tag(l10n.skinsFree, KColors.green)
                      else if (store.ownsPack(packId))
                        _Tag(l10n.skinsOwned, KColors.orange)
                      else ...[
                        const Spacer(),
                        _BuyButton(store: store, packId: packId, compact: true, onPressed: () => _buy(packId)),
                      ],
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
                    final unlocked = store.isUnlocked(skin);
                    return _SkinTile(
                      skin: skin,
                      name: skin.nameIn(locale),
                      selected: unlocked && settings.skin == skin.id,
                      locked: !unlocked,
                      onTap: () {
                        if (!unlocked) {
                          _offer(skin, skins);
                          return;
                        }
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

/// Every paid pack in one purchase, above the per-pack lists.
class _AllPacksCard extends StatelessWidget {
  const _AllPacksCard({required this.store, required this.onBuy});

  final SkinStore store;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final paid = Skin.all.where((s) => !s.free).length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.skinsAllTitle,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(l10n.skinsAllBody(paid, SkinStore.paidPacks.length)),
            const SizedBox(height: 12),
            _BuyButton(store: store, packId: SkinStore.allPacks, onPressed: onBuy),
          ],
        ),
      ),
    );
  }
}

/// "Unlock for $0.99", a spinner while the store sheet is up.
class _BuyButton extends StatelessWidget {
  const _BuyButton({required this.store, required this.packId, required this.onPressed, this.compact = false});

  final SkinStore store;
  final String packId;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final price = store.priceFor(packId);
    final pending = store.pendingPack == packId;
    final label = price == null ? context.l10n.skinsUnlockNoPrice : context.l10n.skinsUnlock(price);
    return FilledButton.icon(
      style: compact
          ? FilledButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            )
          : null,
      onPressed: pending || store.pendingPack != null ? null : onPressed,
      icon: pending
          ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.lock_open_rounded, size: 18),
      label: Text(label),
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
  const _SkinTile({
    required this.skin,
    required this.name,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final Skin skin;
  final String name;
  final bool selected;
  final bool locked;
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
                    _Preview(skin: skin),
                    if (locked) ...[
                      const ColoredBox(color: Color(0x66000000)),
                      const Center(child: Icon(Icons.lock_rounded, color: Colors.white, size: 30)),
                    ],
                    if (skin.animated)
                      PositionedDirectional(top: 6, start: 6, child: _Tag(context.l10n.skinsAnimated, KColors.green)),
                    if (selected)
                      const PositionedDirectional(
                        top: 6,
                        end: 6,
                        child: Icon(Icons.check_circle, color: KColors.orange, size: 26),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
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

/// A skin's background with its duck on it.
class _Preview extends StatelessWidget {
  const _Preview({required this.skin});

  final Skin skin;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
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
