import 'package:flame/components.dart';
import 'package:phandelver/utils/vector_2_int.dart';

class Place {
  String name;
  Vector2 position;
  Anchor titleAnchor;
  String type;
  bool hidden;
  Vector2Int hex;

  Place({
    required this.name,
    required this.position,
    required this.titleAnchor,
    required this.type,
    required this.hidden,
    required this.hex,
  });
}
