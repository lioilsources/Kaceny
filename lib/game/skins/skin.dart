import 'skin_catalog.dart';

/// A look for the round: a duck sprite and a background picture in one
/// style. The built-in [vector] skin keeps the hand-drawn ducks and scenery.
class Skin {
  const Skin({
    required this.id,
    required this.name,
    required this.packId,
    required this.packTitle,
    required this.free,
    this.frames = 1,
  });

  final String id;
  final String name;
  final String packId;
  final String packTitle;

  /// Part of the free pack; the rest will be sold in packs (test build:
  /// everything is unlocked).
  final bool free;

  /// Wing-beat frames (`<id>_0.png` …), one full beat in order; 1 = a single
  /// picture that the game squashes to fake the beat.
  final int frames;

  bool get animated => frames > 1;

  static const vector = Skin(id: 'vector', name: 'Původní', packId: 'base', packTitle: 'Původní', free: true);

  static const all = <Skin>[vector, ...generatedSkins];

  bool get isVector => id == vector.id;

  /// Asset paths, relative to `assets/` (Flame's image prefix in the game).
  String get duckAsset => 'skins/duck/$id.png';
  String get backgroundAsset => 'skins/bg/$id.jpg';

  /// The sprites the game flies: one beat of frames, or the single picture.
  List<String> get duckFrameAssets =>
      animated ? [for (var i = 0; i < frames; i++) 'skins/duck/${id}_$i.png'] : [duckAsset];

  static Skin byId(String id) => all.firstWhere((s) => s.id == id, orElse: () => vector);
}
