import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/common/square_button.dart';
import 'package:project_pickle/widgets/common/two_stage_popup_button.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';
//
//class PixelLayerItem extends StatefulWidget {
//  PixelLayerItem({
//    this.active,
//    this.onDuplicate,
//    this.onToggle,
//    this.onToggleHidden,
//    this.data
//  });
//
//  final bool active;
//  final VoidCallback onToggle;
//  final VoidCallback onToggleHidden;
//  final VoidCallback onDuplicate;
//
//  final PixelLayer data;
//
//  factory PixelLayerItem.from(PixelLayerItem layer) {
//    return PixelLayerItem(
//      active: layer.active,
//      onDuplicate: layer.onDuplicate,
//      onToggle: layer.onToggle,
//      onToggleHidden: layer.onToggleHidden,
//      data: PixelLayer.from(layer.data),
//    );
//  }
//
//  @override
//  createState() => PixelLayerItemState();
//}
//
//class PixelLayerItemState extends State<PixelLayerItem> with SingleTickerProviderStateMixin {
//  AnimationController animationController;
//
//  void performPopupAction(BuildContext context, VoidCallback action) {
//    Navigator.pop(context, action);
//  }
//
//  @override
//  void initState() {
//    animationController = AnimationController(
//      duration: Duration(milliseconds: 700),
//      vsync: this,
//    );
//    animationController.forward();
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SizeTransition(
//      sizeFactor: CurvedAnimation(
//          parent: animationController, curve: Curves.ease
//      ),
//      child: DecoratedBox(
//        decoration: BoxDecoration(
//          color: Theme.of(context).scaffoldBackgroundColor,
//          borderRadius: BorderRadius.circular(8.0),
//        ),
//        child: TwoStagePopupButton(
//          headerContent: (opened) {
//            var content = Row(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(right: 12.0),
//                    child: AspectRatio(
//                        aspectRatio: 1.0,
//                        child: DecoratedBox(
//                            decoration: BoxDecoration(
//                                color: Colors.white,
//                                borderRadius: BorderRadius.circular(6.0)
//                            ),
//                            child: ClipRRect(
//                                borderRadius: BorderRadius.circular(6.0),
//                                child: widget.data.canvas
//                            )
//                        )
//                    ),
//                  ),
//                  Expanded(
//                    child: Text(
//                        widget.data.name,
//                        softWrap: false,
//                        style: TextStyle(
//                          inherit: true,
//                          fontWeight: FontWeight.bold,
//                        )
//                    ),
//                  ),
//                  Center(
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: AspectRatio(
//                        aspectRatio: 1.0,
//                        child: FlatButton(
//                          padding: EdgeInsets.all(0.0),
//                          splashColor: const Color(0x9986C040),
//                          highlightColor: const Color(0x99B0EF63),
//                          child: IconTheme(
//                            data: IconThemeData(
//                                color: widget.active
//                                    ? Theme
//                                    .of(context)
//                                    .accentIconTheme
//                                    .color
//                                    : Theme
//                                    .of(context)
//                                    .iconTheme
//                                    .color
//                            ),
//                            child: Icon(
//                              (widget.data.hidden) ? Icons.remove : Icons.remove_red_eye,
//                              size: 20.0,
//                            ),
//                          ),
//                          onPressed: widget.onToggleHidden,
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(8.0),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ]
//            );
//            if (opened) {
//              return content;
//            }
//            else {
//              return content;
//            }
//          },
//          popupContent: <PopupContentItem>[
//            PopupContentItem(
//              height: 28.0,
//              child: Row(
//                children: <Widget>[
//                  Text(
//                    "Opacity",
//                  ),
//                  Expanded(
//                    child: Padding(
//                      padding: const EdgeInsets.only(left: 12.0),
//                      child: ValueSlider(
//                        //activeColor: Color(0xFFACA6AF),
//                        activeColor: Theme.of(context).accentColor,
//                        inactiveColor: Theme.of(context).unselectedWidgetColor,
//                        value: 21.0,
//                        min: 1.0,
//                        max: 100.0,
//                        onChanged: (value){
//                        },
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            PopupContentItem(
//                child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(right: 6.0),
//                          child: SquareButton(
//                            child: Text(
//                                "Duplicate",
//                                style: TextStyle(
//                                  inherit: true,
//                                  fontWeight: FontWeight.normal,
//                                )
//                            ),
//                            onPressed: () {
//                              performPopupAction(context, widget.onDuplicate);
////                        onDuplicate();
//                            },
//                            color: Theme.of(context).unselectedWidgetColor,
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(left: 6.0),
//                          child: SquareButton(
//                            child: Text(
//                                "Merge",
//                                style: TextStyle(
//                                  inherit: true,
//                                  fontWeight: FontWeight.normal,
//                                )
//                            ),
//                            onPressed: (){},
//                            color: Theme.of(context).unselectedWidgetColor,
//                          ),
//                        ),
//                      ),
//                    ]
//                )
//            ),
//            PopupContentItem(
//                child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(right: 6.0),
//                          child: SquareButton(
//                            child: Text(
//                                "Alpha Lock",
//                                style: TextStyle(
//                                  inherit: true,
//                                  fontWeight: FontWeight.normal,
//                                )
//                            ),
//                            onPressed: (){},
//                            color: Theme.of(context).unselectedWidgetColor,
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(left: 6.0),
//                          child: SquareButton(
//                            child: Text(
//                                "Clip Layer",
//                                style: TextStyle(
//                                  inherit: true,
//                                  fontWeight: FontWeight.normal,
//                                )
//                            ),
//                            onPressed: (){},
//                            color: Theme.of(context).unselectedWidgetColor,
//                          ),
//                        ),
//                      ),
//                    ]
//                )
//            ),
//            PopupContentItem(
//                child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(right: 6.0),
//                          child: SquareButton(
//                            child: Text(
//                                "Select",
//                                style: TextStyle(
//                                  inherit: true,
//                                  fontWeight: FontWeight.normal,
//                                )
//                            ),
//                            onPressed: (){},
//                            color: Theme.of(context).unselectedWidgetColor,
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Padding(
//                          padding: const EdgeInsets.only(left: 6.0),
//                          child: SquareButton(
//                            child: Text(
//                                "Clear Layer",
//                                style: TextStyle(
//                                  inherit: true,
//                                  fontWeight: FontWeight.normal,
//                                )
//                            ),
//                            onPressed: (){},
//                            color: Theme.of(context).unselectedWidgetColor,
//                          ),
//                        ),
//                      )
//                    ]
//                )
//            )
//          ],
//          onToggled: widget.onToggle,
//          active: widget.active,
//        ),
//      ),
//    );
//  }
//}

class PixelLayerList extends ListBase<PixelLayer> {
  List<PixelLayer> _layers;
  PixelLayerList({
    List<PixelLayer> layers,
    this.indexOfActiveLayer = 0,
  }) {
    _layers = layers ?? <PixelLayer>[];
  }

  int indexOfActiveLayer;

  PixelLayer get activeLayer => _layers[indexOfActiveLayer];

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
    result.indexOfActiveLayer = elements.indexOfActiveLayer;
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

class PixelCanvasWidget extends StatelessWidget {
  final PixelLayer layer;

  PixelCanvasWidget({
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
  PixelCanvasWidget canvas;

  PixelLayer({
    Key key,
    this.name,
    this.animationController,
    @required this.width,
    @required this.height,
    this.hidden = false,
    LinkedHashMap<Offset, Color> pixels,
  }) {
    _pixels = pixels ?? LinkedHashMap<Offset, Color>();
    canvas = PixelCanvasWidget(layer: this);
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
  final AnimationController animationController;

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

  bool removePixel(Offset pos) {
    if (_pixels.containsKey(pos)) {
      _pixels.remove(pos);
      notifyListeners();
      return true;
    }
    return false;
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