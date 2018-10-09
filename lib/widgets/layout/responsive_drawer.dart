import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef SizeModeChangeCallback = void Function(DrawerSizeMode sizeMode);

enum DrawerSizeMode {
  Mini,
  Normal,
}

/// A Drawer that can be resized.
///
/// The storage and management of state is mostly delegated to the
/// user of the class, using the [onSizeModeChanged] callback.
class ResizableDrawer extends StatefulWidget {
  const ResizableDrawer({
    Key key,
    this.alignment = DrawerAlignment.start,
    this.child,
    this.sizeMode = DrawerSizeMode.Normal,
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

  final _miniSizeWidth = 64.0;
  final _normalSizeWidth = 200.0;

  @override
  void initState() {
    _minWidth = _miniSizeWidth;
    _maxWidth = _normalSizeWidth + 10.0;
    _sizeMode = widget.sizeMode;
    _previousSizeMode = _sizeMode;
    _splitPos = _normalSizeWidth;
    _dragPos = _splitPos;
    super.initState();
  }

  DrawerSizeMode _sizeModeFromWidth(double width) {
    if ((width - _miniSizeWidth).abs() < (width - _normalSizeWidth).abs()) {
      return DrawerSizeMode.Mini;
    } else {
      return DrawerSizeMode.Normal;
    }
  }

  double widthFromSizeMode(DrawerSizeMode sizeMode) {
    if (sizeMode == DrawerSizeMode.Mini) {
      return _miniSizeWidth;
    } else {
      return _normalSizeWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
        alignment: (widget.alignment == DrawerAlignment.start)
            ? Alignment.topLeft
            : Alignment.topRight,
        child: AnimatedContainer(
          alignment: Alignment.topLeft,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
          width: _splitPos,
          child: Material(
            elevation: 3.0,
            color: Theme.of(context).cardColor,
            child: widget.child,
          ),
        ),
      ),
      Stack(children: <Widget>[
        Align(
          alignment: (widget.alignment == DrawerAlignment.start)
              ? Alignment.topLeft
              : Alignment.topRight,
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              curve: Curves.ease,
              duration: Duration(milliseconds: 150),
              opacity: _drawerDragging ? 1.0 : 0.0,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: Duration(milliseconds: (_drawerDragging) ? 0 : 150),
                width: _dragPos + 22.0,
                color: Colors.black54,
              ),
            ),
          ),
        ),
        Align(
          alignment: (widget.alignment == DrawerAlignment.start)
              ? Alignment.topLeft
              : Alignment.topRight,
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              curve: Curves.ease,
              duration: Duration(milliseconds: 150),
              opacity: _drawerDragging ? 1.0 : 0.0,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: Duration(milliseconds: 150),
                width: widthFromSizeMode(_sizeModeFromWidth(_dragPos)),
                color: Colors.black54,
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          curve: Curves.ease,
          duration: Duration(milliseconds: (_drawerDragging) ? 0 : 150),
          top: 0.0,
          bottom: 0.0,
          left: (widget.alignment == DrawerAlignment.start) ? _dragPos : null,
          right: (widget.alignment == DrawerAlignment.end) ? _dragPos : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
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
              var tempPos;
              if (widget.alignment == DrawerAlignment.start) {
                tempPos = _dragPos + details.delta.dx;
              } else {
                tempPos = _dragPos - details.delta.dx;
              }
              if (tempPos <= _maxWidth && tempPos >= _minWidth) {
                setState(() {
                  _dragPos = tempPos;
                  if (_sizeMode != _previousSizeMode) {
                    widget.onSizeModeChanged(_sizeMode);
                    _previousSizeMode = _sizeMode;
                  }
                  if (_sizeMode == DrawerSizeMode.Mini) {
                    _splitPos = _miniSizeWidth;
                  } else {
                    _splitPos = _normalSizeWidth;
                  }
                });
              }
            },
            onHorizontalDragEnd: (details) {
              setState(() {
                setState(() {
                  _sizeMode = _sizeModeFromWidth(_dragPos);
                  if (_sizeMode != _previousSizeMode) {
                    widget.onSizeModeChanged(_sizeMode);
                    _previousSizeMode = _sizeMode;
                  }
                  if (_sizeMode == DrawerSizeMode.Mini) {
                    _splitPos = _miniSizeWidth;
                  } else {
                    _splitPos = _normalSizeWidth;
                  }
                });
                _drawerDragging = false;
                _dragPos = _splitPos;
              });
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
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
                )),
              ),
            ),
          ),
        ),
      ]),
    ]);
  }
}
