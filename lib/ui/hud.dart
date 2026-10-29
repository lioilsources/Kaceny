import 'package:flutter/material.dart';

import '../game/hud_state.dart';
import 'theme.dart';

/// In-round HUD (§5): time left and score on top, the ammo belt at the bottom.
///
/// Purely visual — wrapped in [IgnorePointer] by the game screen; all touches
/// go to the game, which treats the bottom strip as the reload button.
class GameHud extends StatelessWidget {
  const GameHud({super.key, required this.state, required this.topHeight, required this.bottomHeight});

  final HudState state;

  /// Height of the top row and of the ammo belt strip, both without insets.
  final double topHeight;
  final double bottomHeight;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return Column(
      children: [
        SizedBox(height: padding.top),
        SizedBox(
          height: topHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _Timer(state: state),
                    ),
                  ),
                ),
                // Room for the pause button the screen places on top.
                const SizedBox(width: 64),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _Score(state: state),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          height: bottomHeight,
          child: _AmmoBelt(state: state),
        ),
        SizedBox(height: padding.bottom),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.color = KColors.pill});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}

class _Timer extends StatelessWidget {
  const _Timer({required this.state});

  final HudState state;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: state.timeLeft,
      builder: (context, left, _) {
        final hurry = state.countdown.value;
        final text = '${left ~/ 60}:${(left % 60).toString().padLeft(2, '0')}';
        final pill = _Pill(
          color: hurry ? KColors.red.withValues(alpha: 0.85) : KColors.pill,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(text, style: hudText.copyWith(fontSize: 22, fontFeatures: const [FontFeature.tabularFigures()])),
            ],
          ),
        );
        if (!hurry) {
          return pill;
        }
        // A pulse per second in the countdown, restarted by the key.
        return TweenAnimationBuilder<double>(
          key: ValueKey(left),
          tween: Tween(begin: 1.25, end: 1),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
          child: pill,
        );
      },
    );
  }
}

class _Score extends StatelessWidget {
  const _Score({required this.state});

  final HudState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<double>(
          valueListenable: state.multiplier,
          builder: (context, m, _) => AnimatedOpacity(
            opacity: m > 1 ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _Pill(
                color: KColors.orange.withValues(alpha: 0.9),
                child: Text(
                  '×${m == m.roundToDouble() ? m.toStringAsFixed(0) : m.toStringAsFixed(1)}',
                  style: hudText.copyWith(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        _Pill(
          child: ValueListenableBuilder<int>(
            valueListenable: state.score,
            builder: (context, score, _) => Text(
              '$score',
              style: hudText.copyWith(fontSize: 22, fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ),
        ),
      ],
    );
  }
}

class _AmmoBelt extends StatelessWidget {
  const _AmmoBelt({required this.state});

  final HudState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([state.rounds, state.reloading, state.reloadProgress]),
      builder: (context, _) {
        final rounds = state.rounds.value;
        final reloading = state.reloading.value;
        final progress = state.reloadProgress.value;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < state.magazineSize; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: CustomPaint(
                      size: const Size(16, 34),
                      painter: ShellPainter(
                        // While reloading, shells refill left to right.
                        loaded: reloading ? i < (progress * state.magazineSize).floor() : i < rounds,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            _ReloadHint(visible: rounds == 0 && !reloading, reloading: reloading),
          ],
        );
      },
    );
  }
}

class _ReloadHint extends StatelessWidget {
  const _ReloadHint({required this.visible, required this.reloading});

  final bool visible;
  final bool reloading;

  @override
  Widget build(BuildContext context) {
    final text = reloading ? 'nabíjím…' : 'přejeď dolů nebo ťukni sem';
    return AnimatedOpacity(
      opacity: visible || reloading ? 1 : 0,
      duration: const Duration(milliseconds: 120),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!reloading) const Icon(Icons.swipe_down_alt, size: 15, color: KColors.cream),
          if (!reloading) const SizedBox(width: 4),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: hudText.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: visible ? KColors.cream : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// A shotgun shell: red body, brass base; spent = faint outline.
class ShellPainter extends CustomPainter {
  ShellPainter({required this.loaded});

  final bool loaded;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, w, h * 0.72),
      topLeft: Radius.circular(w * 0.3),
      topRight: Radius.circular(w * 0.3),
    );
    final base = Rect.fromLTWH(-w * 0.06, h * 0.72, w * 1.12, h * 0.28);
    if (!loaded) {
      final outline = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.45);
      canvas.drawRRect(body, outline);
      canvas.drawRect(base, outline);
      return;
    }
    canvas.drawRRect(body.shift(const Offset(0, 1.5)), Paint()..color = Colors.black26);
    canvas.drawRRect(body, Paint()..color = KColors.shell);
    canvas.drawRect(Rect.fromLTWH(w * 0.18, h * 0.06, w * 0.16, h * 0.58), Paint()..color = Colors.white24);
    canvas.drawRect(base, Paint()..color = KColors.brass);
    canvas.drawRect(Rect.fromLTWH(-w * 0.06, h * 0.72, w * 1.12, h * 0.05), Paint()..color = Colors.black26);
  }

  @override
  bool shouldRepaint(ShellPainter old) => old.loaded != loaded;
}
