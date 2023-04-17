import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  @override
  String toString() {
    return 'VerticalHexMap{hex0Center: $hex0Center, isHex1Up: $isHex1Up, r: $r, R: $R, places: $places}';
  }
}

class Place {
  String name;
  int x;
  int y;
  List<String> tags;

  bool get isHidden => tags.contains("hidden");

  Place({
    required this.name,
    required this.x,
    required this.y,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'x': this.x,
      'y': this.y,
      'tags': this.tags,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'] as String,
      x: map['x'] as int,
      y: map['y'] as int,
      tags: (map['tags'] as List).cast<String>(),
    );
  }

  @override
  String toString() {
    return 'Place{name: $name, x: $x, y: $y, tags: $tags}';
  }
}
