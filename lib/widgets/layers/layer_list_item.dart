import 'package:flutter/material.dart';

class LayerListItem extends StatelessWidget {
  const LayerListItem({
    Key key,
    this.layerCanvas,
    this.selected = false,
    this.label,
    this.hidden = false,
    this.onAddAbove,
    this.onAddBelow,
    this.onTap,
    this.onToggleHidden,
  }) : super(key: key);

  final VoidCallback onTap;
  final VoidCallback onAddAbove;
  final VoidCallback onAddBelow;
  final VoidCallback onToggleHidden;

  final bool hidden;
  final Widget layerCanvas;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              elevation: selected ? 6.0 : 0.0,
              color: selected ? Theme
                  .of(context)
                  .buttonColor : Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Theme
                  .of(context)
                  .buttonColor
                  .withAlpha(128),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Stack(children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Transform.scale(
                            alignment: Alignment.topLeft,
                            scale: constraints.maxHeight / 32.0,
                            child: layerCanvas,
                          );
                        }
                      )
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: 40.0,
                top: 0.0,
                bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Center(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: selected
                              ? Theme
                              .of(context)
                              .accentTextTheme
                              .button
                              .color
                              : Theme
                              .of(context)
                              .textTheme
                              .button
                              .color,
                          fontWeight: FontWeight.w500,
                        )
                      )),
                )),
          ]),
          Positioned.fill(
            child: RaisedButton(
              color: Colors.transparent,
              elevation: 0.0,
              highlightElevation: 0.0,
              padding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: onTap,
            ),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: IconTheme(
                      data: IconThemeData(
                          color: selected
                              ? Theme
                              .of(context)
                              .accentIconTheme
                              .color
                              : Theme
                              .of(context)
                              .iconTheme
                              .color
                      ),
                      child: Icon(
                        (hidden) ? Icons.remove : Icons.remove_red_eye,
                        size: 20.0,
                      ),
                    ),
                    onPressed: onToggleHidden,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
