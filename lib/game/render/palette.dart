import 'dart:ui';

/// Placeholder art colours. Everything is drawn with vectors until the real
/// sprites from the ComfyUI pipeline replace it (see assets/SPRITES.md).
abstract final class Palette {
  static const skyTop = Color(0xFF7EC8F0);
  static const skyBottom = Color(0xFFFCE6B8);
  static const sun = Color(0xFFFFF4C9);
  static const cloud = Color(0xFFFFFFFF);
  static const hillFar = Color(0xFFA9C7B4);
  static const hillMid = Color(0xFF7FAE84);
  static const hillNear = Color(0xFF5E9160);
  static const reedDark = Color(0xFF3C6B3A);
  static const reedLight = Color(0xFF6E9F45);
  static const cattail = Color(0xFF6B4A2B);
  static const water = Color(0xFF4F8DA6);

  static const duckHead = Color(0xFF2F7D46);
  static const duckNeckRing = Color(0xFFF7F3E8);
  static const duckBody = Color(0xFF9A7B62);
  static const duckBelly = Color(0xFFC9B39B);
  static const duckWing = Color(0xFF8F8F86);
  static const duckWingTip = Color(0xFF5D5D57);
  static const duckSpeculum = Color(0xFF3F51B5);
  static const duckTail = Color(0xFF3B3B38);
  static const beak = Color(0xFFF2B227);
  static const beakDark = Color(0xFFC98A12);
  static const eye = Color(0xFF151515);
  static const eyeWhite = Color(0xFFFFFFFF);

  static const hitRing = Color(0xFFFFFFFF);
  static const feather = Color(0xFFEDE3D3);
  static const popup = Color(0xFFFFF3B0);
  static const popupPrecise = Color(0xFFFFC94D);
  static const debugHit = Color(0xFFFF2D55);
  static const debugSprite = Color(0xFF34C759);
  static const debugLag = Color(0xFFFFCC00);
  static const debugShot = Color(0xFF00E5FF);
}
