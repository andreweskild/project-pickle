import 'package:flutter/material.dart';

class LayerListItem extends StatelessWidget {
  const LayerListItem({
    Key key,
    this.collapsed,
    this.layerCanvas,
    this.selected = false,
    this.label,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  final bool collapsed;
  final Widget layerCanvas;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: selected ? Colors.grey.shade200 : Colors.grey.shade100,
        elevation: 0.0,
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
            leading: AnimatedContainer(
              curve: Curves.ease,
              duration: Duration(milliseconds: 150),
              height: (collapsed) ? 96.0 : 56.0,
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    child: AnimatedContainer(
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 150),
                        transform: (collapsed) ? Matrix4.diagonal3Values(96.0 / 32.0, 96.0 / 32.0, 96.0 / 32.0) :
                        Matrix4.diagonal3Values(48.0 / 32.0, 48.0 / 32.0, 48.0 / 32.0),
                        child: layerCanvas,
                    ),
                  ),
              ),
            ),
            title: Text(
              label,
              style: TextStyle(
                inherit: true,
                fontWeight: (selected) ? FontWeight.bold : FontWeight.normal,
              )
            ),
            enabled: true,
            selected: selected,
            onTap: onTap
          )
//      child: FlatButton(
//        color: isHighlighted ? Theme.of(context).highlightColor : Colors.transparent,
//        textColor: isHighlighted ? Theme.of(context).accentTextTheme.button.color : Colors.black,
//        padding: EdgeInsets.all(0.0),
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(12.0),
//          side: BorderSide(
//            color: isHighlighted && collapsed ? Theme.of(context).accentColor : Colors.transparent,
//            width: collapsed ? 3.0 : 1.0,
//          )
//        ),
//        child: Stack(
//          children: <Widget>[
//            Align(alignment: Alignment.centerLeft, child: icon),
//            Positioned(
//              left: 24.0,
//              top: 0.0,
//              bottom: 0.0,
//              child: Padding(
//                padding: const EdgeInsets.only(left: 12.0),
//                child: Center(child: label),
//              ),
//            )
//          ],
//        ),
//        onPressed: onTap,
//      ),
    );
  }
}