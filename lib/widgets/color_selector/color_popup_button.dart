//import 'dart:async';
//
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//
//import 'package:project_pickle/data_objects/hsl_color.dart';
//
//const Duration _kMenuDuration = Duration(milliseconds: 300);
//const double _kBaselineOffsetFromBottom = 20.0;
//const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
//const double _kMenuHorizontalPadding = 16.0;
//const double _kMenuItemHeight = 48.0;
//const double _kMenuDividerHeight = 16.0;
//const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
//const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
//const double _kMenuVerticalPadding = 8.0;
//const double _kMenuWidthStep = 56.0;
//const double _kMenuScreenPadding = 8.0;
//
//class _PopupMenu<T> extends StatelessWidget {
//  const _PopupMenu({
//    Key key,
//    this.route,
//    this.semanticLabel,
//  }) : super(key: key);
//
//  final _PopupMenuRoute<T> route;
//  final String semanticLabel;
//
//  @override
//  Widget build(BuildContext context) {
//    final double unit = 1.0 / (route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
//    final List<Widget> children = <Widget>[];
//
//    for (int i = 0; i < route.items.length; i += 1) {
//      final double start = (i + 1) * unit;
//      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
//      final CurvedAnimation opacity = new CurvedAnimation(
//          parent: route.animation,
//          curve: new Interval(start, end)
//      );
//      Widget item = route.items[i];
//      if (route.initialValue != null && route.items[i].represents(route.initialValue)) {
//        item = new Container(
//          color: Theme.of(context).highlightColor,
//          child: item,
//        );
//      }
//      children.add(new FadeTransition(
//        opacity: opacity,
//        child: item,
//      ));
//    }
//
//    final CurveTween opacity = new CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
//    final CurveTween width = new CurveTween(curve: new Interval(0.0, unit));
//    final CurveTween height = new CurveTween(curve: new Interval(0.0, unit * route.items.length));
//
//    final Widget child = new ConstrainedBox(
//        constraints: const BoxConstraints(
//          minWidth: _kMenuMinWidth,
//          maxWidth: _kMenuMaxWidth,
//        ),
//        child: new IntrinsicWidth(
//            stepWidth: _kMenuWidthStep,
//            child: new SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(
//                  vertical: _kMenuVerticalPadding
//              ),
//              child: new ListBody(children: children),
//            )
//        )
//    );
//
//    return new AnimatedBuilder(
//      animation: route.animation,
//      builder: (BuildContext context, Widget child) {
//        return new Opacity(
//          opacity: opacity.evaluate(route.animation),
//          child: new Material(
//            type: MaterialType.card,
//            elevation: route.elevation,
//            child: new Align(
//              alignment: AlignmentDirectional.topEnd,
//              widthFactor: width.evaluate(route.animation),
//              heightFactor: height.evaluate(route.animation),
//              child: new Semantics(
//                scopesRoute: true,
//                namesRoute: true,
//                explicitChildNodes: true,
//                label: semanticLabel,
//                child: child,
//              ),
//            ),
//          ),
//        );
//      },
//      child: child,
//    );
//  }
//}
//
//// Positioning of the menu on the screen.
//class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
//  _PopupMenuRouteLayout(this.position, this.selectedItemOffset, this.textDirection);
//
//  // Rectangle of underlying button, relative to the overlay's dimensions.
//  final RelativeRect position;
//
//  // The distance from the top of the menu to the middle of selected item.
//  //
//  // This will be null if there's no item to position in this way.
//  final double selectedItemOffset;
//
//  // Whether to prefer going to the left or to the right.
//  final TextDirection textDirection;
//
//  // We put the child wherever position specifies, so long as it will fit within
//  // the specified parent size padded (inset) by 8. If necessary, we adjust the
//  // child's position so that it fits.
//
//  @override
//  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
//    // The menu can be at most the size of the overlay minus 8.0 pixels in each
//    // direction.
//    return new BoxConstraints.loose(constraints.biggest - const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0));
//  }
//
//  @override
//  Offset getPositionForChild(Size size, Size childSize) {
//    // size: The size of the overlay.
//    // childSize: The size of the menu, when fully open, as determined by
//    // getConstraintsForChild.
//
//    // Find the ideal vertical position.
//    double y;
//    if (selectedItemOffset == null) {
//      y = position.top;
//    } else {
//      y = position.top + (size.height - position.top - position.bottom) / 2.0 - selectedItemOffset;
//    }
//
//    // Find the ideal horizontal position.
//    double x;
//    if (position.left > position.right) {
//      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
//      x = size.width - position.right - childSize.width;
//    } else if (position.left < position.right) {
//      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
//      x = position.left;
//    } else {
//      // Menu button is equidistant from both edges, so grow in reading direction.
//      assert(textDirection != null);
//      switch (textDirection) {
//        case TextDirection.rtl:
//          x = size.width - position.right - childSize.width;
//          break;
//        case TextDirection.ltr:
//          x = position.left;
//          break;
//      }
//    }
//
//    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
//    // edge of the screen in every direction.
//    if (x < _kMenuScreenPadding)
//      x = _kMenuScreenPadding;
//    else if (x + childSize.width > size.width - _kMenuScreenPadding)
//      x = size.width - childSize.width - _kMenuScreenPadding;
//    if (y < _kMenuScreenPadding)
//      y = _kMenuScreenPadding;
//    else if (y + childSize.height > size.height - _kMenuScreenPadding)
//      y = size.height - childSize.height - _kMenuScreenPadding;
//    return new Offset(x, y);
//  }
//
//  @override
//  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
//    return position != oldDelegate.position;
//  }
//}
//
//class _PopupMenuRoute<T> extends PopupRoute<T> {
//  _PopupMenuRoute({
//    this.position,
//    this.items,
//    this.initialValue,
//    this.elevation,
//    this.theme,
//    this.barrierLabel,
//    this.semanticLabel,
//  });
//
//  final RelativeRect position;
//  final List<PopupMenuEntry<T>> items;
//  final dynamic initialValue;
//  final double elevation;
//  final ThemeData theme;
//  final String semanticLabel;
//
//  @override
//  Animation<double> createAnimation() {
//    return new CurvedAnimation(
//        parent: super.createAnimation(),
//        curve: Curves.linear,
//        reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd)
//    );
//  }
//
//  @override
//  Duration get transitionDuration => _kMenuDuration;
//
//  @override
//  bool get barrierDismissible => true;
//
//  @override
//  Color get barrierColor => null;
//
//  @override
//  final String barrierLabel;
//
//  @override
//  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//    double selectedItemOffset;
//    if (initialValue != null) {
//      double y = _kMenuVerticalPadding;
//      for (PopupMenuEntry<T> entry in items) {
//        if (entry.represents(initialValue)) {
//          selectedItemOffset = y + entry.height / 2.0;
//          break;
//        }
//        y += entry.height;
//      }
//    }
//
//    Widget menu = new _PopupMenu<T>(route: this, semanticLabel: semanticLabel);
//    if (theme != null)
//      menu = new Theme(data: theme, child: menu);
//
//    return new MediaQuery.removePadding(
//      context: context,
//      removeTop: true,
//      removeBottom: true,
//      removeLeft: true,
//      removeRight: true,
//      child: new Builder(
//        builder: (BuildContext context) {
//          return new CustomSingleChildLayout(
//            delegate: new _PopupMenuRouteLayout(
//              position,
//              selectedItemOffset,
//              Directionality.of(context),
//            ),
//            child: menu,
//          );
//        },
//      ),
//    );
//  }
//}
//
//
///// Signature for the callback invoked when a menu item is selected. The
///// argument is the value of the [PopupMenuItem] that caused its menu to be
///// dismissed.
/////
///// Used by [PopupMenuButton.onSelected].
//typedef void PopupMenuItemSelected<T>(T value);
//
///// Signature for the callback invoked when a [PopupMenuButton] is dismissed
///// without selecting an item.
/////
///// Used by [PopupMenuButton.onCanceled].
//typedef void PopupMenuCanceled();
//
///// Signature used by [PopupMenuButton] to lazily construct the items shown when
///// the button is pressed.
/////
///// Used by [PopupMenuButton.itemBuilder].
//typedef List<PopupMenuEntry<T>> PopupMenuItemBuilder<T>(BuildContext context);
//
///// Displays a menu when pressed and calls [onSelected] when the menu is dismissed
///// because an item was selected. The value passed to [onSelected] is the value of
///// the selected menu item.
/////
///// One of [child] or [icon] may be provided, but not both. If [icon] is provided,
///// then [PopupMenuButton] behaves like an [IconButton].
/////
///// If both are null, then a standard overflow icon is created (depending on the
///// platform).
/////
///// ## Sample code
/////
///// This example shows a menu with four items, selecting between an enum's
///// values and setting a `_selection` field based on the selection.
/////
///// ```dart
///// // This is the type used by the popup menu below.
///// enum WhyFarther { harder, smarter, selfStarter, tradingCharter }
/////
///// // This menu button widget updates a _selection field (of type WhyFarther,
///// // not shown here).
///// new PopupMenuButton<WhyFarther>(
/////   onSelected: (WhyFarther result) { setState(() { _selection = result; }); },
/////   itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
/////     const PopupMenuItem<WhyFarther>(
/////       value: WhyFarther.harder,
/////       child: const Text('Working a lot harder'),
/////     ),
/////     const PopupMenuItem<WhyFarther>(
/////       value: WhyFarther.smarter,
/////       child: const Text('Being a lot smarter'),
/////     ),
/////     const PopupMenuItem<WhyFarther>(
/////       value: WhyFarther.selfStarter,
/////       child: const Text('Being a self-starter'),
/////     ),
/////     const PopupMenuItem<WhyFarther>(
/////       value: WhyFarther.tradingCharter,
/////       child: const Text('Placed in charge of trading charter'),
/////     ),
/////   ],
///// )
///// ```
/////
///// See also:
/////
/////  * [PopupMenuItem], a popup menu entry for a single value.
/////  * [PopupMenuDivider], a popup menu entry that is just a horizontal line.
/////  * [CheckedPopupMenuItem], a popup menu item with a checkmark.
/////  * [showMenu], a method to dynamically show a popup menu at a given location.
//class ColorPopupButton<T> extends StatefulWidget {
//  /// Creates a button that shows a popup menu.
//  ///
//  /// The [itemBuilder] argument must not be null.
//  const ColorPopupButton({
//    Key key,
//    @required this.itemBuilder,
//    this.initialValue,
//    this.onSelected,
//    this.onCanceled,
//    this.tooltip,
//    this.elevation = 8.0,
//    this.padding = const EdgeInsets.all(8.0),
//    this.child,
//    this.icon,
//  }) : assert(itemBuilder != null),
//        assert(!(child != null && icon != null)), // fails if passed both parameters
//        super(key: key);
//
//  /// Called when the button is pressed to create the items to show in the menu.
//  final PopupMenuItemBuilder<T> itemBuilder;
//
//  /// The value of the menu item, if any, that should be highlighted when the menu opens.
//  final T initialValue;
//
//  /// Called when the user selects a value from the popup menu created by this button.
//  ///
//  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
//  /// called instead.
//  final PopupMenuItemSelected<T> onSelected;
//
//  /// Called when the user dismisses the popup menu without selecting an item.
//  ///
//  /// If the user selects a value, [onSelected] is called instead.
//  final PopupMenuCanceled onCanceled;
//
//  /// Text that describes the action that will occur when the button is pressed.
//  ///
//  /// This text is displayed when the user long-presses on the button and is
//  /// used for accessibility.
//  final String tooltip;
//
//  /// The z-coordinate at which to place the menu when open. This controls the
//  /// size of the shadow below the menu.
//  ///
//  /// Defaults to 8, the appropriate elevation for popup menus.
//  final double elevation;
//
//  /// Matches IconButton's 8 dps padding by default. In some cases, notably where
//  /// this button appears as the trailing element of a list item, it's useful to be able
//  /// to set the padding to zero.
//  final EdgeInsetsGeometry padding;
//
//  /// If provided, the widget used for this button.
//  final Widget child;
//
//  /// If provided, the icon used for this button.
//  final Icon icon;
//
//  @override
//  _ColorPopupButtonState<T> createState() => new _ColorPopupButtonState<T>();
//}
//
//class _ColorPopupButtonState<T> extends State<ColorPopupButton<T>> {
//  void showButtonMenu() {
//    final RenderBox button = context.findRenderObject();
//    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
//    final RelativeRect position = new RelativeRect.fromRect(
//      new Rect.fromPoints(
//        button.localToGlobal(Offset.zero, ancestor: overlay),
//        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
//      ),
//      Offset.zero & overlay.size,
//    );
//    showMenu<T>(
//      context: context,
//      elevation: widget.elevation,
//      items: widget.itemBuilder(context),
//      initialValue: widget.initialValue,
//      position: position,
//    )
//        .then<void>((T newValue) {
//      if (!mounted)
//        return null;
//      if (newValue == null) {
//        if (widget.onCanceled != null)
//          widget.onCanceled();
//        return null;
//      }
//      if (widget.onSelected != null)
//        widget.onSelected(newValue);
//    });
//  }
//
//  Icon _getIcon(TargetPlatform platform) {
//    assert(platform != null);
//    switch (platform) {
//      case TargetPlatform.android:
//      case TargetPlatform.fuchsia:
//        return const Icon(Icons.more_vert);
//      case TargetPlatform.iOS:
//        return const Icon(Icons.more_horiz);
//    }
//    return null;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return RaisedButton(
//      onPressed: () async {
//        await Navigator.push(context, new _PopupMenuRoute<T>(
//          position: position,
//          items: items,
//          initialValue: initialValue,
//          elevation: elevation,
//          semanticLabel: label,
//          theme: Theme.of(context, shadowThemeOnly: true),
//          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//        ));
//    );
//  }
//}