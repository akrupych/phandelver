import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

List<Shadow> getOutlineShadow(Color color, int thickness) => List.generate(
      thickness,
      (index) => [
        Shadow(
          offset: Offset(-index.toDouble(), -index.toDouble()),
          color: color,
          blurRadius: thickness.toDouble(),
        ),
        Shadow(
          offset: Offset(index.toDouble(), -index.toDouble()),
          color: color,
          blurRadius: thickness.toDouble(),
        ),
        Shadow(
          offset: Offset(index.toDouble(), index.toDouble()),
          color: color,
          blurRadius: thickness.toDouble(),
        ),
        Shadow(
          offset: Offset(-index.toDouble(), index.toDouble()),
          color: color,
          blurRadius: thickness.toDouble(),
        ),
      ],
    ).expand((element) => element).toList();

List<Shadow> outlinedText(
    {double strokeWidth = 2,
    Color strokeColor = Colors.black,
    int precision = 5}) {
  Set<Shadow> result = HashSet();
  for (int x = 1; x < strokeWidth + precision; x++) {
    for (int y = 1; y < strokeWidth + precision; y++) {
      double offsetX = x.toDouble();
      double offsetY = y.toDouble();
      result.add(Shadow(
        offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
        color: strokeColor,
        blurRadius: precision.toDouble(),
      ));
      result.add(Shadow(
        offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
        color: strokeColor,
        blurRadius: precision.toDouble(),
      ));
      result.add(Shadow(
        offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
        color: strokeColor,
        blurRadius: precision.toDouble(),
      ));
      result.add(Shadow(
        offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
        color: strokeColor,
        blurRadius: precision.toDouble(),
      ));
    }
  }
  return result.toList();
}

Anchor revertAnchor(Anchor anchor) => Anchor(
      0.5 - (anchor.x - 0.5),
      0.5 - (anchor.y - 0.5),
    );

class Vector2Int {
  int x;
  int y;

  Vector2Int(this.x, this.y);

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
}

extension Vector2Ext on Vector2 {
  Vector2Int toVector2Int() => Vector2Int(x.round(), y.round());
}