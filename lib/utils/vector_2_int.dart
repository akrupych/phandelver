import 'package:flame/components.dart';

class Vector2Int {
  int x;
  int y;

  Vector2Int(this.x, this.y);

  Vector2Int.fromJson(json) : this(json["x"], json["y"]);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
}

extension Vector2Ext on Vector2 {
  Vector2Int toVector2Int() => Vector2Int(x.round(), y.round());
}
