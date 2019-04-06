import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:project_pickle/tangible/tangible.dart';

const double _kMenuScreenPadding = 12.0;
const double _kMenuItemSpacing = 12.0;
const double _kMenuWidth = 300.0;

const double _kButtonHeight = 56.0;

const double _kHeaderHeight = 72.0;

const double _kBlurAmount = 20.0;

class PopupContentItem extends StatelessWidget{
  PopupContentItem({
    @required this.child,
    this.height = 48.0,
    this.padding = const EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
  });

  final Widget child;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: child,
      ),
    );
  }
}

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
    @required this.popupContent,
    @required this.headerContent,
    @required this.initialSize,
    @required this.parentAnimation,
    @required this.onAccept,
  }) : super(key: key);

  final List<PopupContentItem> popupContent;
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

  double _getContentHeight(List<PopupContentItem> content, double spacing) {
    double finalHeight = 0;
    content.forEach(
      (item) => finalHeight += item.height + item.padding.top + item.padding.bottom
    );
    return finalHeight + 12.0; // add additional padding for top + bottom of popup
  }

  @override
  Widget build(BuildContext context) {
    final double _contentHeight = _getContentHeight(widget.popupContent, _kMenuItemSpacing);

    final Animation<Size> size = SizeTween(
      begin: widget.initialSize,
      end: Size(
        _kMenuWidth, 
        _contentHeight + _kHeaderHeight //1.0 for divider height
      ),
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

    final Animation<double> opacityAnim = Tween<double>(
      begin: 1.0,
      end: 0.0,
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

    final Animation<EdgeInsets> headerPadding = EdgeInsetsTween(
      begin: EdgeInsets.all(6.0),
      end: EdgeInsets.all(12.0),
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

    final Animation<double> headerHeight = Tween<double>(
      begin: _kButtonHeight,
      end: _kHeaderHeight,
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

    return SizedBox(
      height: size.value.height,
      width: size.value.width,
      child: Card(
        child: Column(
          children: <Widget>[
            CardHeader(
              height: headerHeight.value,
              child: Padding(
                padding: headerPadding.value,
                child: widget.headerContent
              ),
              onTap: widget.onAccept,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.popupContent.map<Widget>(
                              (item) {
                            return item;
                          }
                        ).toList(),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: FadeTransition(
                        opacity: opacityAnim,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).unselectedWidgetColor
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

typedef HeaderBuilder = Widget Function(BuildContext, Animation<double>);

class _TwoStagePopupRoute extends PopupRoute<VoidCallback> {
  _TwoStagePopupRoute({
    @required this.buttonContext,
    @required this.header,
    @required this.initialSize,
    @required this.popupContent,
  }) {
    completed.then((returnedCallback) { returnedCallback(); });
  }

  final BuildContext buttonContext;
  final Widget header;
  final Size initialSize;
  final List<PopupContentItem> popupContent;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => '';

  @override
  VoidCallback get currentResult => null;

  @override
  RouteSettings get settings => RouteSettings(name: '/popup-menu');

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
              popupContent: popupContent,
              onAccept: () => Navigator.pop(context),
            )
          );
        },
      ),
    );
  }
}

typedef _HeaderBuilder = Widget Function(bool);

/// Creates a button that on first click toggles the button, and on second click
/// opens the popup menu for additional related options.
class TwoStagePopupButton extends StatefulWidget {
  TwoStagePopupButton({
    Key key,
    @required this.headerContent,
    @required this.popupContent,
    this.active = false,
    this.color,
    this.icon,
    this.label,
    this.onToggled,
    this.toggledColor,
    this.toggledElevation = 6,
  }) : super(key: key);

  final bool active;
  final Color color;
  final _HeaderBuilder headerContent;
  final Widget icon;
  final Widget label;
  final VoidCallback onToggled;
  final List<PopupContentItem> popupContent;
  final Color toggledColor;
  final int toggledElevation;

  _TwoStagePopupButtonState createState() => _TwoStagePopupButtonState();
}

class _TwoStagePopupButtonState extends State<TwoStagePopupButton> {

  _showPopupMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject();
    await Navigator.of(context).push(new _TwoStagePopupRoute(
        initialSize: button.size,
        buttonContext: context,
        header: widget.headerContent(true),
        popupContent: widget.popupContent,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kButtonHeight,
      child: ToggleButton(
        color: widget.color,
        toggledColor: widget.toggledColor,
        toggled: widget.active,
        toggledElevation: widget.toggledElevation,
        onToggle: (toggled) {
          if (!toggled) {
            widget.onToggled();
          }
          else { _showPopupMenu(context); }
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: widget.headerContent(false),
        ),
      ),
    );
  }
}
