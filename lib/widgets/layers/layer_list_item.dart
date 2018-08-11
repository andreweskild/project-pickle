import 'package:flutter/material.dart';

class LayerListItem extends StatelessWidget {
  const LayerListItem({
    Key key,
    this.layerCanvas,
    this.selected = false,
    this.label,
    this.onAddAbove,
    this.onAddBelow,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  final VoidCallback onAddAbove;
  final VoidCallback onAddBelow;

  final Widget layerCanvas;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
//          AnimatedContainer(
//            color: Theme.of(context).highlightColor,
//            curve: Curves.ease,
//            duration: Duration(milliseconds: 100),
//            height: (selected) ? 40.0 : 0.0,
//            padding: const EdgeInsets.all(0.0),
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: IconButton(
//                icon: Icon(Icons.add),
//                onPressed: onAddAbove,
//              ),
//            ),
//          ),
        AnimatedPadding(
          curve: Curves.ease,
          duration: Duration(milliseconds: 150),
          padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 12.0, right: 12.0),
          child: RaisedButton(
            elevation: 2.0,
            padding: const EdgeInsets.only(top: 0.0),
            onPressed: onTap,
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Transform.scale(
                alignment: Alignment.topLeft,
                scale: 124.0 / 32.0,
                child: layerCanvas,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(
                color: selected ? Theme.of(context).accentColor : Colors.black38,
                width: selected ? 3.0 : 1.0,
              ),
            )
          ),
        ),
//          AnimatedContainer(
//            color: Theme.of(context).highlightColor,
//            curve: Curves.ease,
//            duration: Duration(milliseconds: 100),
//            height: (selected) ? 40.0 : 0.0,
//            padding: const EdgeInsets.all(0.0),
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: IconButton(
//                icon: Icon(Icons.add),
//                onPressed: onAddBelow,
//              ),
//            ),
//          ),
      ]
    );
  }
}