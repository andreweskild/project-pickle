import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SquareIconButton extends StatelessWidget {
  SquareIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    bool _buttonIsDisabled = onPressed == null;

    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
        opacity: _buttonIsDisabled ? 0.5 : 1.0,
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          child: IconTheme(
            data: IconThemeData(
              color: color ?? Theme.of(context).iconTheme.color,
            ),
            child: icon
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: color,
            )
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}