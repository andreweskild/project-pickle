import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:project_pickle/data_objects/pixel.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas.dart';

class PixelPainter extends CustomPainter {
  PixelPainter(
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
  bool shouldRepaint(PixelPainter oldDelegate) => true;
}