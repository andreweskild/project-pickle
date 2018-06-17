import 'package:flutter/material.dart';


class Pixel extends Rect {
  Color color;

  Pixel(double x, double y, this.color)
    : super.fromLTWH(x, y, 1.0, 1.0);
}