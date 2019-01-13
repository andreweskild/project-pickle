import 'package:flutter/material.dart';

const double _kMenuScreenPadding = 0.0;

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
    return new BoxConstraints.loose(constraints.biggest -
        const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0));
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
  }) : super(key: key);

  final Widget child;
  final Widget headerContent;
  final Size initialSize;
  final Animation<double> parentAnimation;
  final VoidCallback onAccept;

  @override
  _TwoStagePopupContentState createState() => _TwoStagePopupContentState();
}

class _TwoStagePopupContentState extends State<TwoStagePopupContent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Size> size = SizeTween(
      begin: widget.initialSize,
      end: Size(256.0, 114.0),
    ).animate(
      CurvedAnimation(
        parent: widget.parentAnimation,
        curve: Interval(
          0.0,
          1.0,
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
          0.2,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    return SizedBox(
      height: size.value.height,
      width: size.value.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Material(
              elevation: 6.0,
              animationDuration: Duration.zero,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.black26,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: widget.initialSize.height,
                  child: Material(
                    color: Theme.of(context).buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0),),
                    ),
                    child: InkWell(
                      onTap: widget.onAccept,
                      borderRadius: BorderRadius.circular(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            IconTheme(
                              data: IconThemeData(
                                color: Theme.of(context).accentTextTheme.button.color,
                              ),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Theme.of(context).accentTextTheme.button.color,
                                ),
                                child: widget.headerContent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Opacity(
                  opacity: opacity.value,
                  child: widget.child)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef HeaderBuilder = Widget Function(BuildContext, Animation<double>);

class _TwoStagePopupRoute extends PopupRoute<bool> {
  _TwoStagePopupRoute({
    @required this.buttonContext,
    @required this.header,
    @required this.initialSize,
    @required this.popupContent,
  });

  final BuildContext buttonContext;
  final Widget header;
  final Size initialSize;
  final Widget popupContent;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => '';

  @override
  bool get currentResult => false;

  @override
  RouteSettings get settings => RouteSettings(name: '/tool-options');

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> forwardAnimation) {
    return SizedBox();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> forwardAnimation, Widget child) {
    final Animation<double> parentAnimation =
        new CurvedAnimation(parent: animation, curve: Curves.ease);

    final RenderBox button = buttonContext.findRenderObject();
    final RenderBox overlay =
        Overlay.of(buttonContext).context.findRenderObject();
    final RelativeRect buttonPosition = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
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
                buttonPosition,
              ),
              child: TwoStagePopupContent(
                headerContent: header,
                initialSize: initialSize,
                parentAnimation: parentAnimation,
                child: popupContent,
                onAccept: () => Navigator.pop(context),
              ));
        },
      ),
    );
  }
}

/// Creates a button that on first click toggles the button, and on second click
/// opens the popup menu for additional related options.
class TwoStagePopupButton extends StatefulWidget {
  TwoStagePopupButton({
    Key key,
    this.icon,
    this.label,
    this.active = false,
    this.onToggled,
    @required this.popupContent,
  }) : super(key: key);

  final Widget icon;
  final Widget label;
  final Widget popupContent;
  final bool active;
  final VoidCallback onToggled;

  _TwoStagePopupButtonState createState() => _TwoStagePopupButtonState();
}

class _TwoStagePopupButtonState extends State<TwoStagePopupButton> {
  double _height = 40.0;
  bool _opened = false;

  _showPopupMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject();
    _opened = true;
    _opened = await Navigator.of(context).push(new _TwoStagePopupRoute(
        initialSize: button.size,
        buttonContext: context,
        header: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
              child: widget.icon,
            ),
            Expanded(
              child: widget.label,
            )
          ]
        ),
        popupContent: widget.popupContent,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedOpacity(
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
              opacity: widget.active ? 1.0 : 0.0,
              child: Material(
                elevation: 6.0,
                shadowColor: Theme.of(context).buttonColor.withAlpha(
                  Theme.of(context).brightness == Brightness.dark ? 255 : 128
                ),
                color: Theme.of(context).buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          FlatButton(
            color: Colors.transparent,
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              if (!widget.active) {
                Navigator.of(context)
                    .popUntil((route) => route.settings.name != '/tool-options');
                widget.onToggled();
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IgnorePointer(
              ignoring: !widget.active,
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      IconTheme(
                        data: IconThemeData(
                          color: (widget.active)
                              ? Theme.of(context).accentTextTheme.button.color
                              : Theme.of(context).textTheme.button.color,
                        ),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: (widget.active)
                                ? Theme.of(context).accentTextTheme.button.color
                                : Theme.of(context).textTheme.button.color,
                          ),
                          child: Center(child: widget.icon),
                        ),
                      ),
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  _showPopupMenu(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
