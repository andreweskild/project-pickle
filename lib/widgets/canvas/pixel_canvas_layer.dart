import 'dart:collection';
import 'package:flutter/material.dart';


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

class PixelCanvasLayer extends StatelessWidget {
  CustomPaint canvas;

  PixelCanvasLayer({
    Key key,
    this.name,
    @required this.width,
    @required this.height,
    this.hidden = false,
  }) : super(key: key) {
    canvas = new CustomPaint(
      willChange: true,
      painter: CanvasPainter(_pixels, _repaintNotifier),
    );
  }

  String name;
  final int width;
  final int height;
  bool hidden;

  final _repaintNotifier = LayerChangeNotifier();
  final _pixels = HashMap<Offset, Color>();

  get pixels => _pixels;


  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: canvas
    );
  }

  void toggleHidden() {
    hidden = !hidden;
  }

  void setPixel(Offset pos, Color color) {
    if (pos.dx >= 0 && pos.dx < width &&
        pos.dy >= 0 && pos.dy < height ) {
      if (!_pixels.containsKey(pos) ||
          _pixels[pos] != color) {
        _pixels[pos] = color;
        _repaintNotifier.notifyListeners();
      }
    }
  }

  void setPixelsFromMap(HashMap<Offset, Color> pixels) {
    pixels.forEach((pos, color) {
      if (pos.dx >= 0 && pos.dx < width &&
          pos.dy >= 0 && pos.dy < height ) {
        if (!_pixels.containsKey(pos) &&
            color != Colors.white) {
            _pixels[pos] = color;
        } else if (color == Colors.white) {
          _pixels.remove(pos);
        } else if(_pixels[pos] != color) {
          _pixels[pos] = color;
        }
      }
    });
    _repaintNotifier.notifyListeners();
  }

  void removePixel(Offset pos) {
    if (_pixels.containsKey(pos)) {
      _pixels.remove(pos);
      _repaintNotifier.notifyListeners();
    }
  }

  void clearPixels() {
    _pixels.clear();
    _repaintNotifier.notifyListeners();
  }


  void fillArea(Offset pos, Color color, Path selection) {
    if(_pixels.containsKey(pos)) {
      _coloredAreaFill(
        pos,
        _pixels[pos],
        color,
        selection
      );
    }
    else {
      _nullAreaFill(pos, color, selection);
    }
    _repaintNotifier.notifyListeners();
  }

  bool pixelInSelection(Offset pos, Path selection) {
    if(selection == null) return true;
    else return selection.contains(pos.translate(0.5, 0.5));
  }

  void _coloredAreaFill(Offset targetPos, Color targetColor, Color newColor, Path selection) {
    var uncheckedPixels = <Offset>[];
    var checkedPixels = <Offset>[];
    var tempPixels = <Offset>[];

    uncheckedPixels.add(targetPos);

    while (uncheckedPixels.isNotEmpty) {
      uncheckedPixels.forEach( (currentPixel) {
          _getAdjacentColoredPixels(currentPixel, targetColor).forEach(
            (adjacentPixel) {
              if( !tempPixels.contains(adjacentPixel) &&
                  !checkedPixels.contains(adjacentPixel) &&
                  !uncheckedPixels.contains(adjacentPixel) &&
                  pixelInSelection(adjacentPixel, selection)) {
                    tempPixels.add(adjacentPixel);
                  }
            }
          );
        }
      );

      checkedPixels.addAll(uncheckedPixels);
      uncheckedPixels.clear();
      uncheckedPixels.addAll(tempPixels);
      tempPixels.clear();
    }

    checkedPixels.forEach((pixelPos) => _pixels[pixelPos] = newColor);
  }

  List<Offset> _getAdjacentColoredPixels(Offset targetPixelPos, Color targetPixelColor) {
    List<Offset> adjacentPixels = new List<Offset>();
    Offset currentPixelPoint;
    
    currentPixelPoint = targetPixelPos.translate(-1.0, 0.0);
    if ( _pixels[currentPixelPoint] == targetPixelColor) {
      adjacentPixels.add(currentPixelPoint);
    }
    currentPixelPoint = targetPixelPos.translate(1.0, 0.0);
    if ( _pixels[currentPixelPoint] == targetPixelColor) {
      adjacentPixels.add(currentPixelPoint);
    }
    currentPixelPoint = targetPixelPos.translate(0.0, -1.0);
    if ( _pixels[currentPixelPoint] == targetPixelColor) {
      adjacentPixels.add(currentPixelPoint);
    }
    currentPixelPoint = targetPixelPos.translate(0.0, 1.0);
    if ( _pixels[currentPixelPoint] == targetPixelColor) {
      adjacentPixels.add(currentPixelPoint);
    }

    return adjacentPixels;
  }

  List<Offset> _getAdjacentNullPixels(Offset targetPixelPos) {
    List<Offset> adjacentPixels = new List<Offset>();
    Offset currentPixelPoint;

    currentPixelPoint = targetPixelPos.translate(-1.0, 0.0);
    if ( currentPixelPoint.dx >= 0 && currentPixelPoint.dx < 32 &&
          currentPixelPoint.dy >= 0 && currentPixelPoint.dy < 32 &&
          !_pixels.containsKey(currentPixelPoint)) {
      adjacentPixels.add(currentPixelPoint);
    }
    currentPixelPoint = targetPixelPos.translate(1.0, 0.0);
    if ( currentPixelPoint.dx >= 0 && currentPixelPoint.dx < 32 &&
        currentPixelPoint.dy >= 0 && currentPixelPoint.dy < 32 &&
        !_pixels.containsKey(currentPixelPoint)) {
      adjacentPixels.add(currentPixelPoint);
    }
    currentPixelPoint = targetPixelPos.translate(0.0, -1.0);
    if ( currentPixelPoint.dx >= 0 && currentPixelPoint.dx < 32 &&
        currentPixelPoint.dy >= 0 && currentPixelPoint.dy < 32 &&
        !_pixels.containsKey(currentPixelPoint)) {
      adjacentPixels.add(currentPixelPoint);
    }
    currentPixelPoint = targetPixelPos.translate(0.0, 1.0);
    if ( currentPixelPoint.dx >= 0 && currentPixelPoint.dx < 32 &&
        currentPixelPoint.dy >= 0 && currentPixelPoint.dy < 32 &&
        !_pixels.containsKey(currentPixelPoint) ) {
      adjacentPixels.add(currentPixelPoint);
    }

    return adjacentPixels;
  }


  void _nullAreaFill(Offset targetPos, Color newColor, Path selection) {
    var uncheckedPixels = <Offset>[];
    var checkedPixels = <Offset>[];
    var tempPixels = <Offset>[];

    uncheckedPixels.add(targetPos);

    while (uncheckedPixels.isNotEmpty) {
      uncheckedPixels.forEach( (currentPixel) {
        _getAdjacentNullPixels(currentPixel).forEach(
            (adjacentPixel) {
              if( !tempPixels.contains(adjacentPixel) &&
                  !checkedPixels.contains(adjacentPixel) &&
                  !uncheckedPixels.contains(adjacentPixel) &&
                  pixelInSelection(adjacentPixel, selection)) {
                tempPixels.add(adjacentPixel);
              }
            }
          );
        }
      );

      checkedPixels.addAll(uncheckedPixels);
      uncheckedPixels.clear();
      uncheckedPixels.addAll(tempPixels);
      tempPixels.clear();
    }

    checkedPixels.forEach((pixelPos) => _pixels[pixelPos] = newColor);
  }
}