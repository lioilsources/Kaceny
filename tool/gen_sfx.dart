// Generates the placeholder SFX as 16-bit mono WAV files (synthesised, CC0).
//
//   dart run tool/gen_sfx.dart
//
// File names come from lib/services/sfx_catalog.dart; replace the files under
// the same names to swap in real sounds.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const sampleRate = 44100;
final rng = math.Random(11);

void main() {
  final out = Directory('assets/audio')..createSync(recursive: true);
  write(out, 'shot.wav', shot());
  write(out, 'hit_1.wav', quack(1.0));
  write(out, 'hit_2.wav', quack(1.22));
  write(out, 'hit_edge.wav', bigQuack());
  write(out, 'miss.wav', miss());
  write(out, 'empty.wav', emptyClick());
  write(out, 'reload.wav', reload());
  write(out, 'fall.wav', fall());
  write(out, 'countdown.wav', beep(880, 0.12));
  write(out, 'round_end.wav', roundEnd());
  write(out, 'ui.wav', uiClick());
  stdout.writeln('SFX written to ${out.path}');
}

Float64List buf(double seconds) => Float64List((seconds * sampleRate).round());

double noise() => rng.nextDouble() * 2 - 1;

/// Shotgun-ish: noise crack + low thump, quick decay.
Float64List shot() {
  final b = buf(0.35);
  var ph = 0.0;
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    final crack = noise() * math.exp(-t * 38);
    final f = 140 * math.exp(-t * 9) + 45;
    ph += 2 * math.pi * f / sampleRate;
    final thump = math.sin(ph) * math.exp(-t * 14) * 0.9;
    final tail = noise() * math.exp(-t * 9) * 0.18;
    b[i] = crack * 0.8 + thump + tail;
  }
  return softclip(lowpass(b, 5200), 1.6);
}

/// A cartoon quack: a nasal sawtooth with a falling pitch and a formant-ish
/// band-pass wobble, two short syllables.
Float64List quack(double pitch) {
  final b = buf(0.32);
  var ph = 0.0;
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    final syllable = t < 0.14 ? t : t - 0.16;
    if (syllable < 0) {
      continue;
    }
    final env = math.min(1.0, syllable * 120) * math.exp(-syllable * 14) * (t < 0.14 ? 1 : 0.75);
    final f = pitch * (420 - 160 * syllable / 0.14);
    ph += f / sampleRate;
    final saw = 2 * (ph - ph.floorToDouble()) - 1;
    final nasal = math.sin(2 * math.pi * 1250 * pitch * t) * 0.35;
    b[i] = (saw * 0.7 + saw * nasal) * env;
  }
  return softclip(bandpass(b, 500 * pitch, 2600 * pitch), 1.4);
}

Float64List bigQuack() {
  final a = quack(0.62);
  final out = buf(0.5);
  for (var i = 0; i < a.length; i++) {
    out[i] += a[i];
  }
  // A boing underneath.
  var ph = 0.0;
  for (var i = 0; i < out.length; i++) {
    final t = i / sampleRate;
    final f = 180 + 120 * math.sin(t * 40) * math.exp(-t * 4);
    ph += 2 * math.pi * f / sampleRate;
    out[i] += math.sin(ph) * math.exp(-t * 6) * 0.4;
  }
  return out;
}

/// Soft whistle-past for a shot that hit nothing.
Float64List miss() {
  final b = buf(0.22);
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    b[i] = noise() * math.sin(math.pi * t / 0.22) * 0.5;
  }
  return bandpass(b, 1800, 4200);
}

/// Dry firing pin click.
Float64List emptyClick() {
  final b = buf(0.08);
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    b[i] = (noise() * 0.6 + math.sin(2 * math.pi * 2400 * t) * 0.5) * math.exp(-t * 90);
  }
  return highpass(b, 900);
}

/// Shells sliding in, then the action closing: clack-clack.
Float64List reload() {
  final b = buf(0.4);
  void clack(double at, double freq, double gain) {
    final start = (at * sampleRate).round();
    for (var i = start; i < b.length; i++) {
      final t = (i - start) / sampleRate;
      b[i] += (noise() * 0.7 + math.sin(2 * math.pi * freq * t) * 0.6) * math.exp(-t * 60) * gain;
    }
  }

  for (var i = 0; i < (0.18 * sampleRate).round(); i++) {
    final t = i / sampleRate;
    b[i] += noise() * 0.12 * math.sin(math.pi * t / 0.18);
  }
  clack(0.02, 1400, 0.6);
  clack(0.24, 900, 1.0);
  clack(0.30, 1300, 0.8);
  return bandpass(b, 300, 6000);
}

/// Descending cartoon whistle.
Float64List fall() {
  final b = buf(0.55);
  var ph = 0.0;
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    final f = 1500 - 1100 * t / 0.55 + 30 * math.sin(t * 50);
    ph += 2 * math.pi * f / sampleRate;
    b[i] = math.sin(ph) * math.min(1.0, t * 30) * (1 - t / 0.55) * 0.5;
  }
  return b;
}

Float64List beep(double freq, double seconds) {
  final b = buf(seconds);
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    final env = math.min(1.0, t * 400) * math.min(1.0, (seconds - t) * 60);
    b[i] = (math.sin(2 * math.pi * freq * t) + 0.25 * math.sin(4 * math.pi * freq * t)) * env;
  }
  return b;
}

/// Three falling notes and a long low one.
Float64List roundEnd() {
  final notes = [(784.0, 0.0, 0.16), (659.0, 0.17, 0.16), (523.0, 0.34, 0.16), (392.0, 0.52, 0.7)];
  final b = buf(1.3);
  for (final (f, at, len) in notes) {
    final start = (at * sampleRate).round();
    final n = (len * sampleRate).round();
    for (var i = 0; i < n && start + i < b.length; i++) {
      final t = i / sampleRate;
      final env = math.min(1.0, t * 200) * math.exp(-t * (len > 0.5 ? 3 : 8));
      final ph = 2 * math.pi * f * t;
      b[start + i] += (math.sin(ph) * 0.7 + math.sin(ph * 2) * 0.2 + math.sin(ph * 3) * 0.1) * env;
    }
  }
  return b;
}

Float64List uiClick() {
  final b = buf(0.05);
  for (var i = 0; i < b.length; i++) {
    final t = i / sampleRate;
    b[i] = math.sin(2 * math.pi * 1100 * t) * math.exp(-t * 120);
  }
  return b;
}

// ---- Filters ---------------------------------------------------------------

Float64List lowpass(Float64List input, double cutoff) {
  final out = Float64List(input.length);
  final a = 1 - math.exp(-2 * math.pi * cutoff / sampleRate);
  var y = 0.0;
  for (var i = 0; i < input.length; i++) {
    y += a * (input[i] - y);
    out[i] = y;
  }
  return out;
}

Float64List highpass(Float64List input, double cutoff) {
  final low = lowpass(input, cutoff);
  return Float64List.fromList([for (var i = 0; i < input.length; i++) input[i] - low[i]]);
}

Float64List bandpass(Float64List input, double low, double high) => lowpass(highpass(input, low), high);

Float64List softclip(Float64List input, double drive) {
  final norm = _tanh(drive);
  return Float64List.fromList([for (final s in input) _tanh(s * drive) / norm]);
}

double _tanh(double x) {
  final e = math.exp(2 * x);
  return (e - 1) / (e + 1);
}

void write(Directory dir, String name, Float64List samples) {
  final n = samples.length;
  final fade = (0.002 * sampleRate).round();
  final data = ByteData(44 + n * 2);
  void str(int o, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(o + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  data.setUint32(4, 36 + n * 2, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  str(36, 'data');
  data.setUint32(40, n * 2, Endian.little);
  var peak = 0.0;
  for (final s in samples) {
    peak = math.max(peak, s.abs());
  }
  final norm = peak > 0 ? 0.9 / peak : 1.0;
  for (var i = 0; i < n; i++) {
    var v = samples[i] * norm;
    if (i < fade) {
      v *= i / fade;
    }
    if (i > n - fade) {
      v *= (n - i) / fade;
    }
    data.setInt16(44 + i * 2, (v.clamp(-1.0, 1.0) * 32767).round(), Endian.little);
  }
  File('${dir.path}/$name').writeAsBytesSync(data.buffer.asUint8List());
}
