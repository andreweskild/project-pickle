import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/color_selector/color_card.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_selector_card.dart';

typedef SizeModeChangeCallback = void Function(DrawerSizeMode sizeMode);

enum DrawerSizeMode {
  Small, Medium, Large,
}

/// A Drawer that can be resized to [DrawerSizeMode.Small], [DrawerSizeMode.Medium], or [DrawerSizeMode.Large]
///
/// The storage and management of state is mostly delegated to the
/// user of the class, using the [onSizeModeChanged] callback.
class ResizableDrawer extends StatefulWidget {
  const ResizableDrawer({
    Key key,
    this.alignment = DrawerAlignment.start,
    this.child,
    this.sizeMode = DrawerSizeMode.Medium,
    this.onSizeModeChanged,
  }) : super(key: key);

  /// The side the drawer is aligned to, determines placement of resize controls.
  final DrawerAlignment alignment;

  /// The [Widget] this Drawer contains.
  final Widget child;

  /// Called when the size mode is changed.
  final SizeModeChangeCallback onSizeModeChanged;

  /// The initial size mode when the drawer is created.
  final DrawerSizeMode sizeMode;

  _ResizableDrawerState createState() => _ResizableDrawerState();
}

class _ResizableDrawerState extends State<ResizableDrawer> {
  bool _drawerDragging = false;
  DrawerSizeMode _sizeMode;
  DrawerSizeMode _previousSizeMode;
  double _minWidth;
  double _maxWidth;
  double _splitPos;
  double _dragPos;

  final _smallSizeWidth = 64.0;
  final _mediumSizeWidth = 128.0;
  final _largeSizeWidth = 192.0;

  @override
  void initState() {
    _minWidth = _smallSizeWidth;
    _maxWidth = _largeSizeWidth;
    _sizeMode = widget.sizeMode;
    _previousSizeMode = _sizeMode;
    _splitPos = _widthFromSizeMode(_sizeMode);
    _dragPos = _splitPos;
    super.initState();
  }

  /// Returns the size to set the drawer when give [mode]
  double _widthFromSizeMode(DrawerSizeMode mode) {
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

  /// Returns size mode closest to [pos]
  DrawerSizeMode _nearestSizeMode(double pos) {
    double distanceToSmall = (pos - _smallSizeWidth).abs();
    double distanceToMedium = (pos - _mediumSizeWidth).abs();
    double distanceToLarge = (pos - _largeSizeWidth).abs();
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

  /// Returns new size of drawer from [pos].
  double _widthOfNewSizeMode(double pos) => _widthFromSizeMode(_nearestSizeMode(pos));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (widget.alignment == DrawerAlignment.start) ?
        const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0) :
        const EdgeInsets.fromLTRB(0.0, 12.0, 12.0, 12.0),
      child: Stack(
        children: <Widget>[

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
                      width: _splitPos + 18.0,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
//                          borderRadius: BorderRadius.only(
//                            topLeft: (widget.alignment == DrawerAlignment.start) ? Radius.circular(8.0) : Radius.zero,
//                            bottomLeft: (widget.alignment == DrawerAlignment.start) ? Radius.circular(8.0) : Radius.zero,
//                            topRight: (widget.alignment == DrawerAlignment.end) ? Radius.circular(8.0) : Radius.zero,
//                            bottomRight: (widget.alignment == DrawerAlignment.end) ? Radius.circular(8.0) : Radius.zero,
//                          )
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
                      _sizeMode = _nearestSizeMode(_splitPos);
                      _splitPos = _widthFromSizeMode(_sizeMode);
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
                    decoration: BoxDecoration(
                        color: _drawerDragging ? Colors.black87 : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: (widget.alignment == DrawerAlignment.end) ? Radius.circular(8.0) : Radius.zero,
                          bottomLeft: (widget.alignment == DrawerAlignment.end) ? Radius.circular(8.0) : Radius.zero,
                          topRight: (widget.alignment == DrawerAlignment.start) ? Radius.circular(8.0) : Radius.zero,
                          bottomRight: (widget.alignment == DrawerAlignment.start) ? Radius.circular(8.0) : Radius.zero,
                        )
                    ),
                    child: AnimatedPadding(
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                          child: AnimatedContainer(
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 200),
                            height: (_drawerDragging) ? 10.0 : 48.0,
                            width: (_drawerDragging) ? 10.0 : 4.0,
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
          ),
          Align(
            alignment: (widget.alignment == DrawerAlignment.start) ? Alignment.topLeft : Alignment.topRight,
            child: AnimatedContainer(
              alignment: Alignment.topLeft,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
              width: _widthFromSizeMode(_sizeMode),
              child: Material(
                elevation: 2.0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.black26,
                    )
                ),
                child: widget.child,
              ),
            ),
          ),
        ]
      ),
    );
  }
}