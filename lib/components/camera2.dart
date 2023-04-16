import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

class Camera2 extends CameraComponent {
  Camera2({required super.world});

  set position(Vector2 value) {
    viewfinder.position = value;
  }

  double get zoom => viewfinder.zoom;

  set zoom(double value) {
    viewfinder.zoom = value;
  }

  double get width => viewport.size.x;

  double get height => viewport.size.y;
}