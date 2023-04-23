import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:phandelver/utils/vector_2_int.dart';

class VerticalHexMap extends SpriteComponent {
  late Vector2 hex0Center;
  late bool isHex1Up;
  late double r;
  late double R;

  VerticalHexMap({
    required super.sprite,
    required Vector2 hex0TopLeft,
    required Vector2 hex0BottomRight,
    required this.isHex1Up,
  }) {
    hex0Center = Vector2(
      (hex0BottomRight.x + hex0TopLeft.x) / 2,
      (hex0BottomRight.y + hex0TopLeft.y) / 2,
    );
    R = hex0TopLeft.distanceTo(hex0BottomRight) / 2;
    r = R * sqrt(3) / 2;
  }

  Vector2 getHexCenter(Vector2Int hex) {
    final result = Vector2(
      hex0Center.x + hex.x * 1.5 * R,
      hex0Center.y + hex.y * 2 * r,
    );
    if (hex.x.isOdd) result.y += isHex1Up ? -r : r;
    return result;
  }

  Vector2 getHexEdge(Vector2Int hex, Anchor anchor) {
    final center = getHexCenter(hex);
    return Vector2(
      center.x + (anchor.x - 0.5) * 2 * r,
      center.y + (anchor.y - 0.5) * 2 * r,
    );
  }

  Vector2Int getHex(Vector2 position) {
    final offset = Offset(hex0Center.x - R / 2, hex0Center.y - r);
    final left = position.x <= offset.dx
        ? 0
        : ((position.x - offset.dx) / (1.5 * R)).floor();
    final top = position.y <= offset.dy
        ? 0
        : ((position.y - offset.dy) / (2 * r)).floor();
    final closeHexes = [
      Vector2Int(left, top),
      Vector2Int(left, top - 1),
      Vector2Int(left + 1, top),
      Vector2Int(left + 1, top - 1),
    ];
    closeHexes.sort((hex1, hex2) {
      final hex1Dist = getHexCenter(hex1).distanceTo(position);
      final hex2Dist = getHexCenter(hex2).distanceTo(position);
      return hex1Dist.compareTo(hex2Dist);
    });
    return closeHexes.first;
  }

  double get getTokenSize => r * 1.8;
}
