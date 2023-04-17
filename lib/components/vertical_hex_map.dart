import 'dart:math';

import 'package:flame/components.dart';

class VerticalHexMap extends SpriteComponent {
  late Vector2 hex0Center;
  bool isNextDown;
  bool isTopFlat;
  late double r;
  late double R;

  VerticalHexMap({
    required super.sprite,
    required Vector2 hex0TopLeft,
    required Vector2 hex0bottomRight,
    required this.isNextDown,
    required this.isTopFlat,
  }) {
    hex0Center = Vector2(
      (hex0bottomRight.x + hex0TopLeft.x) / 2,
      (hex0bottomRight.y + hex0TopLeft.y) / 2,
    );
    R = hex0TopLeft.distanceTo(hex0bottomRight) / 2;
    r = R * sqrt(3) / 2;
  }

  Vector2 getHexCenter(int hexX, int hexY) {
    final result = Vector2(
        hex0Center.x + hexX * 1.5 * R,
        hex0Center.y + hexY * 2 * r
    );
    if (hexX.isOdd) result.y += isNextDown ? r : -r;
    return result;
  }

  @override
  String toString() {
    return 'HexMap{hex0Center: $hex0Center, isNextDown: $isNextDown, isTopFlat: $isTopFlat, r: $r, R: $R}';
  }
}
