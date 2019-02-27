import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              Theme.of(context).iconTheme.color,
          ),
          child: icon
        ),
        color: Theme.of(context).unselectedWidgetColor,
        disabledColor: Theme.of(context).unselectedWidgetColor.withAlpha(125),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}