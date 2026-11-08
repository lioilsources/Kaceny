import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/skins/skin.dart';

/// What a purchase flow ended in, for the picker to tell the player.
enum PurchaseOutcome { bought, restored, failed }

/// The one place that talks to the platform store (StoreKit / Play Billing).
/// Skins are sold by pack, one non-consumable product per paid pack
/// (`com.ol1n.kaceny.pack.<packId>`); the free pack needs none. One more
/// product, [allPacks], unlocks every paid pack at once.
///
/// Bought pack ids are cached in shared_preferences so the picker works
/// offline; the store stays the source of truth through Restore Purchases.
class SkinStore extends ChangeNotifier {
  SkinStore();

  static const _kOwned = 'store.ownedPacks';

  /// Builds that unlock everything: the sideloaded APK on GitHub (Play
  /// Billing only works for installs from Play) and the store screenshots.
  static const testerUnlock = bool.fromEnvironment('TESTER_UNLOCK');

  static String productId(String packId) => 'com.ol1n.kaceny.pack.$packId';

  /// The bundle: owning it counts as owning every paid pack.
  static const allPacks = 'all';

  /// Paid packs in catalog order.
  static final List<String> paidPacks = <String>{
    for (final s in Skin.all)
      if (!s.free) s.packId,
  }.toList();

  final Set<String> _owned = {};
  Map<String, ProductDetails> _products = {};
  String? _pendingPack;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  final _outcomes = StreamController<(String, PurchaseOutcome)>.broadcast();

  /// Platforms where packs are actually sold.
  bool get supported =>
      !testerUnlock &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

  /// Whether the store answered with products; false offline or before init.
  bool get available => _products.isNotEmpty;

  /// Pack whose purchase sheet is up (spinner on its button).
  String? get pendingPack => _pendingPack;

  /// Finished purchases and restores, as (packId, outcome).
  Stream<(String, PurchaseOutcome)> get outcomes => _outcomes.stream;

  bool ownsPack(String packId) => !supported || _owned.contains(packId) || _owned.contains(allPacks);

  /// Nothing left to sell: the bundle or every pack on its own.
  bool get ownsEverything => ownsPack(allPacks) || paidPacks.every(ownsPack);

  bool isUnlocked(Skin skin) => skin.free || ownsPack(skin.packId);

  /// The store's localized price, or null until the store has answered.
  String? priceFor(String packId) => _products[productId(packId)]?.price;

  Future<void> init() async {
    if (!supported) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    _owned.addAll(prefs.getStringList(_kOwned) ?? const []);
    // Before any store call, so transactions iOS re-delivers at launch are
    // not missed.
    _sub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchases,
      onError: (Object error) {
        debugPrint('Kačeny: purchase stream failed: $error');
      },
    );
    try {
      if (await InAppPurchase.instance.isAvailable()) {
        final response = await InAppPurchase.instance.queryProductDetails({
          for (final p in [...paidPacks, allPacks]) productId(p),
        });
        _products = {for (final p in response.productDetails) p.id: p};
        if (response.notFoundIDs.isNotEmpty) {
          debugPrint('Kačeny: products not in the store: ${response.notFoundIDs}');
        }
      }
    } catch (error) {
      // No store or no network: locked packs show without a price.
      debugPrint('Kačeny: store unavailable: $error');
    }
    notifyListeners();
  }

  /// Opens the store's purchase sheet; false when it could not be shown.
  Future<bool> buy(String packId) async {
    final details = _products[productId(packId)];
    if (!supported || ownsPack(packId) || _pendingPack != null || details == null) {
      return false;
    }
    _pendingPack = packId;
    notifyListeners();
    try {
      if (await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: details))) {
        return true;
      }
    } catch (error) {
      debugPrint('Kačeny: purchase did not start: $error');
    }
    _pendingPack = null;
    notifyListeners();
    return false;
  }

  /// Re-delivers past purchases (new device, reinstall). App Review wants
  /// this reachable from the UI.
  Future<void> restore() async {
    if (!supported) {
      return;
    }
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (error) {
      debugPrint('Kačeny: restore failed: $error');
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    var changed = false;
    for (final purchase in purchases) {
      final pack = _packFor(purchase.productID);
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (pack != null) {
            changed |= _owned.add(pack);
            _outcomes.add((
              pack,
              purchase.status == PurchaseStatus.purchased ? PurchaseOutcome.bought : PurchaseOutcome.restored,
            ));
          }
        case PurchaseStatus.error:
          if (pack != null && pack == _pendingPack) {
            _outcomes.add((pack, PurchaseOutcome.failed));
          }
        case PurchaseStatus.canceled:
        case PurchaseStatus.pending:
          // Pending: the sheet is still up or waits for Ask to Buy; a final
          // status follows on the same stream.
          break;
      }
      if (pack != null && pack == _pendingPack && purchase.status != PurchaseStatus.pending) {
        _pendingPack = null;
      }
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
    if (changed) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kOwned, _owned.toList());
    }
    notifyListeners();
  }

  String? _packFor(String id) {
    for (final p in [...paidPacks, allPacks]) {
      if (productId(p) == id) {
        return p;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _outcomes.close();
    super.dispose();
  }
}
