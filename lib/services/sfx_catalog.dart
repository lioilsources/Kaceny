/// Every sound file of the game, relative to `assets/audio/`.
///
/// Placeholders synthesised by `dart run tool/gen_sfx.dart`; replace the files
/// under the same names to swap in real sounds.
abstract final class SfxCatalog {
  static const shot = 'shot.wav';
  static const hit1 = 'hit_1.wav';
  static const hit2 = 'hit_2.wav';
  static const hitEdge = 'hit_edge.wav';
  static const miss = 'miss.wav';
  static const empty = 'empty.wav';
  static const reload = 'reload.wav';
  static const fall = 'fall.wav';
  static const countdown = 'countdown.wav';
  static const roundEnd = 'round_end.wav';
  static const ui = 'ui.wav';

  static const hits = [hit1, hit2];

  static const all = [shot, hit1, hit2, hitEdge, miss, empty, reload, fall, countdown, roundEnd, ui];
}
