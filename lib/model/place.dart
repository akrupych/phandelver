import 'package:flame/components.dart';

class Place {
  String name;
  int x;
  int y;
  Anchor titleAnchor;
  List<String> tags;
  int hexX;
  int hexY;

  bool get isHidden => tags.contains("hidden");

  Place({
    required this.name,
    required this.x,
    required this.y,
    required this.titleAnchor,
    required this.tags,
    required this.hexX,
    required this.hexY,
  });

  @override
  String toString() {
    return 'Place{name: $name, x: $x, y: $y, titleAnchor: $titleAnchor, tags: $tags, hexX: $hexX, hexY: $hexY}';
  }
}
