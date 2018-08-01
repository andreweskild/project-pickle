import 'package:flutter/material.dart';

class LayerListItem extends StatelessWidget {
  const LayerListItem({
    Key key,
    this.collapsed,
    this.icon,
    this.isHighlighted = false,
    this.label,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  final bool collapsed;
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
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: isHighlighted ? Theme.of(context).accentColor : Colors.transparent,
            width: collapsed ? 3.0 : 1.0,
          )
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