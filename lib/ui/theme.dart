import 'package:flutter/material.dart';

abstract final class KColors {
  static const cream = Color(0xFFFFF6E3);
  static const ink = Color(0xFF2B2118);
  static const orange = Color(0xFFF28C28);
  static const orangeDark = Color(0xFFC4630F);
  static const green = Color(0xFF2F7D46);
  static const greenDark = Color(0xFF1F5A31);
  static const red = Color(0xFFE5402F);
  static const brass = Color(0xFFD9A441);
  static const shell = Color(0xFFC8372D);
  static const scrim = Color(0xB3000000);
  static const pill = Color(0x66000000);
}

ThemeData buildTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: KColors.orange, brightness: Brightness.light),
    useMaterial3: true,
  );
  return base.copyWith(
    scaffoldBackgroundColor: KColors.cream,
    textTheme: base.textTheme.apply(bodyColor: KColors.ink, displayColor: KColors.ink),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: KColors.orange,
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 56),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: KColors.ink,
        minimumSize: const Size(200, 52),
        side: const BorderSide(color: KColors.ink, width: 2),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}

/// White text with a dark halo, readable over sky and reeds.
const hudText = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
  shadows: [Shadow(color: Color(0x99000000), blurRadius: 4, offset: Offset(0, 1))],
);
