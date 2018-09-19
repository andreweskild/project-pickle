import 'package:flutter/material.dart';

const double _kMenuScreenPadding = 8.0;

typedef PopupContentBuilder = Widget Function(BuildContext context, Animation<double> parentAnimation);

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

class PopupContent extends StatefulWidget {
  PopupContent({
    Key key,
    this.builder,
    @required this.initialSize,
    @required this.parentAnimation,
    @required this.onAccept,
  }) : super(key: key);

  final PopupContentBuilder builder;
  final Size initialSize;
  final Animation<double> parentAnimation;
  final VoidCallback onAccept;


  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {

  @override
  Widget build(BuildContext context) {
    final Animation<BorderRadius> borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(6.0),
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
      end: Size(200.0, 200.0),
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
      child: widget.builder(context, widget.parentAnimation),
    );
  }
}


class _PopupButtonRoute extends PopupRoute<Null> {
  _PopupButtonRoute({
    @required this.builder,
    @required this.initialSize,
    @required this.position,
  });

  final PopupContentBuilder builder;
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
  bool get opaque => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> forwardAnimation) {
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
              child: builder(context, animation),
          );
        },
      ),
    );
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
              child: PopupContent(
                builder: builder,
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


class PopupButton extends StatelessWidget {
  PopupButton({
    Key key,
    @required this.child,
    this.popupColor,
    @required this.popupBuilder,
  }) : super(key: key);

  final Widget child;
  final PopupContentBuilder popupBuilder;
  final Color popupColor;

  _showPopup(BuildContext context) async {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    await Navigator.of(context).push(new _PopupButtonRoute(
      builder: popupBuilder,
      initialSize: button.size,
      position: position,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 0.0,
      child: child,
      padding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: () => _showPopup(context),
    );
  }
}