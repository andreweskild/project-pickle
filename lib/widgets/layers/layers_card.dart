import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layer_list_item.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

typedef LayerIndexCallback = void Function(int);

class LayerListModel {
  LayerListModel({
    this.layers,
    this.currentLayerIndex,
    this.addLayerCallback,
    this.setLayerCallback,
    this.removeLayerCallback,
    this.toggleLayerHiddenCallback
  }) {
    layerCount = layers.length;
    _visibleLayerCount = layers.where((layer) => !layer.hidden).length;
  }

  List<PixelCanvasLayer> layers;

  int currentLayerIndex;
  int layerCount;

  VoidCallback addLayerCallback;
  LayerIndexCallback setLayerCallback;
  LayerIndexCallback removeLayerCallback;
  LayerIndexCallback toggleLayerHiddenCallback;

  int _visibleLayerCount;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layerCount.hashCode;
    result = 37 * result + currentLayerIndex.hashCode;
    result = 37 * result + _visibleLayerCount.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! LayerListModel) return false;
    LayerListModel model = other;
    return (model.layerCount == layerCount &&
            model.currentLayerIndex == currentLayerIndex &&
            model._visibleLayerCount == _visibleLayerCount);
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
        currentLayerIndex: store.state.currentLayerIndex,
        addLayerCallback: () => store.dispatch(AddNewLayerAction()),
        setLayerCallback: (index) => store.dispatch(SetCurrentLayerIndexAction(index)),
        removeLayerCallback: (index) => store.dispatch(RemoveLayerAction(index)),
        toggleLayerHiddenCallback: (index) => store.dispatch(ToggleLayerHiddenAction(index)),
      ),
      builder: (context, model) {
            return Material(
              color: Colors.grey.shade200,
              child: Stack(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 60.0),
                    children: List<Widget>.generate(
                      model.layers.length,
                      (index) {
                        int reversedIndex = model.layers.length - 1 - index;
                        return Dismissible(
                          key: Key('${model.layers[reversedIndex].name}$reversedIndex'),
                          onDismissed: (direction) => model.removeLayerCallback(reversedIndex),
                          background: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 150),
                              child: Center(child: Icon(Icons.delete, color: Colors.white)),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                          child: LayerListItem(
                            layerCanvas: model.layers[reversedIndex].canvas,
                            selected: (model.currentLayerIndex == reversedIndex),
                            label: model.layers[reversedIndex].name,
                            hidden: model.layers[reversedIndex].hidden,
                            onTap: () => model.setLayerCallback(reversedIndex),
                            onToggleHidden: () => model.toggleLayerHiddenCallback(reversedIndex),
                          ),
                        );
                      }
                    )
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 48.0,
                        child: RaisedButton.icon(
                          elevation: 4.0,
                          color: Colors.grey.shade400,
//                        isExtended: true,
//                        backgroundColor: Colors.grey.shade700,
//                        foregroundColor: Colors.white,
//                        mini: true,
                          icon: Icon(Icons.add),
                          label: Text('New Layer'),
                          onPressed: () {
                            model.addLayerCallback();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                              color: Colors.black26
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        );
      }
    );
  }
}