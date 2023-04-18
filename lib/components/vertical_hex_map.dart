import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:phandelver/model/place.dart';

class VerticalHexMap extends SpriteComponent {
  late Vector2 hex0Center;
  late bool isHex1Up;
  late double r;
  late double R;

  List<Place> places = [];

  static Future<VerticalHexMap> load({
    required String imageFile,
    required String jsonFile,
  }) async {
    final sprite = await Sprite.load(imageFile);
    final json =
        jsonDecode(await rootBundle.loadString("assets/text/$jsonFile"));
    final hex0TopLeft = Vector2(
      json["hex0"]["topLeftX"].toDouble(),
      json["hex0"]["topLeftY"].toDouble(),
    );
    final hex0BottomRight = Vector2(
      json["hex0"]["bottomRightX"].toDouble(),
      json["hex0"]["bottomRightY"].toDouble(),
    );
    final isHex1Up = json["isHex1Up"];
    final places =
        json["places"].map((e) => Place.fromMap(e)).toList().cast<Place>();
    return VerticalHexMap(
      sprite: sprite,
      hex0TopLeft: hex0TopLeft,
      hex0BottomRight: hex0BottomRight,
      isHex1Up: isHex1Up,
    )..places = places;
  }

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

  Vector2 getHexCenter(int hexX, int hexY) {
    final result = Vector2(
      hex0Center.x + hexX * 1.5 * R,
      hex0Center.y + hexY * 2 * r,
    );
    if (hexX.isOdd) result.y += isHex1Up ? r : -r;
    return result;
  }

  Vector2 getHexEdge(int hexX, int hexY, Anchor anchor) {
    final center = getHexCenter(hexX, hexY);
    return Vector2(
      center.x + (anchor.x - 0.5) * 2 * r,
      center.y + (anchor.y - 0.5) * 2 * r,
    );
  }

  @override
  String toString() {
    return 'VerticalHexMap{hex0Center: $hex0Center, isHex1Up: $isHex1Up, r: $r, R: $R, places: $places}';
  }
}
