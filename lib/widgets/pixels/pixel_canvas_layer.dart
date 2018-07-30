import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/pixels/canvas_painter.dart';

class PixelCanvasLayer extends StatelessWidget {
  CustomPaint canvas;

  PixelCanvasLayer({
    Key key,
    this.name,
    @required this.width,
    @required this.height,
  }) : super(key: key) {
    canvas = new CustomPaint(
      willChange: true,
      painter: CanvasPainter(_pixels, _repaintNotifier),
    );
  }

  String name;
  final int width;
  final int height;

  final _repaintNotifier = LayerChangeNotifier();
  final _pixels = HashMap<Offset, Color>();

  get rawPixels => _pixels;

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
        if (!_pixels.containsKey(pos) ||
              _pixels[pos] != color) {
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

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: canvas
    );
  }

  void fillArea(Offset pos, Color color) {
    if(_pixels.containsKey(pos)) {
      _coloredAreaFill(
        pos,
        _pixels[pos],
        color
      );
    }
    else {
      _nullAreaFill(pos, color);
    }
    _repaintNotifier.notifyListeners();
  }

  void _coloredAreaFill(Offset targetPos, Color targetColor, Color newColor) {
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
                  !uncheckedPixels.contains(adjacentPixel)) {
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


  void _nullAreaFill(Offset targetPos, Color newColor) {
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
                  !uncheckedPixels.contains(adjacentPixel)) {
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