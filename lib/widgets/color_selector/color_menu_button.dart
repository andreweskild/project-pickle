import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/widgets/color_selector/color_slider_thumb.dart';
import 'package:project_pickle/widgets/color_selector/color_slider_value_indicator.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';
import 'package:project_pickle/widgets/common/slider_thumb_shape.dart';

const double _kMenuScreenPadding = 12.0;

const double _kButtonHeight = 56.0;

const double _kMenuWidth = 324.0;
const double _kMenuHeight = 72.0 + 12.0 * 4.0 + 40.0 * 3.0 + 1.0;



Color _getBorderColor(Color color) {
  if(color.computeLuminance() > 0.5) {
    return Color.lerp(color, Colors.purple, 0.1);
  }
  else {
    return Colors.transparent;
  }
}

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
    @required this.onAccept,
    @required this.onCancel,
    @required this.onColorChanged,
    @required this.initialSize,
    @required this.parentAnimation,
  }) : super(key: key);

  final ValueChanged<HSLColor> onAccept;
  final VoidCallback onCancel;
  final ValueChanged<HSLColor> onColorChanged;
  final HSLColor color;
  final Size initialSize;
  final Animation<double> parentAnimation;

  @override
  createState() => ColorPopupContentState();
}

class ColorPopupContentState extends State<ColorPopupContent> {
  HSLColor _color;

  @override
  void initState() {
    _color = widget.color;
    super.initState();
  }

  void updateColorWith({double h, double s, double l}) {
    setState((){
      if (h != null) _color = _color.withHue(h);
      if (s != null) _color = _color.withSaturation(s);
      if (l != null) _color = _color.withLightness(l);
    });
    widget.onColorChanged(_color);
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

    final Animation<Size> size = SizeTween(
      begin: widget.initialSize,
      end: Size(_kMenuWidth, _kMenuHeight),
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
      child: Card(
        child: Column(
          children: <Widget>[
            CardHeader(
              color: _color.toColor(),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    children: <Widget>[
                      OutlineIconButton(
                        icon: Icon(Icons.clear),
                        onPressed: widget.onCancel,
                        color: _getContrastingColor(_color.toColor()),
                      ),
                      SizedBox(
                          width: 12.0
                      ),
                      OutlineIconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: widget.onCancel,
                        color: _getContrastingColor(_color.toColor()),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: OutlineIconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => widget.onAccept(_color),
                            color: _getContrastingColor(_color.toColor()),
                          ),
                        ),
                      )
                    ]
                ),
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: opacity.value,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  'H',
                                ),

                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      activeTickMarkColor: Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      thumbShape: ColorSliderThumbShape(_color.withSaturation(1.0).withLightness(0.5).toColor()),
                                      overlayColor: _color.withAlpha(0.3).withSaturation(1.0).withLightness(0.5).toColor(),
                                      showValueIndicator: ShowValueIndicator.always,
                                      valueIndicatorColor: _color.withSaturation(1.0).withLightness(0.5).toColor(),
                                      valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: TextStyle(
                                        color: _getContrastingColor(_color.withSaturation(1.0).withLightness(0.5).toColor()),
                                      )
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                              colors: [const Color(0xFFFF0000), const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFF00FFFF), const Color(0xFF0000FF), const Color(0xFFFF00FF), const Color(0xFFFF0000)], // whitish to gray
                                              tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: ValueSlider(
                                          onChanged: (value) {
                                            updateColorWith(h: value);
                                          },
                                          label: (_color.hue).toStringAsFixed(0),
                                          value: _color.hue,
                                          min: 0.0,
                                          max: 360.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  'S',
                                ),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      activeTickMarkColor: Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      overlayColor: _color.toColor().withOpacity(0.33),
                                      thumbShape: ColorSliderThumbShape(_color.toColor()),
                                      showValueIndicator: ShowValueIndicator.always,
                                      valueIndicatorColor: _color.toColor(),
                                      valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: TextStyle(
                                        color: _getContrastingColor(_color.toColor()),
                                      )
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                              colors: [_color.withSaturation(0.0).toColor(), _color.withSaturation(1.0).toColor()], // whitish to gray
                                              tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: ValueSlider(
                                          onChanged: (value) {
                                            updateColorWith(s: value);
                                          },
                                          label: (_color.saturation * 255.0).toStringAsFixed(0),
                                          value: _color.saturation,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 40.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  'L',
                                ),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.transparent,
                                      inactiveTrackColor: Colors.transparent,
                                      activeTickMarkColor: Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      showValueIndicator: ShowValueIndicator.always,
                                      overlayColor: _color.toColor().withOpacity(0.33),
                                      thumbShape: ColorSliderThumbShape(_color.toColor()),
                                      valueIndicatorColor: _color.toColor(),
                                      valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: TextStyle(
                                        color: _getContrastingColor(_color.toColor()),
                                      )
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                              colors: [const Color(0xFF000000), _color.withLightness(0.5).toColor(), const Color(0xFFFFFFFF)], // whitish to gray
                                              tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: ValueSlider(
                                          onChanged: (value) {
                                            updateColorWith(l: value);
                                          },
                                          label: (_color.lightness * 255.0).toStringAsFixed(0),
                                          value: _color.lightness,
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
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      )
    );
  }
}


class _ColorPopupRoute extends PopupRoute<HSLColor> {
  _ColorPopupRoute({
    @required this.color,
    @required this.initialSize,
    @required this.position,
  }) {
    oldColor = color;
  }

  HSLColor color;
  HSLColor oldColor;
  final Size initialSize;
  final RelativeRect position;

  void _onPopupColorChanged(HSLColor newColor) {
    color = newColor;
  }

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
              onColorChanged: _onPopupColorChanged,
              initialSize: initialSize,
              parentAnimation: parentAnimation,
              onAccept: (color) => Navigator.pop(context, color),
              onCancel: () => Navigator.pop(context, oldColor),
            )
          );
        },
      ),
    );
  }
}

typedef ColorChangeCallback = void Function(Color);

class ColorMenuButton extends StatelessWidget {
  ColorMenuButton({
    Key key,
    this.active = false,
    this.onToggled,
    @required this.color,
    @required this.onColorChanged,
  }) : super(key: key);

  final Color color;
  final bool active;
  final ColorChangeCallback onColorChanged;
  final VoidCallback onToggled;

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
    HSLColor newColor = await Navigator.of(context).push(
      _ColorPopupRoute(
        color: HSLColor.fromColor(color),
        initialSize: button.size,
        position: position,
      )
    );

    if(newColor != null) {
      onColorChanged(newColor.toColor());
    }

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
    return SizedBox(
      height: _kButtonHeight,
      child: ToggleButton(
        splashColor: _getContrastingColor(color).withAlpha(50),
        highlightColor: _getContrastingColor(color).withAlpha(50),
        color: color,
        toggledColor: color,
        shadowColor: color,
        toggledElevation: 0,
        toggled: active,
        onToggle: (toggled) {
          if(toggled) { _showColorMenu(context); }
          else { onToggled(); }
        },
        child: Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            curve: Curves.ease,
            duration: Duration(milliseconds: 300),
            opacity: active ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.check, color: _getContrastingColor(color)),
            ),
          )
        )
      )
    );
  }
}