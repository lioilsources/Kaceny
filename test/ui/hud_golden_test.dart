import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaceny/config/game_config.dart';
import 'package:kaceny/game/hud_state.dart';
import 'package:kaceny/ui/hud.dart';
import 'package:kaceny/ui/theme.dart';

/// HUD layout in portrait on a small and a large phone, with their safe
/// areas (§8). The play area between the bands is tinted so the golden shows
/// where ducks may fly.
Future<void> pumpHud(
  WidgetTester tester, {
  required Size size,
  required EdgeInsets padding,
  required HudState state,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  tester.view.padding = FakeViewPadding(top: padding.top * 3, bottom: padding.bottom * 3);
  addTearDown(tester.view.reset);
  const config = GameConfig.defaults;
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: Builder(
        builder: (context) {
          final p = MediaQuery.paddingOf(context);
          // Material ancestor for the default text style, as in GameScreen.
          return Material(
            child: Stack(
              children: [
                const Positioned.fill(child: ColoredBox(color: Color(0xFF7EC8F0))),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: config.bottomSafeZonePt + p.bottom,
                  child: const ColoredBox(color: Color(0xFF3C6B3A)),
                ),
                Positioned.fill(
                  child: GameHud(state: state, topHeight: config.topHudPt, bottomHeight: config.bottomSafeZonePt),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  const iPhoneSE = (Size(375, 667), EdgeInsets.only(top: 20));
  const bigAndroid = (Size(412, 915), EdgeInsets.only(top: 32, bottom: 24));

  for (final (name, device) in [('iphone_se', iPhoneSE), ('big_android', bigAndroid)]) {
    testWidgets('HUD mid-round on $name', (tester) async {
      final state = HudState()
        ..timeLeft.value = 47
        ..score.value = 1234
        ..rounds.value = 5
        ..multiplier.value = 1.5;
      await pumpHud(tester, size: device.$1, padding: device.$2, state: state);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/hud_${name}_playing.png'));
    });

    testWidgets('HUD empty magazine in the countdown on $name', (tester) async {
      final state = HudState()
        ..countdown.value = true
        ..timeLeft.value = 7
        ..score.value = 88
        ..rounds.value = 0;
      await pumpHud(tester, size: device.$1, padding: device.$2, state: state);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/hud_${name}_empty.png'));
    });
  }

  testWidgets('ammo belt and top row stay inside the safe area', (tester) async {
    for (final device in [iPhoneSE, bigAndroid]) {
      await pumpHud(tester, size: device.$1, padding: device.$2, state: HudState());
      final shells = tester.getRect(find.byType(CustomPaint).last);
      final belt = device.$1.height - device.$2.bottom - GameConfig.defaults.bottomSafeZonePt;
      expect(shells.top, greaterThanOrEqualTo(belt), reason: 'shells below the play area on ${device.$1}');
      expect(shells.bottom, lessThanOrEqualTo(device.$1.height - device.$2.bottom));
      final score = tester.getRect(find.text('0'));
      expect(score.top, greaterThanOrEqualTo(device.$2.top));
      expect(score.right, lessThanOrEqualTo(device.$1.width));
      expect(tester.takeException(), isNull);
    }
  });
}
