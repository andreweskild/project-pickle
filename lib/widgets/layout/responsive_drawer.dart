import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/color_selector/color_card.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_selector_card.dart';

typedef SizeModeChangeCallback = void Function(DrawerSizeMode sizeMode);

enum DrawerSizeMode {
  Small, Medium, Large,
}

class ResponsiveDrawer extends StatefulWidget {
  const ResponsiveDrawer({
    Key key,
    this.alignment = DrawerAlignment.start,
    this.child,
    this.sizeMode = DrawerSizeMode.Medium,
    this.onSizeModeChanged,
  }) : super(key: key);

  final DrawerAlignment alignment;
  final Widget child;
  final SizeModeChangeCallback onSizeModeChanged;
  final DrawerSizeMode sizeMode;

  _ResponsiveDrawerState createState() => _ResponsiveDrawerState();
}

class _ResponsiveDrawerState extends State<ResponsiveDrawer> {
  bool _drawerDragging = false;
  DrawerSizeMode _sizeMode;
  DrawerSizeMode _previousSizeMode;
  double _minWidth;
  double _maxWidth;
  double _splitPos;
  double _dragPos;

  @override
  void initState() {
    _minWidth = 64.0;
    _maxWidth = 200.0;
    _sizeMode = widget.sizeMode;
    _previousSizeMode = _sizeMode;
    _splitPos = widthFromSizeMode(_sizeMode);
    _dragPos = _splitPos;
    super.initState();
  }

  double widthFromSizeMode(DrawerSizeMode mode) {
    switch(mode) {
      case DrawerSizeMode.Small:
        return 64.0;
        break;
      case DrawerSizeMode.Medium:
        return 128.0;
        break;
      case DrawerSizeMode.Large:
        return 200.0;
        break;
      default:
        return 128.0;
    }
  }

  DrawerSizeMode sizeModeFromWidth(double width) {
    double distanceToSmall = (width - 64.0).abs();
    double distanceToMedium = (width - 148.0).abs();
    double distanceToLarge = (width - 200.0).abs();
    if(distanceToSmall < distanceToMedium
        && distanceToSmall < distanceToLarge) {
      return DrawerSizeMode.Small;
    }
    else if(distanceToMedium < distanceToSmall
        && distanceToMedium < distanceToLarge) {
      return DrawerSizeMode.Medium;
    }
    else if(distanceToLarge < distanceToSmall
        && distanceToLarge < distanceToMedium) {
      return DrawerSizeMode.Large;
    }
    else {
      return DrawerSizeMode.Medium;
    }
  }

  double getWidthOfNewSizeMode(double width) {
    switch(sizeModeFromWidth(width)) {
      case DrawerSizeMode.Small:
        return 64.0;
        break;
      case DrawerSizeMode.Medium:
        return 128.0;
        break;
      case DrawerSizeMode.Large:
        return 200.0;
        break;
      default:
        return 128.0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Stack(
      children: <Widget>[
        Align(
          alignment: (widget.alignment == DrawerAlignment.start) ? Alignment.topLeft : Alignment.topRight,
          child: AnimatedContainer(
            alignment: Alignment.centerLeft,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
            width: widthFromSizeMode(_sizeMode),
            child: Material(
              elevation: 0.0,
              color: Theme.of(context).cardColor,
              shape: Border(
                right: (widget.alignment == DrawerAlignment.start) ?
                BorderSide(
                  color: Colors.black38
                ) : BorderSide.none,
                left: (widget.alignment == DrawerAlignment.end) ?
                BorderSide(
                    color: Colors.black38
                ) : BorderSide.none,
              ),
              child: widget.child,
            ),
          ),
        ),
        Stack(
          children: <Widget> [
            Align(
              alignment: (widget.alignment == DrawerAlignment.start) ? Alignment.topLeft : Alignment.topRight,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  opacity: _drawerDragging ? 1.0 : 0.0,
                  child: Container(
                    width: _splitPos,
                    decoration: BoxDecoration(
                        color: Colors.black12
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: _drawerDragging ? 0 : 150),
              left: (widget.alignment == DrawerAlignment.start) ? 0.0 : null,
              right: (widget.alignment == DrawerAlignment.end) ? 0.0 : null,
              top: 0.0,
              bottom: 0.0,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                  opacity: _drawerDragging ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 150),
                    width: getWidthOfNewSizeMode(_splitPos),
                    decoration: BoxDecoration(
                        color: Colors.black12
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: (widget.alignment == DrawerAlignment.start) ? _splitPos : null,
              right: (widget.alignment == DrawerAlignment.end) ? _splitPos : null,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _drawerDragging = true;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    _drawerDragging = false;
                  });
                },
                onHorizontalDragStart: (details) {
                  setState(() {
                    _drawerDragging = true;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  if (widget.alignment == DrawerAlignment.start) {
                    _dragPos = _dragPos + details.delta.dx;
                  }
                  else {
                    _dragPos = _dragPos - details.delta.dx;
                  }
                  if(_dragPos <= _maxWidth
                      && _dragPos >= _minWidth) {
                    setState(() {
                      _splitPos = _dragPos;
                    });
                  }
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    _drawerDragging = false;
                    _sizeMode = sizeModeFromWidth(_splitPos);
                    _splitPos = widthFromSizeMode(_sizeMode);
                  });
                  if(_sizeMode != _previousSizeMode) {
                    widget.onSizeModeChanged(_sizeMode);
                    _previousSizeMode = _sizeMode;
                  }
                },
                child: AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  color: _drawerDragging ? Colors.black : Colors.transparent,
                  child: AnimatedPadding(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 50),
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                        child: AnimatedContainer(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 50),
                          height: (_drawerDragging) ? 10.0 : 24.0,
                          width: (_drawerDragging) ? 10.0 : 3.0,
                          decoration: BoxDecoration(
                            color: _drawerDragging ? Colors.white : Colors.black38,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ),
          ]
        )
      ]
    );
  }
}