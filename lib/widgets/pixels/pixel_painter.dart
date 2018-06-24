import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/actions/action_controller.dart';

class PixelPainter extends CustomPainter {
  PixelPainter(
    this._pixelLayers,
    this._previewLayer,
    LayerChangeNotifier _notifier
  ) : super(repaint: _notifier);

  final List<PixelLayer> _pixelLayers;
  final HashMap<Offset, Color> _previewLayer;

  final Paint _pixelPaint = new Paint()
    ..strokeWidth = 1.0
    ..filterQuality = FilterQuality.none
    ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    for (var layer in _pixelLayers) {
      layer.pixels.forEach( (pos, color) => 
        canvas.drawRect(new Rect.fromLTWH(pos.dx, pos.dy, 1.0, 1.0), _pixelPaint..color = color) 
      );
      _previewLayer.forEach( (pos, color) => 
        canvas.drawRect(new Rect.fromLTWH(pos.dx, pos.dy, 1.0, 1.0), _pixelPaint..color = color) 
      );
    }
  }

  @override
  bool shouldRepaint(PixelPainter oldDelegate) => true;
}