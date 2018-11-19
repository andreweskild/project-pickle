
import 'package:flutter/widgets.dart';

class Pixel {
  const Pixel({
    this.pos,
    this.color
  });

  final Offset pos;
  final Color color;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + pos.hashCode;
    result = 37 * result + color.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Pixel) return false;
    Pixel pixel = other;
    return (pixel.pos == pos &&
        pixel.color == color);
  }
}