import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_services.dart';
import '../game/render/duck_painter.dart';
import '../game/render/palette.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'settings_screen.dart';
import 'skins_screen.dart';
import 'theme.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.services});

  final AppServices services;

  void _open(BuildContext context, Widget screen) {
    services.sfx.ui();
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Palette.skyTop, Palette.skyBottom],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _PeekingDuck()),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: ListenableBuilder(
                      listenable: services.online,
                      builder: (context, _) => services.online.offered
                          ? IconButton(
                              tooltip: services.online.available ? 'Online žebříček' : 'Přihlásit se',
                              iconSize: 30,
                              color: KColors.ink,
                              icon: Icon(services.online.available ? Icons.emoji_events : Icons.login),
                              onPressed: services.online.show,
                            )
                          : const SizedBox(height: 48),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    'Kačeny',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: KColors.ink,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '90 vteřin. 8 nábojů. Hodně kačen.',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: KColors.ink.withValues(alpha: 0.7)),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => _open(context, GameScreen(services: services)),
                    child: const Text('HRÁT'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () => _open(context, SkinsScreen(services: services)),
                    child: const Text('Skiny'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () => _open(context, LeaderboardScreen(services: services)),
                    child: const Text('Žebříček'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () => _open(context, SettingsScreen(services: services)),
                    child: const Text('Nastavení'),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The edge duck bobbing up from the bottom of the menu, and a few ducks
/// flying past in the sky.
class _PeekingDuck extends StatefulWidget {
  const _PeekingDuck();

  @override
  State<_PeekingDuck> createState() => _PeekingDuckState();
}

class _PeekingDuckState extends State<_PeekingDuck> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(painter: _MenuArtPainter(_c.value)),
    );
  }
}

class _MenuArtPainter extends CustomPainter {
  _MenuArtPainter(this.t);

  final double t;

  static final _edge = EdgeDuckPainter(height: 150);
  static final _ducks = [
    DuckPainter(height: 26, haze: 0.45),
    DuckPainter(height: 40, haze: 0.25),
    DuckPainter(height: 56, haze: 0.1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Ducks gliding down diagonally across the sky, looping.
    for (var i = 0; i < _ducks.length; i++) {
      final u = (t * (1 + i * 0.35) + i * 0.37) % 1;
      final x = size.width * (0.15 + 0.7 * ((i * 0.31 + u * 0.4) % 1));
      final y = -60 + (size.height * 0.75) * u;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-0.25);
      _ducks[i].paint(canvas, (t * 60 + i).floor() % DuckPainter.frames);
      canvas.restore();
    }
    // Peeking head at the bottom.
    final bob = (math.sin(t * 2 * math.pi) + 1) / 2;
    final ground = size.height;
    canvas.save();
    canvas.translate(size.width * 0.76, ground - 30 - 50 * bob);
    _edge.paint(canvas, facing: -1, blink: (t * 6) % 1 < 0.04 ? 1 : 0);
    canvas.restore();
    canvas.drawRect(Rect.fromLTWH(0, ground - 40, size.width, 40), Paint()..color = Palette.reedDark);
  }

  @override
  bool shouldRepaint(_MenuArtPainter old) => old.t != t;
}
