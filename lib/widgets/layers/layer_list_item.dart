import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

class LayerListItem extends StatelessWidget {
  const LayerListItem({
    Key key,
    this.layerCanvas,
    this.selected = false,
    this.label,
    this.onAddAbove,
    this.onAddBelow,
    this.onTap,
    this.sizeMode,
  }) : super(key: key);

  final VoidCallback onTap;
  final VoidCallback onAddAbove;
  final VoidCallback onAddBelow;

  final Widget layerCanvas;
  final String label;
  final bool selected;
  final DrawerSizeMode sizeMode;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.only(left: 12.0, top: 6.0, bottom: 6.0, right: 12.0),
      onPressed: onTap,
      color: (selected) ? Theme.of(context).highlightColor : Colors.transparent,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: (sizeMode == DrawerSizeMode.Large) ? 64.0 : null,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Material(
                  elevation: 0.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(
                      color: selected ? Theme.of(context).accentColor : Colors.black38,
                      width: selected ? 3.0 : 1.0,
                    ),
                  ),
                  child: Transform.scale(
                    alignment: Alignment.topLeft,
                    scale: (sizeMode == DrawerSizeMode.Large) ? 64.0 / 32.0 :
                            (sizeMode == DrawerSizeMode.Medium) ? 104.0 /32.0 : 40.0 / 32.0,
                    child: layerCanvas,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 64.0, top: 0.0, bottom: 0.0,
            child: AnimatedOpacity(
              curve: Curves.ease,
              duration: Duration(milliseconds: 150),
              opacity: (sizeMode == DrawerSizeMode.Large) ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Center(child: Text(label)),
              ),
            )
          ),
          Positioned(
            right: 0.0, top: 0.0, bottom: 0.0,
            child: AnimatedOpacity(
              curve: Curves.ease,
              duration: Duration(milliseconds: 150),
              opacity: (sizeMode == DrawerSizeMode.Large) ? 1.0 : 0.0,
              child: Center(
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.adjust),
                  onPressed: (){},
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}