import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:project_pickle/state/app_state.dart';

class LayerChangeNotifier extends ChangeNotifier {
  LayerChangeNotifier();
}

class CanvasPainter extends CustomPainter {
  CanvasPainter(
    this._pixels,
    LayerChangeNotifier _notifier
  ) : super(repaint: _notifier);

  final HashMap<Offset, Color> _pixels;

  final Paint _pixelPaint = new Paint()
    ..strokeWidth = 1.0
    ..filterQuality = FilterQuality.none
    ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    for (var entry in _pixels.entries) {
      canvas.drawRect(new Rect.fromLTWH(entry.key.dx, entry.key.dy, 1.0, 1.0), _pixelPaint..color = entry.value);
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}