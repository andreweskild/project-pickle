import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layer_list_item.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/widgets/common/collapsible_button.dart';

typedef LayerIndexCallback = void Function(int);

class LayerListModel {
  LayerListModel({
    this.layers,
    this.currentLayerIndex,
    this.addLayerCallback,
    this.setLayerCallback,
    this.removeLayerCallback,
    this.toggleLayerHiddenCallback,
    this.sizeMode,
  }) {
    layerCount = layers.length;
    _visibleLayerCount = layers.where((layer) => !layer.hidden).length;
  }

  List<PixelCanvasLayer> layers;

  int currentLayerIndex;
  int layerCount;
  DrawerSizeMode sizeMode;

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
    result = 37 * result + sizeMode.hashCode;
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
        model._visibleLayerCount == _visibleLayerCount &&
        model.sizeMode == sizeMode);
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
              setLayerCallback: (index) =>
                  store.dispatch(SetCurrentLayerIndexAction(index)),
              removeLayerCallback: (index) =>
                  store.dispatch(RemoveLayerAction(index)),
              toggleLayerHiddenCallback: (index) =>
                  store.dispatch(ToggleLayerHiddenAction(index)),
              sizeMode: store.state.rightDrawerSizeMode,
            ),
        builder: (context, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RaisedButton(
                  color: Theme.of(context).unselectedWidgetColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(6.0)
                  ),
                  padding: EdgeInsets.all(0.0),
                  child: Text('New Layer'),
                  elevation: 0.0,
                  onPressed: () {
                    model.addLayerCallback();
                  },
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).unselectedWidgetColor,
                    border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    children:
                        List<Widget>.generate(model.layers.length, (index) {
                      int reversedIndex = model.layers.length - 1 - index;
                      return Dismissible(
                        key: Key(
                            '${model.layers[reversedIndex].name}$reversedIndex'),
                        onDismissed: (direction) =>
                            model.removeLayerCallback(reversedIndex),
                        background: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AnimatedContainer(
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 150),
                            child: Center(
                                child:
                                    Icon(Icons.delete, color: Colors.white)),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                        child: LayerListItem(
                          layerCanvas: model.layers[reversedIndex].canvas,
                          selected:
                              (model.currentLayerIndex == reversedIndex),
                          label: model.layers[reversedIndex].name,
                          hidden: model.layers[reversedIndex].hidden,
                          onTap: () => model.setLayerCallback(reversedIndex),
                          onToggleHidden: () =>
                              model.toggleLayerHiddenCallback(reversedIndex),
                        ),
                      );
                    })),
                ),
              ),
            ],
          );
        });
  }
}
