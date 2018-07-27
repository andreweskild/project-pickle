import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutlineIconButton extends StatelessWidget {
  OutlineIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      padding: EdgeInsets.all(12.0),
      child: Icon(icon),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Colors.grey.shade400,
        )
      ),
    );
  }

}