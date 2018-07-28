import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/list_item.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class LayerListModel {
  LayerListModel({
    this.layers,
    this.currentLayer,
    this.callback,
  });

  List<PixelCanvasLayer> layers;

  PixelCanvasLayer currentLayer;

  VoidCallback callback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layers.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! LayerListModel) return false;
    LayerListModel model = other;
    return (model.layers == layers);
  }
}

class LayersCard extends StatelessWidget {
  const LayersCard({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LayerListModel>(
      distinct: true,
      converter: (store) => LayerListModel(
        layers: store.state.layers,
        currentLayer: store.state.currentLayer,
        callback: () => store.dispatch(AddNewLayerAction('test ${store.state.layers.length}')),
      ),
      builder: (context, model) {
        return DrawerCard(
          alignment: DrawerAlignment.end,
          title: 'Layers',
          builder: (context, collapsed) {
            return Expanded(
              child: Stack(
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
                    children: model.layers.map(
                      (layer) => ListItem(
                        icon: SizedBox(
                          height: 48.0,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: layer.canvas
                          ),
                        ),
                        isHighlighted: (model.currentLayer == layer),
                        label: layer.name,
                        onTap: (){},
                      )
                    ).toList(),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.add, color: Colors.white,),
                        onPressed: model.callback,
                        mini: true,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        tooltip: 'Create New Layer',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}