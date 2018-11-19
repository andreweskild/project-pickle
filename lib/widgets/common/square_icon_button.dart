import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Icon Button that shows a rounded background when [selected] is true
class SquareIconButton extends StatelessWidget {
  SquareIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: IconTheme(
          data: IconThemeData(
            color: onPressed == null ?
              Theme.of(context).disabledColor :
              Theme.of(context).accentIconTheme.color,
          ),
          child: icon
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}