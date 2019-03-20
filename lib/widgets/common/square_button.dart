import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SquareButton extends StatelessWidget {
  SquareButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color,
    this.splashColor,
    this.highlightColor,
  }) : super(key: key);

  final Color color;
  final Color splashColor;
  final Color highlightColor;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 64.0,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: child,
        color: color ?? Theme.of(context).unselectedWidgetColor,
        colorBrightness: Theme.of(context).brightness,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}