import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/widgets/color_selector/color_slider_thumb.dart';
import 'package:project_pickle/widgets/color_selector/color_slider_value_indicator.dart';

const double _kMenuScreenPadding = 8.0;

class _ColorPopupRouteLayout extends SingleChildLayoutDelegate {
  _ColorPopupRouteLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;


  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return new BoxConstraints.loose(constraints.biggest - const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      x = position.left;
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kMenuScreenPadding)
      x = _kMenuScreenPadding;
    else if (x + childSize.width > size.width - _kMenuScreenPadding)
      x = size.width - childSize.width - _kMenuScreenPadding;
    if (y < _kMenuScreenPadding)
      y = _kMenuScreenPadding;
    else if (y + childSize.height > size.height - _kMenuScreenPadding)
      y = size.height - childSize.height - _kMenuScreenPadding;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_ColorPopupRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class ColorPopupContent extends StatefulWidget {
  ColorPopupContent({
    Key key,
    this.color,
    @required this.initialSize,
    @required this.parentAnimation,
    @required this.onAccept,
  }) : super(key: key);

  final HSLColor color;
  final Size initialSize;
  final Animation<double> parentAnimation;
  final VoidCallback onAccept;


  @override
  _ColorPopupContentState createState() => _ColorPopupContentState();
}

class _ColorPopupContentState extends State<ColorPopupContent> {

  HSLColor _currentColor;

  @override
  void initState() {
    _currentColor = widget.color;
    super.initState();
  }

  void updateColorWith({double h, double s, double l}) {
    setState(() {
      if (h != null) _currentColor.h = h;
      if (s != null) _currentColor.s = s;
      if (l != null) _currentColor.l = l;
    });
  }


  Color _getContrastingColor(Color color) {
    if (color.computeLuminance() > 0.5) {
      return Colors.black;
    }
    else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Animation<BorderRadius> borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(16.0),
      end: BorderRadius.circular(8.0),
    ).animate(
      CurvedAnimation(
        parent: widget.parentAnimation,
        curve: Interval(
          0.0, 1.0,
          curve: Curves.ease,
        ),
      ),
    );

    final Animation<Size> size = SizeTween(
      begin: widget.initialSize,
      end: Size(256.0, 172.0),
    ).animate(
      CurvedAnimation(
        parent: widget.parentAnimation,
        curve: Interval(
          0.0, 1.0,
          curve: Curves.ease,
        ),
      ),
    );

    final Animation<double> opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.parentAnimation,
        curve: Interval(
          0.2, 1.0,
          curve: Curves.ease,
        ),
      ),
    );

    return SizedBox(
      height: size.value.height,
      width: size.value.width,
      child: Material(
        elevation: 6.0,
          animationDuration: Duration.zero,
          color: _currentColor.toColor(),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius.value,
            side: BorderSide(
              color: Colors.black26,
            ),
          ),
          child: Opacity(
            opacity: opacity.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: widget.initialSize.height * 1.33,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.check,
                              color: _getContrastingColor(_currentColor.toColor()),
                            ),
                            onPressed: widget.onAccept,
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                                  child: Text('H'),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      thumbColor: Colors.white,
                                      thumbShape: ColorSliderThumbShape(),
                                      showValueIndicator: ShowValueIndicator.always,
                                      valueIndicatorColor: _currentColor.copyWith(s: 1.0, l: 0.5).toColor(),
                                      valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                                  colors: [const Color(0xFFFF0000), const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFF00FFFF), const Color(0xFF0000FF), const Color(0xFFFF00FF), const Color(0xFFFF0000)], // whitish to gray
                                                  tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                                ),
                                                borderRadius: BorderRadius.circular(6.0),
                                                border: Border.all(
                                                  color: Colors.black38,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Slider(
                                            onChanged: (value) {
                                              updateColorWith(h: value);
                                            },
                                            label: '',
                                            value: _currentColor.h,
                                            min: 0.0,
                                            max: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                                  child: Text('S'),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      thumbColor: Colors.white,
                                      thumbShape: ColorSliderThumbShape(),
                                      showValueIndicator: ShowValueIndicator.always,
                                      valueIndicatorColor: _currentColor.toColor(),
                                      valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                                  colors: [_currentColor.copyWith(s: 0.0).toColor(), _currentColor.copyWith(s: 1.0).toColor()], // whitish to gray
                                                  tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                                ),
                                                borderRadius: BorderRadius.circular(6.0),
                                                border: Border.all(
                                                  color: Colors.black38,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Slider(
                                            onChanged: (value) {
                                              updateColorWith(s: value);
                                            },
                                            label: '',
                                            value: _currentColor.s,
                                            min: 0.0,
                                            max: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                                  child: Text('L'),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      thumbColor: Colors.white,
                                      thumbShape: ColorSliderThumbShape(),
                                      showValueIndicator: ShowValueIndicator.always,
                                      valueIndicatorColor: _currentColor.toColor(),
                                      valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                                  colors: [const Color(0xFF000000), _currentColor.copyWith(l: 0.5).toColor(), const Color(0xFFFFFFFF)], // whitish to gray
                                                  tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                                ),
                                                borderRadius: BorderRadius.circular(6.0),
                                                border: Border.all(
                                                  color: Colors.black38,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 0.0,
                                          child: Slider(
                                            onChanged: (value) {
                                              updateColorWith(l: value);
                                            },
                                            label: '',
                                            value: _currentColor.l,
                                            min: 0.0,
                                            max: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}


class _ColorPopupRoute extends PopupRoute<HSLColor> {
  _ColorPopupRoute({
    @required this.color,
    @required this.initialSize,
    @required this.position,
  });

  final HSLColor color;
  final Size initialSize;
  final RelativeRect position;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => '';

  @override
  HSLColor get currentResult => color;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> forwardAnimation) {
    return SizedBox();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> forwardAnimation, Widget child) {
    final Animation<double> parentAnimation = new CurvedAnimation(
        parent: animation,
        curve: Curves.ease
    );


    return new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: new Builder(
        builder: (BuildContext context) {
          return new CustomSingleChildLayout(
            delegate: new _ColorPopupRouteLayout(
              position,
            ),
            child: ColorPopupContent(
              color: color,
              initialSize: initialSize,
              parentAnimation: parentAnimation,
              onAccept: () {
                Navigator.pop(context);
              },
            )
          );
        },
      ),
    );
  }
}

typedef ColorChangeCallback = void Function(HSLColor);

class ColorMenuButton extends StatelessWidget {
  ColorMenuButton({
    Key key,
    @required this.color,
    @required this.onColorChanged
  }) : super(key: key);

  final HSLColor color;
  final ColorChangeCallback onColorChanged;

  _showColorMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final HSLColor newColor = await Navigator.of(context).push(new _ColorPopupRoute(
      color: color,
      initialSize: button.size,
      position: position,
    ));

    onColorChanged(newColor);
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color.toColor(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(''),
      ),
      padding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Colors.black38,
        ),
      ),
      onPressed: () => _showColorMenu(context),
    );
  }
}