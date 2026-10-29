/// The 8-round magazine and its reload (§3.4).
class Magazine {
  Magazine({required this.size, required this.reloadS}) : rounds = size;

  final int size;
  final double reloadS;

  int rounds;

  /// Seconds left of a running reload; 0 when not reloading.
  double reloadLeft = 0;

  bool get reloading => reloadLeft > 0;
  bool get empty => rounds == 0;
  bool get full => rounds == size;

  /// 0 → 1 while reloading.
  double get reloadProgress => reloading ? 1 - reloadLeft / reloadS : 0;

  void reset() {
    rounds = size;
    reloadLeft = 0;
  }

  /// Takes one round. False (a dry click) when empty or mid-reload.
  bool fire() {
    if (reloading || rounds == 0) {
      return false;
    }
    rounds--;
    return true;
  }

  /// Starts a reload; false if one is running or the magazine is full.
  bool startReload() {
    if (reloading || full) {
      return false;
    }
    reloadLeft = reloadS;
    return true;
  }

  /// Advances the reload; true on the frame it finishes.
  bool update(double dt) {
    if (!reloading) {
      return false;
    }
    reloadLeft -= dt;
    if (reloadLeft <= 0) {
      reloadLeft = 0;
      rounds = size;
      return true;
    }
    return false;
  }
}
