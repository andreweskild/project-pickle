import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Icon Button that shows a rounded background when [selected] is true
class ToggleButton extends StatelessWidget {
  ToggleButton({
    Key key,
    @required this.child,
    @required this.toggled,
    @required this.onToggled,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.activeBorderColor,
    this.inactiveBorderColor,
  }) : super(key: key);

  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color activeBorderColor;
  final Color inactiveBorderColor;
  final Widget child;
  final ValueChanged<bool> onToggled;
  final bool toggled;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: FlatButton(
        color: toggled ? activeColor ?? Theme.of(context).highlightColor : inactiveColor ?? Theme.of(context).scaffoldBackgroundColor,
        textColor: toggled ? activeTextColor ?? Theme.of(context).accentTextTheme.button.color : inactiveTextColor ?? Colors.black,
        child: child,
        padding: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: toggled ? activeBorderColor ?? Theme.of(context).accentColor : inactiveBorderColor ?? Colors.black.withAlpha(15), width: 2.0)
        ),
        onPressed: () => onToggled(!toggled),
      ),
    );
  }
}