import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:phandelver/components/vertical_hex_map.dart';
import 'package:phandelver/components/my_camera.dart';

class MyGame extends FlameGame with ScaleDetector {
  late MyCamera myCamera;
  late VerticalHexMap map;

  late double startZoom;
  late double minZoom;
  late double maxZoom;

  @override
  FutureOr<void> onLoad() async {
    map = await VerticalHexMap.load(
      imageFile: "sword_coast.jpg",
      jsonFile: "sword_coast.json",
    );
    final table = SpriteComponent(sprite: await Sprite.load("table.jpg"))
      ..scale = Vector2(4, 4)
      ..angle = 0.1
      ..center = map.center;
    final hero = SpriteComponent(sprite: await Sprite.load("hero.webp"))
      ..anchor = Anchor.center
      ..position = map.getHexCenter(4, 13);
    final flagSprite = await Sprite.load("flag.png");
    final flags = map.places.map((e) => SpriteComponent(
      sprite: flagSprite,
      anchor: Anchor.center,
      position: map.getHexCenter(e.x, e.y),
    )..setAlpha(e.isHidden ? 128 : 255));
    final world = World(
      children: [
        table,
        map,
        ...flags,
        hero,
      ],
    );
    myCamera = MyCamera(world: world);
    addAll([world, myCamera]);
    initZoomLevels();
    updateCameraBounds();
  }

  void initZoomLevels() {
    final scaleX = myCamera.width / map.width - 0.01;
    final scaleY = myCamera.height / map.height - 0.01;
    minZoom = min(scaleX, scaleY);
    maxZoom = minZoom * 10;
    myCamera.position = map.getHexCenter(4, 13);
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
