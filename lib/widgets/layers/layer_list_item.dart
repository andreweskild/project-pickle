import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

class LayerListItem extends StatefulWidget {
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

  _LayerListItemState createState() => _LayerListItemState();
}

class _LayerListItemState extends State<LayerListItem> {
  Store<AppState> _store;
  StreamSubscription<AppState> _subscription;
  DrawerSizeMode _sizeMode;

  void _prebuildInit(BuildContext context) {
    if(_store == null) {
      _store = StoreProvider.of<AppState>(context);
      _subscription = _store.onChange.listen(
        (state) {
          if(_sizeMode != state.rightDrawerSizeMode) {
            setState(() {
              _sizeMode = state.rightDrawerSizeMode;
            });
          }
        }
      );
    }

    if(_sizeMode == null) {
      _sizeMode = _store.state.rightDrawerSizeMode;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _prebuildInit(context);

    return FlatButton(
      padding: const EdgeInsets.only(left: 12.0, top: 6.0, bottom: 6.0, right: 12.0),
      onPressed: widget.onTap,
      color: (widget.selected) ? Theme.of(context).highlightColor : Colors.transparent,
      child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: Duration(milliseconds: 150),
                width: (_sizeMode == DrawerSizeMode.Large) ? 64.0 : 124.0,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Material(
                    elevation: 0.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: widget.selected ? Theme.of(context).accentColor : Colors.black38,
                        width: widget.selected ? 3.0 : 1.0,
                      ),
                    ),
                    child: Transform.scale(
                      alignment: Alignment.topLeft,
                      scale: (_sizeMode == DrawerSizeMode.Large) ? 64.0 / 32.0 :
                      (_sizeMode == DrawerSizeMode.Medium) ? 104.0 /32.0 : 40.0 / 32.0,
                      child: widget.layerCanvas,
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
                  opacity: (_sizeMode == DrawerSizeMode.Large) ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Center(child: Text(widget.label)),
                  ),
                )
            ),
            Positioned(
              right: 0.0, top: 0.0, bottom: 0.0,
              child: IgnorePointer(
                ignoring: (_sizeMode != DrawerSizeMode.Large),
                child: AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  opacity: (_sizeMode == DrawerSizeMode.Large) ? 1.0 : 0.0,
                  child: Center(
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      icon: Icon(Icons.adjust),
                      onPressed: (){},
                    ),
                  ),
                ),
              ),
            )
          ]
      ),
    );
  }
}