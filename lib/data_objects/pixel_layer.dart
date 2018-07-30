import 'dart:collection';
import 'package:flutter/material.dart';

class PixelLayer {
  PixelLayer(this.name);

  final String name;

  final pixels = HashMap<Offset, Color>();

}