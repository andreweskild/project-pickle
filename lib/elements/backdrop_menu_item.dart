import 'package:flutter/material.dart';

class BackdropMenuItem extends StatelessWidget {
  const BackdropMenuItem({
    Key key,
    this.onTap,
    this.icon,
    this.label,
  }) : super(key: key);

  final VoidCallback onTap;

  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: new FlatButton(
        padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
        child: new Row(
          children: <Widget>[
            icon,
            new Padding(
              padding: new EdgeInsets.only(left: 12.0),
              child: label,
            )
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}