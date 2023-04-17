import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:phandelver/components/my_camera.dart';

class MyGame extends FlameGame with ScaleDetector {
  late MyCamera myCamera;
  late SpriteComponent map;

  late double startZoom;
  late double minZoom;
  late double maxZoom;

  @override
  FutureOr<void> onLoad() async {
    map = await loadSpriteComponent("sword_coast.jpg");
    final table = await loadSpriteComponent("table.jpg")
      ..scale = Vector2(4, 4)
      ..angle = 0.1
      ..center = map.center;
    final hero = await loadSpriteComponent("hero.webp")
      ..anchor = Anchor.center
      ..position = Vector2(198, 167);
    final world = World(children: [table, map, hero]);
    myCamera = MyCamera(world: world);
    addAll([world, myCamera]);
    initZoomLevels();
    updateCameraBounds();
  }

  Future<SpriteComponent> loadSpriteComponent(String fileName) async =>
      SpriteComponent.fromImage(await images.load(fileName));

  void initZoomLevels() {
    final scaleX = myCamera.width / map.width - 0.01;
    final scaleY = myCamera.height / map.height - 0.01;
    minZoom = min(scaleX, scaleY);
    maxZoom = minZoom * 10;
    // camera2.position = map.center;
    // camera2.zoom = minZoom;
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
