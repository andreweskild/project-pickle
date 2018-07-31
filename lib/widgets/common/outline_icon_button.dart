import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutlineIconButton extends StatelessWidget {
  OutlineIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.highlighted = false,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: highlighted ? Theme.of(context).highlightColor : Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Icon(icon),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: highlighted ? Theme.of(context).accentColor : Colors.grey.shade400,
          )
      ),
    );
  }

}