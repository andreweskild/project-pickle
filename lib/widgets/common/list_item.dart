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
    return AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 150),
      height: isHighlighted ? 124.0 : 48.0,
      child: FlatButton(
        color: isHighlighted ? Theme.of(context).highlightColor : Colors.transparent,
        textColor: isHighlighted ? Theme.of(context).accentTextTheme.button.color : Colors.black,
        padding: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
//          side: BorderSide(
//            color: isHighlighted ? Theme.of(context).accentColor : Colors.transparent,
//            width: 2.0,
//          )
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