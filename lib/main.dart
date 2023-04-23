import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:phandelver/my_game.dart';
import 'package:phandelver/widgets/scroll_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
    GameWidget<MyGame>(
      game: MyGame(),
      overlayBuilderMap: {
        "scroll": (context, game) => ScrollWidget(game: game),
      },
    ),
  );
}
