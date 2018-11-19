import 'dart:typed_data';

import 'package:flutter/material.dart';


class PixelBuffer extends ChangeNotifier {
  PixelBuffer(this.width, this.height) {
    _buffer = Uint8List(width * height);
  }

  int width, height;
  Uint8List _buffer;

  get raw => _buffer;

  void addPixel(int x, int y) {
    _buffer[x + y * height] = 1;
    notifyListeners();
  }

  void clearBuffer() {
    _buffer = Uint8List(width * height);
    notifyListeners();
  }

  List<Offset> toPixelList() {
   var pixels = <Offset>[];

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if(_buffer[x + y * width] == 1) {
          pixels.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }

    return pixels;
  }
}

class PixelBufferPainter extends CustomPainter {
  PixelBufferPainter(
    this.buffer,
    this.paintColor
  ) : super(repaint: buffer);

  final PixelBuffer buffer;
  final Color paintColor;

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
          canvas.drawRect(new Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0), _pixelPaint..color = paintColor);
        }
      }
    }
  }

  @override
  bool shouldRepaint(PixelBufferPainter oldDelegate) => true;
}

class PixelBufferWidget extends StatelessWidget {
  final PixelBuffer buffer;
  final Color color;

  PixelBufferWidget({
    Key key,
    @required this.buffer,
    this.color = Colors.red
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      willChange: true,
      painter: PixelBufferPainter(buffer, color),
    );
  }
}