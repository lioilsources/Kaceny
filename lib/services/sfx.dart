import 'dart:math' as math;

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import 'sfx_catalog.dart';

/// Plays the sound effects. Best-effort: if audio fails to load the game
/// simply stays silent.
class Sfx {
  Sfx({math.Random? random}) : _random = random ?? math.Random();

  final math.Random _random;
  bool enabled = true;

  bool _ready = false;
  final Map<String, AudioPool> _pools = {};

  /// Sounds that can overlap rapidly get a pool of low-latency players.
  static const _pooled = {
    SfxCatalog.shot: 4,
    SfxCatalog.hit1: 2,
    SfxCatalog.hit2: 2,
    SfxCatalog.miss: 2,
    SfxCatalog.empty: 2,
    SfxCatalog.fall: 3,
  };

  Future<void> load() async {
    if (_ready) {
      return;
    }
    try {
      await FlameAudio.audioCache.loadAll(SfxCatalog.all);
      for (final entry in _pooled.entries) {
        _pools[entry.key] = await FlameAudio.createPool(entry.key, maxPlayers: entry.value);
      }
      _ready = true;
    } catch (error) {
      debugPrint('Kačeny: audio unavailable: $error');
    }
  }

  void play(String file, {double volume = 1}) {
    if (!enabled || !_ready) {
      return;
    }
    final pool = _pools[file];
    if (pool != null) {
      pool.start(volume: volume).ignore();
      return;
    }
    FlameAudio.play(file, volume: volume).catchError((Object e) {
      debugPrint('Kačeny: play $file failed: $e');
      return Future<AudioPlayer>.error(e);
    }).ignore();
  }

  void shot() => play(SfxCatalog.shot, volume: 0.8);
  void hit() => play(SfxCatalog.hits[_random.nextInt(SfxCatalog.hits.length)]);
  void hitEdge() => play(SfxCatalog.hitEdge);
  void miss() => play(SfxCatalog.miss, volume: 0.5);
  void empty() => play(SfxCatalog.empty);
  void reload() => play(SfxCatalog.reload);
  void fall() => play(SfxCatalog.fall, volume: 0.6);
  void countdown() => play(SfxCatalog.countdown, volume: 0.7);
  void roundEnd() => play(SfxCatalog.roundEnd);
  void ui() => play(SfxCatalog.ui, volume: 0.6);
}
