import 'package:flutter/widgets.dart';

class Artboard {
  Artboard(
    this.name,
    this.height,
    this.width,
    this.children,
  );

  List<Widget> children;
  String name;
  int height;
  int width;
}