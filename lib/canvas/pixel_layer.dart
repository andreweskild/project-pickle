import 'dart:collection';
import 'package:flutter/material.dart';

class PixelLayerList extends ListBase<PixelLayer> {
  var _layers;
  PixelLayerList({
    List<PixelLayer> layers
  }) {
    _layers = layers ?? <PixelLayer>[];
  }

  @override
  PixelLayer operator [](int index) {
    return _layers[index];
  }

  @override
  void operator []=(int index, PixelLayer other) {
    _layers[index] = other;
  }

  @override
  get length => _layers.length;

  @override
  set length(int length) => _layers.length = length;

  @override
  void add(PixelLayer pixel) {
    _layers.add(pixel);
  }

  @override
  void addAll(Iterable<PixelLayer> pixels) {
    _layers.addAll(pixels);
  }

  @override
  factory PixelLayerList.from(PixelLayerList elements, {bool growable: true}) {
    var result = PixelLayerList();
    elements.forEach(
      (layer) {
        result.add(PixelLayer.from(layer));
      }
    );
    return result;
  }


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + _layers.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! PixelLayerList) return false;
    PixelLayerList list = other;
    return (list._layers == _layers);
  }
}

class PixelLayerPainter extends CustomPainter {
  PixelLayerPainter(
      this.layer,
      ) : super(repaint: layer);

  final PixelLayer layer;

  final Paint _pixelPaint = Paint()
    ..strokeWidth = 1.0
    ..filterQuality = FilterQuality.none
    ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    for (var entry in layer.raw.entries) {
      canvas.drawRect(Rect.fromLTWH(entry.key.dx, entry.key.dy, 1.0, 1.0), _pixelPaint..color = entry.value);
    }
  }

  @override
  bool shouldRepaint(PixelLayerPainter oldDelegate) => true;
}

class PixelLayerWidget extends StatelessWidget {
  final PixelLayer layer;

  PixelLayerWidget({
    Key key,
    @required this.layer
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: PixelLayerPainter(layer),
    );
  }
}

class PixelLayer extends ChangeNotifier {
  PixelLayerWidget canvas;

  PixelLayer({
    Key key,
    this.name,
    @required this.width,
    @required this.height,
    this.hidden = false,
    LinkedHashMap<Offset, Color> pixels,
  }) {
    _pixels = pixels ?? LinkedHashMap<Offset, Color>();
    canvas = PixelLayerWidget(layer: this);
  }

  factory PixelLayer.from(PixelLayer layer) {
    return PixelLayer(
      name: layer.name,
      width: layer.width,
      height: layer.height,
      hidden: layer.hidden,
      pixels: LinkedHashMap<Offset, Color>.from(layer.raw),
    );
  }

  String name;
  final int width;
  final int height;
  bool hidden;

  var _pixels;

  get raw => _pixels;

  void toggleHidden() {
    hidden = !hidden;
    notifyListeners();
  }

  void setPixel(Offset pos, Color color) {
    if(_pixels.containsKey(pos)) {
      if (_pixels[pos] != color) {
        _pixels.remove(pos);
        _pixels[pos] = color;
        notifyListeners();
      }
    }
    else {
      _pixels[pos] = color;
      notifyListeners();
    }
  }

  void removePixel(Offset pos) {
    if (_pixels.containsKey(pos)) {
      _pixels.remove(pos);
      notifyListeners();
    }
  }

  void clearPixels() {
    _pixels.clear();
    notifyListeners();
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
    notifyListeners();
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