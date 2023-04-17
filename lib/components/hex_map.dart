import 'dart:math';

import 'package:flame/components.dart';

class HexMap extends SpriteComponent {
  late Vector2 hex0Center;
  bool isNextDown;
  bool isTopFlat;
  late double r;
  late double R;

  HexMap({
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

  @override
  String toString() {
    return 'HexMap{hex0Center: $hex0Center, isNextDown: $isNextDown, isTopFlat: $isTopFlat, r: $r, R: $R}';
  }
}
