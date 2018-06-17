import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    this.onTap,
    this.icon,
    this.label,
    this.isActive = false,
  }) : super(key: key);

  final VoidCallback onTap;

  final Widget icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: new FlatButton(
        color: isActive ? Colors.amberAccent : Colors.transparent,
        padding: new EdgeInsets.all(8.0),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(6.0),
        ),
        child: new Row(
          children: <Widget>[
            icon,
            new Padding(
              padding: new EdgeInsets.only(left: 24.0),
              child: new Text(label),
            )
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}