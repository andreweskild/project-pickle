import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    this.icon,
    this.isHighlighted = false,
    this.label,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  final Widget icon;
  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: new FlatButton(
        color: isHighlighted ? Theme.of(context).highlightColor : Colors.transparent,
        textColor: isHighlighted ? Theme.of(context).accentTextTheme.button.color : Colors.black,
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