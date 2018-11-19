import 'dart:collection';

import 'package:flutter/widgets.dart';

class Pixel {
  const Pixel({
    this.pos,
    this.color
  });

  final Offset pos;
  final Color color;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + pos.hashCode;
    result = 37 * result + color.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Pixel) return false;
    Pixel pixel = other;
    return (pixel.pos == pos &&
        pixel.color == color);
  }
}

class PixelList extends ListBase<Pixel> {
  var _pixels = <Pixel>[];
  PixelList();

  @override
  Pixel operator [](int index) {
    return _pixels[index];
  }

  @override
  void operator []=(int index, Pixel other) {
    _pixels[index] = other;
  }

  @override
  get length => _pixels.length;

  @override
  set length(int length) => _pixels.length = length;

  @override
  void add(Pixel pixel) {
    _pixels.add(pixel);
  }

  @override
  void addAll(Iterable<Pixel> pixels) {
    _pixels.addAll(pixels);
  }

  bool containsPixelByPosition(Offset pos) {
    _pixels.forEach(
      (pixel) {
        if (pixel.pos == pos) return true;
      }
    );
    return false;
  }

  Pixel pixelAtPosition(Offset pos) {
    _pixels.forEach(
            (pixel) {
          if(pixel.pos == pos) return pixel;
        }
    );
    return null;
  }
//
//  List<Pixel> connectedPixels(Offset targetPos, Color targetColor, Color newColor, Path selection) {
//    var uncheckedPixels = <Offset>[];
//    var checkedPixels = <Offset>[];
//    var tempPixels = <Offset>[];
//
//    uncheckedPixels.add(targetPos);
//
//    while (uncheckedPixels.isNotEmpty) {
//      uncheckedPixels.forEach( (currentPixel) {
//        _getAdjacentColoredPixels(currentPixel, targetColor).forEach(
//                (adjacentPixel) {
//              if( !tempPixels.contains(adjacentPixel) &&
//                  !checkedPixels.contains(adjacentPixel) &&
//                  !uncheckedPixels.contains(adjacentPixel) &&
//                  pixelInSelection(adjacentPixel, selection)) {
//                tempPixels.add(adjacentPixel);
//              }
//            }
//        );
//      }
//      );
//
//      checkedPixels.addAll(uncheckedPixels);
//      uncheckedPixels.clear();
//      uncheckedPixels.addAll(tempPixels);
//      tempPixels.clear();
//    }
//
//    checkedPixels.forEach((pixelPos) => _pixels[pixelPos] = newColor);
//  }
//
//  void _nullAreaFill(Offset targetPos, Color newColor, Path selection) {
//    var uncheckedPixels = <Offset>[];
//    var checkedPixels = <Offset>[];
//    var tempPixels = <Offset>[];
//
//    uncheckedPixels.add(targetPos);
//
//    while (uncheckedPixels.isNotEmpty) {
//      uncheckedPixels.forEach( (currentPixel) {
//        _getAdjacentNullPixels(currentPixel).forEach(
//                (adjacentPixel) {
//              if( !tempPixels.contains(adjacentPixel) &&
//                  !checkedPixels.contains(adjacentPixel) &&
//                  !uncheckedPixels.contains(adjacentPixel) &&
//                  pixelInSelection(adjacentPixel, selection)) {
//                tempPixels.add(adjacentPixel);
//              }
//            }
//        );
//      }
//      );
//
//      checkedPixels.addAll(uncheckedPixels);
//      uncheckedPixels.clear();
//      uncheckedPixels.addAll(tempPixels);
//      tempPixels.clear();
//    }
//
//    checkedPixels.forEach((pixelPos) => _pixels[pixelPos] = newColor);
//  }

  List<Pixel> _adjacentPixels(Pixel targetPixel) {
    var adjacentPixels = <Pixel>[];
    Pixel currentPixel;

    // if the target pixel is colored
    if(containsPixelByPosition(targetPixel.pos)) {
      currentPixel = pixelAtPosition(targetPixel.pos.translate(-1.0, 0.0));
      if (currentPixel == targetPixel) {
        adjacentPixels.add(currentPixel);
      }
      currentPixel = pixelAtPosition(targetPixel.pos.translate(1.0, 0.0));
      if (currentPixel == targetPixel) {
        adjacentPixels.add(currentPixel);
      }
      currentPixel = pixelAtPosition(targetPixel.pos.translate(0.0, -1.0));
      if (currentPixel == targetPixel) {
        adjacentPixels.add(currentPixel);
      }
      currentPixel = pixelAtPosition(targetPixel.pos.translate(0.0, 1.0));
      if (currentPixel == targetPixel) {
        adjacentPixels.add(currentPixel);
      }

      return adjacentPixels;
    }

    // else the target pixel is empty
    else {
      currentPixel = Pixel(
        pos: targetPixel.pos.translate(-1.0, 0.0),
      );
      if ( currentPixel.pos.dx >= 0 && currentPixel.pos.dx < 32 &&
          currentPixel.pos.dy >= 0 && currentPixel.pos.dy < 32 &&
          !containsPixelByPosition(currentPixel.pos)) {
        adjacentPixels.add(currentPixel);
      }
      currentPixel = Pixel(
        pos: targetPixel.pos.translate(1.0, 0.0),
      );
      if ( currentPixel.pos.dx >= 0 && currentPixel.pos.dx < 32 &&
          currentPixel.pos.dy >= 0 && currentPixel.pos.dy < 32 &&
          !containsPixelByPosition(currentPixel.pos)) {
        adjacentPixels.add(currentPixel);
      }
      currentPixel = Pixel(
        pos: targetPixel.pos.translate(0.0, -1.0),
      );
      if ( currentPixel.pos.dx >= 0 && currentPixel.pos.dx < 32 &&
          currentPixel.pos.dy >= 0 && currentPixel.pos.dy < 32 &&
          !containsPixelByPosition(currentPixel.pos)) {
        adjacentPixels.add(currentPixel);
      }
      currentPixel = Pixel(
        pos: targetPixel.pos.translate(0.0, 1.0),
      );
      if ( currentPixel.pos.dx >= 0 && currentPixel.pos.dx < 32 &&
          currentPixel.pos.dy >= 0 && currentPixel.pos.dy < 32 &&
          !containsPixelByPosition(currentPixel.pos)) {
        adjacentPixels.add(currentPixel);
      }

      return adjacentPixels;
    }
  }
}