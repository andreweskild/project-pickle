import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/pixel.dart';

class PixelLayer {
  PixelLayer(this.name);

  final String name;

  final pixels = HashMap<Offset, Color>();
}