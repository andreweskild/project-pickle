import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layer_list_item.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

typedef SetLayerIndexCallback = void Function(int);
typedef AddLayerCallback = void Function(int);

class LayerListModel {
  LayerListModel({
    this.layers,
    this.currentLayerIndex,
    this.addLayerCallback,
    this.setLayerCallback,
  }) {
    layerCount = layers.length;
  }

  List<PixelCanvasLayer> layers;

  int currentLayerIndex;
  int layerCount;

  AddLayerCallback addLayerCallback;
  SetLayerIndexCallback setLayerCallback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layerCount.hashCode;
    result = 37 * result + currentLayerIndex.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! LayerListModel) return false;
    LayerListModel model = other;
    return (model.layerCount == layerCount &&
            model.currentLayerIndex == currentLayerIndex);
  }
}

class LayersCard extends StatelessWidget {
  const LayersCard({
    Key key,
    @required this.sizeMode,
  }) : super(key: key);

  final DrawerSizeMode sizeMode;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LayerListModel>(
      distinct: true,
      converter: (store) => LayerListModel(
        layers: store.state.layers,
        currentLayerIndex: store.state.currentLayerIndex,
        addLayerCallback: (index) => store.dispatch(AddNewLayerAction('Layer ${store.state.layers.length + 1}', index)),
        setLayerCallback: (index) => store.dispatch(SetCurrentLayerIndexAction(index)),
      ),
      builder: (context, model) {
            return Material(
              color: Colors.grey.shade200,
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 1.0,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                      children: List<Widget>.generate(
                        model.layers.length,
                        (index) {
                          int reversedIndex = model.layers.length - 1 - index;
                          return LayerListItem(
                            layerCanvas: model.layers[reversedIndex].canvas,
                            selected: (model.currentLayerIndex == reversedIndex),
                            sizeMode: sizeMode,
                            label: model.layers[reversedIndex].name,
                            onTap:() => model.setLayerCallback(reversedIndex),
                            onAddAbove: () => model.addLayerCallback(reversedIndex+1),
                            onAddBelow: () => model.addLayerCallback(reversedIndex),
                          );
                        }
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        elevation: 4.0,
                        isExtended: true,
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        mini: true,
                        child: Icon(Icons.add),
                        onPressed: () {
                          model.addLayerCallback(model.currentLayerIndex+1);
                        },
                      ),
                    )
//                    child: RaisedButton(
//                      padding: const EdgeInsets.all(0.0),
//                      elevation: 2.0,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
//                        child: Row(
//                          mainAxisSize: MainAxisSize.max,
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.only(right: 3.0),
//                              child: Icon(Icons.add),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(left: 3.0),
//                              child: Text('New Layer'),
//                            ),
//                          ],
//                        ),
//                      ),
//                      onPressed: () {
//                        model.addLayerCallback(model.currentLayerIndex+1);
//                      },
//                      shape: RoundedRectangleBorder(
//                      side: BorderSide(
//                        color: Colors.black38,
//                      ),
//                      borderRadius: BorderRadius.circular(6.0),
//                      ),
//                    ),
                  ),
//                Divider(
//                  height: 1.0,
//                ),
//                Material(
//                  child: ListTile(
//                    contentPadding: EdgeInsets.all(0.0),
//                    leading: IconButton(
//                      icon: Icon(Icons.add),
//                      onPressed: () {
//                        model.addLayerCallback(model.currentLayerIndex+1);
//                      },
//                    ),
//                  ),
//                ),
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: Padding(
//                      padding: const EdgeInsets.all(12.0),
//                      child: RaisedButton(
//                        child: SizedBox(
//                          height: 40.0,
//                          width: 104.0,
//                          child: Center(
//                            child: Icon(Icons.add),
//                          ),
//                        ),
//                        onPressed: model.addLayerCallback,
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              ),
        );
      }
    );
  }
}