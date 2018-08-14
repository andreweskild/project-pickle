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

  final _smallSizeWidth = 72.0;
  final _mediumSizeWidth = 128.0;
  final _largeSizeWidth = 224.0;

  @override
  void initState() {
    _minWidth = _smallSizeWidth;
    _maxWidth = _largeSizeWidth;
    _sizeMode = widget.sizeMode;
    _previousSizeMode = _sizeMode;
    _splitPos = widthFromSizeMode(_sizeMode);
    _dragPos = _splitPos;
    super.initState();
  }

  double widthFromSizeMode(DrawerSizeMode mode) {
    switch(mode) {
      case DrawerSizeMode.Small:
        return _smallSizeWidth;
        break;
      case DrawerSizeMode.Medium:
        return _mediumSizeWidth;
        break;
      case DrawerSizeMode.Large:
        return _largeSizeWidth;
        break;
      default:
        return _mediumSizeWidth;
    }
  }

  DrawerSizeMode sizeModeFromWidth(double width) {
    double distanceToSmall = (width - _smallSizeWidth).abs();
    double distanceToMedium = (width - _mediumSizeWidth).abs();
    double distanceToLarge = (width - _largeSizeWidth).abs();
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
        return _smallSizeWidth;
        break;
      case DrawerSizeMode.Medium:
        return _mediumSizeWidth;
        break;
      case DrawerSizeMode.Large:
        return _largeSizeWidth;
        break;
      default:
        return _mediumSizeWidth;
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
            padding: (widget.alignment == DrawerAlignment.start) ?
              const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0) :
              const EdgeInsets.fromLTRB(0.0, 12.0, 12.0, 12.0),
            width: widthFromSizeMode(_sizeMode),
            child: Material(
              elevation: 2.0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: Colors.black26,
                )
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
                    _dragPos = _splitPos;
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
                            color: _drawerDragging ? Colors.white : Colors.black26,
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