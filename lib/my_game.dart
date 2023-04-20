import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phandelver/components/my_camera.dart';
import 'package:phandelver/components/vertical_hex_map.dart';
import 'package:phandelver/model/adventure.dart';
import 'package:phandelver/model/place.dart';
import 'package:phandelver/utils/utils.dart';
import 'package:phandelver/utils/vector_2_int.dart';

class MyGame extends FlameGame with ScaleDetector {
  late World world;
  late VerticalHexMap map;
  late List<Place> places;
  late SpriteComponent hero;

  late MyCamera myCamera;
  late double startZoom;
  late double minZoom;
  late double maxZoom;

  @override
  FutureOr<void> onLoad() async {
    loadWorld();
    await loadMap();
    await loadAdventure();
    setZoomLevels();
    updateCameraBounds();
  }

  void loadWorld() {
    world = World();
    myCamera = MyCamera(world: world);
    addAll([world, myCamera]);
  }

  FutureOr<void> loadMap() async {
    final sprite = await Sprite.load("sword_coast.jpg");
    final json =
        jsonDecode(await rootBundle.loadString("assets/text/sword_coast.json"));
    final hex0 = json["hex0"];
    final hex0TopLeft = Vector2(
      hex0["topLeftX"].toDouble(),
      hex0["topLeftY"].toDouble(),
    );
    final hex0BottomRight = Vector2(
      hex0["bottomRightX"].toDouble(),
      hex0["bottomRightY"].toDouble(),
    );
    final isHex1Up = json["isHex1Up"];
    map = VerticalHexMap(
      sprite: sprite,
      hex0TopLeft: hex0TopLeft,
      hex0BottomRight: hex0BottomRight,
      isHex1Up: isHex1Up,
    );
    places = (json["places"] as List).map((e) {
      final anchor = e["titleAnchor"];
      final position = Vector2Int.fromJson(e).toVector2();
      final hex = map.getHex(position);
      return Place(
        name: e["name"],
        position: position,
        titleAnchor: anchor != null ? Anchor.valueOf(anchor) : Anchor.center,
        type: e["type"],
        hidden: e["hidden"],
        hex: Vector2Int(hex.x, hex.y),
      );
    }).toList();
    world.add(map);
  }

  FutureOr<void> loadAdventure() async {
    final json =
        jsonDecode(await rootBundle.loadString("assets/text/adventure.json"));
    final adventure = Adventure(
      startHex: map.getHex(Vector2Int.fromJson(json["start"]).toVector2()),
      scenes: (json["scenes"] as List)
          .map((e) => AdventureScene(
                id: e["id"],
                text: e["text"],
                position: e["position"] != null
                    ? Vector2Int.fromJson(e["position"])
                    : null,
                actions: (e["actions"] as List)
                    .map((e) => SceneAction(id: e["id"], text: e["text"]))
                    .toList(),
              ))
          .toList(),
    );
    hero = SpriteComponent(sprite: await Sprite.load("hero.webp"))
      ..anchor = Anchor.center
      ..position = map.getHexCenter(adventure.startHex);
    map.add(hero);
  }

  final textPaint = TextPaint(
    style: TextStyle(
      fontSize: 54,
      fontFamily: "Mentor",
      color: Colors.black,
      shadows: outlinedText(
        strokeWidth: 5,
        strokeColor: const Color(0xfffdf4da),
        precision: 2,
      ),
    ),
  );

  void setZoomLevels() {
    final scaleX = myCamera.width / map.width;
    final scaleY = myCamera.height / map.height;
    minZoom = max(scaleX, scaleY);
    maxZoom = minZoom * 10;
    myCamera.position = hero.position;
    myCamera.zoom = 0.5;
  }

  void updateCameraBounds() {
    final cameraWidth = myCamera.width / myCamera.zoom;
    final cameraHeight = myCamera.height / myCamera.zoom;
    myCamera.setBounds(Rectangle.fromLTRB(
      cameraWidth / 2,
      cameraHeight / 2,
      map.width - cameraWidth / 2,
      map.height - cameraHeight / 2,
    ));
  }

  @override
  void onScaleStart(info) {
    startZoom = myCamera.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      final newZoom = startZoom * currentScale.y;
      myCamera.zoom = clampDouble(newZoom, minZoom, maxZoom);
      updateCameraBounds();
    } else {
      myCamera.moveBy(-info.delta.viewport / myCamera.zoom);
    }
  }
}
