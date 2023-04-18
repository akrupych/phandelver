import 'package:flame/components.dart';

class Place {
  String name;
  int x;
  int y;
  String? titleAnchor;
  List<String> tags;

  bool get isHidden => tags.contains("hidden");

  Anchor resolveTitleAnchor() =>
      titleAnchor != null ? Anchor.valueOf(titleAnchor!) : Anchor.center;

  Place({
    required this.name,
    required this.x,
    required this.y,
    this.titleAnchor,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'x': this.x,
      'y': this.y,
      'titleAnchor': this.titleAnchor,
      'tags': this.tags,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'] as String,
      x: map['x'] as int,
      y: map['y'] as int,
      titleAnchor: map['titleAnchor'] as String?,
      tags: (map['tags'] as List).cast<String>(),
    );
  }

  @override
  String toString() {
    return 'Place{name: $name, x: $x, y: $y, titleAnchor: $titleAnchor, tags: $tags}';
  }
}
