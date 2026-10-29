import 'package:vector_math/vector_math.dart';

/// Ring buffer of the last few (time, position) samples of a moving target.
///
/// Lets a shot be tested against where the target was a moment ago, when the
/// player actually saw it (touch latency compensation, §3.3).
class PositionHistory {
  PositionHistory(this.capacity)
    : assert(capacity >= 2),
      _t = List<double>.filled(capacity, 0),
      _x = List<double>.filled(capacity, 0),
      _y = List<double>.filled(capacity, 0);

  final int capacity;
  final List<double> _t;
  final List<double> _x;
  final List<double> _y;

  /// Index of the newest sample.
  int _head = -1;
  int _length = 0;

  int get length => _length;
  bool get isEmpty => _length == 0;

  /// Appends a sample. Times must not decrease; a sample at the same time as
  /// the newest one replaces it.
  void record(double time, double x, double y) {
    if (_length > 0 && time <= _t[_head]) {
      _x[_head] = x;
      _y[_head] = y;
      return;
    }
    _head = (_head + 1) % capacity;
    _t[_head] = time;
    _x[_head] = x;
    _y[_head] = y;
    if (_length < capacity) {
      _length++;
    }
  }

  void clear() {
    _head = -1;
    _length = 0;
  }

  /// i = 0 is the oldest sample.
  int _index(int i) => (_head - _length + 1 + i + capacity) % capacity;

  /// Position at [time], linearly interpolated between the two samples around
  /// it. Earlier than the oldest sample gives the oldest, later than the
  /// newest gives the newest — no extrapolation.
  Vector2 sample(double time, [Vector2? out]) {
    final result = out ?? Vector2.zero();
    if (_length == 0) {
      throw StateError('PositionHistory.sample on an empty history');
    }
    final oldest = _index(0);
    if (time <= _t[oldest]) {
      return result..setValues(_x[oldest], _y[oldest]);
    }
    if (time >= _t[_head]) {
      return result..setValues(_x[_head], _y[_head]);
    }
    for (var i = _length - 1; i > 0; i--) {
      final a = _index(i - 1);
      final b = _index(i);
      if (time >= _t[a]) {
        final span = _t[b] - _t[a];
        final f = span <= 0 ? 1.0 : (time - _t[a]) / span;
        return result..setValues(_x[a] + (_x[b] - _x[a]) * f, _y[a] + (_y[b] - _y[a]) * f);
      }
    }
    return result..setValues(_x[oldest], _y[oldest]);
  }
}
