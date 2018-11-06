import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/common/toggle_button.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      child: StoreConnector<AppState, DrawerSizeMode>(
          converter: (store) => store.state.rightDrawerSizeMode,
          builder: (context, sizeMode) {
            return Stack(
              children: <Widget>[
                Material(
                  elevation: selected ? 6.0 : 0.0,
                  color: selected
                      ? Theme.of(context).buttonColor
                      : Theme.of(context).unselectedWidgetColor,
                  shadowColor: Theme.of(context).splashColor.withAlpha(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: selected
                          ? Theme.of(context).accentColor
                          : Theme.of(context).unselectedWidgetColor,
                      width: 2.0,
                    )
                  ),
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedContainer(
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 150),
                        width: 48.0,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Container(
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(
                                  color: (selected) ? Theme.of(context).accentColor : Theme.of(context).dividerColor,
                                  width: 2.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Transform.scale(
                                  alignment: Alignment.topLeft,
                                  scale: 48.0 / 32.0,
                                  child: layerCanvas,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 40.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: AnimatedOpacity(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 150),
                          opacity:
                              (sizeMode == DrawerSizeMode.Normal) ? 1.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Center(
                                child: Text(
                              label,
                              style: TextStyle(
                                color: selected
                                    ? Theme.of(context)
                                        .accentTextTheme
                                        .button
                                        .color
                                    : Theme.of(context)
                                        .textTheme
                                        .button
                                        .color,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ),
                        )),
                  ]),
                ),
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
                  child: IgnorePointer(
                    ignoring: (sizeMode != DrawerSizeMode.Normal),
                    child: AnimatedOpacity(
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 150),
                      opacity: (sizeMode == DrawerSizeMode.Normal) ? 1.0 : 0.0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ToggleButton(
                            child: Icon(
                              (hidden) ? Icons.remove : Icons.adjust,
                              color: Theme.of(context).accentTextTheme.button.color,
                            ),
                            toggled: hidden,
                            onToggled: (newValue) => onToggleHidden(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
