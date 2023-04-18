import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:phandelver/model/place.dart';
import 'package:phandelver/utils.dart';

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
    final map = VerticalHexMap(
      sprite: sprite,
      hex0TopLeft: hex0TopLeft,
      hex0BottomRight: hex0BottomRight,
      isHex1Up: isHex1Up,
    );
    final places = (json["places"] as List).map((e) {
      final anchor = e["titleAnchor"];
      final tags = e["tags"] as List;
      final hex = map.getHex(e["x"], e["y"]);
      return Place(
        name: e["name"],
        x: e["x"],
        y: e["y"],
        titleAnchor: anchor != null ? Anchor.valueOf(anchor) : Anchor.center,
        tags: tags.cast<String>(),
        hexX: hex.x.floor(),
        hexY: hex.y.floor(),
      );
    }).toList();
    map.places = places;
    return map;
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
    if (hexX.isOdd) result.y += isHex1Up ? -r : r;
    return result;
  }

  Vector2 getHexEdge(int hexX, int hexY, Anchor anchor) {
    final center = getHexCenter(hexX, hexY);
    return Vector2(
      center.x + (anchor.x - 0.5) * 2 * r,
      center.y + (anchor.y - 0.5) * 2 * r,
    );
  }

  Vector2Int getHex(int x, int y) {
    final actual = Vector2Int(x, y).toVector2();
    final offset = Offset(hex0Center.x - R / 2, hex0Center.y - r);
    final left = x <= offset.dx ? 0 : ((x - offset.dx) / (1.5 * R)).floor();
    final top = y <= offset.dy ? 0 : ((y - offset.dy) / (2 * r)).floor();
    final closeHexes = [
      Vector2Int(left, top),
      Vector2Int(left, top - 1),
      Vector2Int(left + 1, top),
      Vector2Int(left + 1, top - 1),
    ];
    closeHexes.sort((hex1, hex2) {
        final hex1Dist = getHexCenter(hex1.x, hex1.y).distanceTo(actual);
        final hex2Dist = getHexCenter(hex2.x, hex2.y).distanceTo(actual);
        return hex1Dist.compareTo(hex2Dist);
      });
    return closeHexes.first;
  }

  @override
  String toString() {
    return 'VerticalHexMap{hex0Center: $hex0Center, isHex1Up: $isHex1Up, r: $r, R: $R, places: $places}';
  }
}
