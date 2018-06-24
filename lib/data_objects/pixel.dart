import 'package:flutter/material.dart';


class Pixel extends Rect {
  Color color;

  Pixel(double x, double y, this.color)
    : super.fromLTWH(x, y, 1.0, 1.0);

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + color.hashCode;
    result = 37 * result + left.hashCode;
    result = 37 * result + top.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if(other is! Pixel) return false;
    Pixel pixel = other;
    return (pixel.left == left &&
        pixel.top == top &&
        pixel.color == color);
  }
}