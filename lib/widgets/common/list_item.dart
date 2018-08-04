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
  final Widget label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: FlatButton(
        color: isHighlighted ? Theme.of(context).highlightColor : Colors.transparent,
        textColor: isHighlighted ? Theme.of(context).accentTextTheme.button.color : Colors.black,
        padding: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: icon),
            Positioned(
              left: 24.0,
              top: 0.0,
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Center(child: label),
              ),
            )
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}