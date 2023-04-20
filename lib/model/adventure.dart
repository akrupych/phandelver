import 'package:phandelver/utils/vector_2_int.dart';

class Adventure {
  Vector2Int startHex;
  List<AdventureScene> scenes;

  Adventure({
    required this.startHex,
    required this.scenes,
  });
}

class AdventureScene {
  String id;
  String text;
  Vector2Int? position;
  List<SceneAction> actions;

  AdventureScene({
    required this.id,
    required this.text,
    this.position,
    required this.actions,
  });
}

class SceneAction {
  String id;
  String text;

  SceneAction({
    required this.id,
    required this.text,
  });
}
