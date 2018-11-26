import 'dart:typed_data';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:project_pickle/state/app_state.dart';


class PixelBuffer extends ChangeNotifier {
  PixelBuffer(this.width, this.height) {
    _buffer = Uint8List(width * height);
  }

  int width, height;
  Uint8List _buffer;

  get raw => _buffer;

  void addPixel(int x, int y, ColorType colorType) {
    _buffer[x + y * height] = (colorType == ColorType.Primary) ? 1 : 2;
    notifyListeners();
  }

  void clearBuffer() {
    _buffer = Uint8List(width * height);
    notifyListeners();
  }

  HashMap<Offset, int> toPixelMap() {
   var pixels = HashMap<Offset, int>();

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if(_buffer[x + y * width] > 0) {
          pixels[Offset(x.toDouble(), y.toDouble())] = _buffer[x+y*width];
        }
      }
    }

    return pixels;
  }
}

class PixelBufferPainter extends CustomPainter {
  PixelBufferPainter(
    this.buffer,
    this.primaryColor,
    this.secondaryColor
  ) : super(repaint: buffer);

  final PixelBuffer buffer;
  final Color primaryColor;
  final Color secondaryColor;

  final Paint _pixelPaint = new Paint()
    ..strokeWidth = 1.0
    ..filterQuality = FilterQuality.none
    ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        if(buffer.raw[x + y * size.width.toInt()] == 1) {
          canvas.drawRect(new Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0), _pixelPaint..color = primaryColor);
        }
        else if(buffer.raw[x + y * size.width.toInt()] == 2) {
          canvas.drawRect(new Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0), _pixelPaint..color = secondaryColor);
        }
      }
    }
  }

  @override
  bool shouldRepaint(PixelBufferPainter oldDelegate) => true;
}

class PixelBufferWidget extends StatelessWidget {
  final PixelBuffer buffer;
  final Color primary;
  final Color secondary;

  PixelBufferWidget({
    Key key,
    @required this.buffer,
    this.primary = Colors.red,
    this.secondary = Colors.green
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      willChange: true,
      painter: PixelBufferPainter(buffer, primary, secondary),
    );
  }
}