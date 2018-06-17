import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui';

import '../data_objects/pixel_controller.dart';

class PixelCanvas extends CustomPainter {
  PixelCanvas(
    this._pixels,
    this._previewPixels,
    PixelChangeNotifier notifier
  ) : super(repaint: notifier);

  final List<Pixel> _pixels;
  final List<Pixel> _previewPixels;

  final Paint _pixelPaint = new Paint()
    ..strokeWidth = 1.0
    ..filterQuality = FilterQuality.none
    ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    this._pixels.forEach( (pixel) =>
      canvas.drawRect(pixel, _pixelPaint..color = pixel.color));
    this._previewPixels.forEach( (pixel) =>
      canvas.drawRect(pixel, _pixelPaint..color = pixel.color));
  }

  @override
  bool shouldRepaint(PixelCanvas oldDelegate) => true;
}