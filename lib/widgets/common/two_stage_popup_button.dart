import 'package:flutter/material.dart';
import 'package:project_pickle/widgets/common/transparent_routes.dart';
const double _kMenuScreenPadding = 8.0;

class _TwoStagePopupRouteLayout extends SingleChildLayoutDelegate {
  _TwoStagePopupRouteLayout(this.position);

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
  bool shouldRelayout(_TwoStagePopupRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class TwoStagePopupContent extends StatefulWidget {
  TwoStagePopupContent({
    Key key,
    @required this.child,
    @required this.headerContent,
    @required this.initialSize,
    @required this.parentAnimation,
    @required this.onAccept,
    @required this.onHeightUpdated,
  }) : super(key: key);

  final Widget child;
  final Widget headerContent;
  final ValueChanged<double> onHeightUpdated;
  final Size initialSize;
  final Animation<double> parentAnimation;
  final ValueChanged<HSLColor> onAccept;


  @override
  _TwoStagePopupContentState createState() => _TwoStagePopupContentState();
}

class _TwoStagePopupContentState extends State<TwoStagePopupContent> {


  final double _sliderTrackHeight = 12.0;

  @override
  void initState() {
    super.initState();
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
      end: Size(196.0, 156.0),
    ).animate(
      CurvedAnimation(
        parent: widget.parentAnimation,
        curve: Interval(
          0.0, 1.0,
          curve: Curves.ease,
        ),
      ),
    );
    size.addListener(() => widget.onHeightUpdated(size.value.height));

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
      width: (widget.initialSize.width < 100) ? size.value.width : widget.initialSize.width,
      child: Material(
        elevation: 0.0,
        animationDuration: Duration.zero,
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius.value,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: widget.initialSize.height,
              child: Material(
                elevation: 0.0,
                animationDuration: Duration.zero,
                color: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius.value,
                ),
                child: Padding(
              padding: const EdgeInsets.all(8.0),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.white,
                  ),
                  child: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      child: widget.headerContent
                  ),
                ),
              ),
              ),
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}


class _TwoStagePopupRoute extends TransparentPopupRoute<HSLColor> {
  _TwoStagePopupRoute({
    @required this.headerContent,
    @required this.initialSize,
    @required this.position,
    @required this.popupContent,
    @required this.onHeightUpdated,
  });

  final ValueChanged<double> onHeightUpdated;
  final Widget headerContent;
  final Widget popupContent;
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
              delegate: new _TwoStagePopupRouteLayout(
                position,
              ),
              child: TwoStagePopupContent(
                headerContent: headerContent,
                initialSize: initialSize,
                parentAnimation: parentAnimation,
                child: popupContent,
                onAccept: (newColor) {
                  Navigator.pop(context, newColor);
                },
                onHeightUpdated: onHeightUpdated,
              )
          );
        },
      ),
    );
  }
}

typedef ColorChangeCallback = void Function(HSLColor);

/// Creates a button that on first click toggles the button, and on second click
/// opens the popup menu for additional related options.
class TwoStagePopupButton extends StatefulWidget {
  TwoStagePopupButton({
    Key key,
    this.child,
    this.active = false,
    this.onToggled,
    @required this.popupContent,
  }) : super(key: key);

  final Widget child;
  final Widget popupContent;
  final bool active;
  final VoidCallback onToggled;

  _TwoStagePopupButtonState createState() => _TwoStagePopupButtonState();
}

class _TwoStagePopupButtonState extends State<TwoStagePopupButton> {
  double _height = 40.0;

  _showPopupMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    await Navigator.of(context).push(new _TwoStagePopupRoute(
      headerContent: widget.child,
      popupContent: widget.popupContent,
      initialSize: button.size,
      position: position,
      onHeightUpdated: (newHeight) {
        setState(() {
          _height = newHeight;
        });
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Material(
        color: (widget.active) ? Theme.of(context).highlightColor : Theme.of(context).buttonColor,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            if(!widget.active) {
              widget.onToggled();
            }
          },
          child: IgnorePointer(
            ignoring: !widget.active,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconTheme(
                  data: IconThemeData(
                    color: (widget.active) ? Colors.white : Theme.of(context).textTheme.button.color,
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: (widget.active) ? Colors.white : Theme.of(context).textTheme.button.color,
                    ),
                    child: widget.child
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                _showPopupMenu(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}