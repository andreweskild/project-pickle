import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

//import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/tools/color_picker_tool.dart';
import 'package:project_pickle/widgets/color_selector/color_slider_thumb.dart';
import 'package:project_pickle/widgets/color_selector/color_slider_value_indicator.dart';
import 'package:project_pickle/widgets/common/toggle_button.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

const double _kMenuScreenPadding = 8.0;

class _ColorPickerModel {
  _ColorPickerModel({this.currentTool, this.callback});

  final BaseTool currentTool;
  final VoidCallback callback;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + currentTool.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! _ColorPickerModel) return false;
    _ColorPickerModel model = other;
    return (model.currentTool.runtimeType == currentTool.runtimeType);
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
    @required this.initialSize,
    @required this.parentAnimation,
    @required this.onAccept,
  }) : super(key: key);

  final HSLColor color;
  final Size initialSize;
  final Animation<double> parentAnimation;
  final ValueChanged<HSLColor> onAccept;


  @override
  _ColorPopupContentState createState() => _ColorPopupContentState();
}

class _ColorPopupContentState extends State<ColorPopupContent> {

  HSLColor _currentColor;

  final double _sliderTrackHeight = 12.0;

  @override
  void initState() {
    _currentColor = widget.color;
    super.initState();
  }

  void updateColorWith({double h, double s, double l}) {
    setState(() {
      if (h != null) _currentColor = _currentColor.withHue(h);
      if (s != null) _currentColor = _currentColor.withSaturation(s);
      if (l != null) _currentColor = _currentColor.withLightness(l);
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
      begin: BorderRadius.circular(8.0),
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
      end: Size(256.0, 156.0),
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
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              elevation: 6.0,
              animationDuration: Duration.zero,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius.value,
                side: BorderSide(color: Theme.of(context).dividerColor, width: 2.0),
              ),
              shadowColor: Colors.black26,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: widget.initialSize.height * 1.6, //stylistic decision to make color header 33% larger than color button.
                child: Material(
                  color: _currentColor.toColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius.value,
                    side: BorderSide(
                      width: 2.0,
                      color: Colors.black12,
                    ),
                  ),
                  child: Opacity(
                    opacity: opacity.value,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: 0.0,
                          top: 0.0,
                          bottom: 0.0,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FlatButton(
                                padding: EdgeInsets.all(0.0),
                                highlightColor: _getContrastingColor(_currentColor.toColor()).withAlpha(30),
                                splashColor: _getContrastingColor(_currentColor.toColor()).withAlpha(30),
                                child: Icon(
                                  Icons.check,
                                  color: _getContrastingColor(_currentColor.toColor()),
                                ),
                                onPressed: () => widget.onAccept(_currentColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          top: 0.0,
                          bottom: 0.0,
                          child: StoreConnector<AppState, _ColorPickerModel>(
                            converter: (store) => _ColorPickerModel(currentTool: store.state.currentTool, callback: () => store.dispatch(SetCurrentToolAction(ColorPickerTool(context)))),
                            builder: (context, model) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ToggleButton(
                                  activeColor: _getContrastingColor(_currentColor.toColor()).withAlpha(40),
                                  activeBorderColor: _getContrastingColor(_currentColor.toColor()).withAlpha(40),
                                  activeTextColor: _getContrastingColor(_currentColor.toColor()),
                                  inactiveColor: Colors.transparent,
                                  inactiveBorderColor: Colors.transparent,
                                  child: Icon(
                                    Icons.colorize,
                                  ),
                                  onToggled: (newValue) {
                                    Navigator.pop(context);
                                    model.callback();
                                  },
                                  toggled: model.currentTool is ColorPickerTool,
                                ),
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                child: Text('H'),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.transparent,
                                    inactiveTrackColor: Colors.transparent,
                                    thumbColor: _currentColor.withSaturation(1.0).withLightness(0.5).toColor(),
                                    thumbShape: ColorSliderThumbShape(),
                                    overlayColor: _currentColor.withAlpha(0.3).withSaturation(1.0).withLightness(0.5).toColor(),
                                    showValueIndicator: ShowValueIndicator.always,
                                    valueIndicatorColor: _currentColor.withSaturation(1.0).withLightness(0.5).toColor(),
                                    valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                    valueIndicatorTextStyle: TextStyle(
                                      color: _getContrastingColor(_currentColor.withSaturation(1.0).withLightness(0.5).toColor()),
                                    )
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0.0,
                                        top: 0.0,
                                        bottom: 0.0,
                                        right: 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Center(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints.expand(height: _sliderTrackHeight),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                                    colors: [const Color(0xFFFF0000), const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFF00FFFF), const Color(0xFF0000FF), const Color(0xFFFF00FF), const Color(0xFFFF0000)], // whitish to gray
                                                    tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                                  ),
                                                  borderRadius: BorderRadius.circular(_sliderTrackHeight / 2.0),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
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
                                          label: (_currentColor.hue).toStringAsFixed(0),
                                          value: _currentColor.hue,
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
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                child: Text('S'),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.transparent,
                                    inactiveTrackColor: Colors.transparent,
                                    overlayColor: _currentColor.toColor().withOpacity(0.33),
                                    thumbColor: _currentColor.toColor(),
                                    thumbShape: ColorSliderThumbShape(),
                                    showValueIndicator: ShowValueIndicator.always,
                                    valueIndicatorColor: _currentColor.toColor(),
                                    valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                    valueIndicatorTextStyle: TextStyle(
                                      color: _getContrastingColor(_currentColor.toColor()),
                                    )
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0.0,
                                        top: 0.0,
                                        bottom: 0.0,
                                        right: 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Center(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints.expand(height: _sliderTrackHeight),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                                    colors: [_currentColor.withSaturation(0.0).toColor(), _currentColor.withSaturation(1.0).toColor()], // whitish to gray
                                                    tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                                  ),
                                                  borderRadius: BorderRadius.circular(_sliderTrackHeight / 2.0),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
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
                                          label: (_currentColor.saturation * 255.0).toStringAsFixed(0),
                                          value: _currentColor.saturation,
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
                                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                child: Text('L'),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.transparent,
                                    inactiveTrackColor: Colors.transparent,
                                    showValueIndicator: ShowValueIndicator.always,
                                    overlayColor: _currentColor.toColor().withOpacity(0.33),
                                    thumbColor: _currentColor.toColor(),
                                    thumbShape: ColorSliderThumbShape(),
                                    valueIndicatorColor: _currentColor.toColor(),
                                    valueIndicatorShape: ColorSliderValueIndicatorShape(),
                                    valueIndicatorTextStyle: TextStyle(
                                      color: _getContrastingColor(_currentColor.toColor()),
                                    )
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0.0,
                                        top: 0.0,
                                        bottom: 0.0,
                                        right: 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Center(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints.expand(height: _sliderTrackHeight),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,// 10% of the width, so there are ten blinds.
                                                    colors: [const Color(0xFF000000), _currentColor.withLightness(0.5).toColor(), const Color(0xFFFFFFFF)], // whitish to gray
                                                    tileMode: TileMode.clamp, // repeats the gradient over the canvas
                                                  ),
                                                  borderRadius: BorderRadius.circular(_sliderTrackHeight / 2.0),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
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
                                          label: (_currentColor.lightness * 255.0).toStringAsFixed(0),
                                          value: _currentColor.lightness,
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
        ],
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
              onAccept: (newColor) {
                Navigator.pop(context, newColor);
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
    this.active = false,
    this.onToggled,
    @required this.color,
    @required this.onColorChanged,
  }) : super(key: key);

  final HSLColor color;
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
    final HSLColor newColor = await Navigator.of(context).push(new _ColorPopupRoute(
      color: color,
      initialSize: button.size,
      position: position,
    ));

    onColorChanged(newColor);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.toColor(),
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          if(!active) {
            onToggled();
          }
        },
        child: IgnorePointer(
          ignoring: !active,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(''),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => _showColorMenu(context),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: AnimatedContainer(
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 200),
                      foregroundDecoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black12,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: AnimatedOpacity(
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 200),
                              opacity: active ? 1.0 : 0.0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(Icons.check, size: 16.0, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}