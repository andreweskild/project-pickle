import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SquareButton extends StatelessWidget {
  SquareButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  final Color color;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 64.0,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: child,
        colorBrightness: Theme.of(context).brightness,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
        onPressed: onPressed,
      ),
    );
  }
}