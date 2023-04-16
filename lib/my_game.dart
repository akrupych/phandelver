import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:phandelver/components/my_camera_component.dart';

class MyGame extends FlameGame with ScaleDetector {
  late Camera2 camera2;
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
    final world = World(children: [table, map]);
    camera2 = Camera2(world: world);
    addAll([world, camera2]);
    initZoomLevels();
    updateCameraBounds();
  }

  Future<SpriteComponent> loadSpriteComponent(String fileName) async =>
      SpriteComponent.fromImage(await images.load(fileName));

  void initZoomLevels() {
    final scaleX = camera2.width / map.width - 0.01;
    final scaleY = camera2.height / map.height - 0.01;
    minZoom = min(scaleX, scaleY);
    maxZoom = minZoom * 10;
    camera2.position = map.center;
    camera2.zoom = minZoom;
  }

  void updateCameraBounds() {
    final cameraWidth = camera2.width / camera2.zoom;
    final cameraHeight = camera2.height / camera2.zoom;
    camera2.setBounds(Rectangle.fromLTRB(
      cameraWidth / 2,
      cameraHeight / 2,
      map.width - cameraWidth / 2,
      map.height - cameraHeight / 2,
    ));
  }

  @override
  void onScaleStart(info) {
    startZoom = camera2.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      final newZoom = startZoom * currentScale.y;
      camera2.zoom = clampDouble(newZoom, minZoom, maxZoom);
      updateCameraBounds();
    } else {
      camera2.moveBy(-info.delta.viewport / camera2.zoom);
    }
  }
}