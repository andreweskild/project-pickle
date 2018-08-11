import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/color_selector/color_card.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_selector_card.dart';

enum DrawerSizeMode {
  Small, Medium, Large,
}

class ResponsiveDrawer extends StatefulWidget {
  const ResponsiveDrawer({
    Key key,
    this.child,
    this.sizeMode = DrawerSizeMode.Medium,
  }) : super(key: key);

  final Widget child;

  final DrawerSizeMode sizeMode;

  _ResponsiveDrawerState createState() => _ResponsiveDrawerState();
}

class _ResponsiveDrawerState extends State<ResponsiveDrawer> {

  bool drawerDragging = false;
  DrawerSizeMode _sizeMode;
  double _minWidth;
  double _maxWidth;
  double splitPos;
  double dragPos;

  @override
  void initState() {
    _minWidth = 64.0;
    _maxWidth = 200.0;
    _sizeMode = widget.sizeMode;
    splitPos = widthFromSizeMode(_sizeMode);
    dragPos = splitPos;
    super.initState();
  }

  double widthFromSizeMode(DrawerSizeMode mode) {
    switch(mode) {
      case DrawerSizeMode.Small:
        return 64.0;
        break;
      case DrawerSizeMode.Medium:
        return 148.0;
        break;
      case DrawerSizeMode.Large:
        return 200.0;
        break;
      default:
        return 148.0;
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
        return 148.0;
        break;
      case DrawerSizeMode.Large:
        return 200.0;
        break;
      default:
        return 148.0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: AnimatedContainer(
            alignment: Alignment.centerLeft,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
            width: widthFromSizeMode(_sizeMode),
            child: Material(
              elevation: 0.0,
              color: Theme.of(context).cardColor,
              child: widget.child,
            ),
          ),
        ),
        Stack(
          children: <Widget> [
            Align(
              alignment: Alignment.topLeft,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  opacity: drawerDragging ? 1.0 : 0.0,
                  child: Container(
                    width: splitPos,
                    decoration: BoxDecoration(
                        color: Colors.black12
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: drawerDragging ? 0 : 150),
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                  opacity: drawerDragging ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 150),
                    width: getWidthOfNewSizeMode(splitPos),
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
              left: splitPos,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    drawerDragging = true;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    drawerDragging = false;
                  });
                },
                onHorizontalDragStart: (details) {
                  setState(() {
                    drawerDragging = true;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  dragPos = dragPos + details.delta.dx;
                  if(dragPos <= _maxWidth
                      && dragPos >= _minWidth) {
                    setState(() {
                      splitPos = dragPos;
                    });
                  }
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    drawerDragging = false;
                    _sizeMode = sizeModeFromWidth(splitPos);
                    splitPos = widthFromSizeMode(_sizeMode);
                  });
                },
                child: AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  color: drawerDragging ? Colors.black : Colors.black12,
                  child: AnimatedPadding(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 50),
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                        child: AnimatedContainer(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 50),
                          height: (drawerDragging) ? 10.0 : 24.0,
                          width: (drawerDragging) ? 10.0 : 3.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
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