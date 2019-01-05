import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layers_list.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

typedef LayerIndexCallback = void Function(int);

class LayerListModel {
  LayerListModel({
    this.layers,
    this.currentLayerIndex,
    this.addLayerCallback,
    this.setLayerCallback,
    this.removeLayerCallback,
    this.toggleLayerHiddenCallback,
  }) {
    layerCount = layers.length;
    _visibleLayerCount = layers.where((layer) => !layer.hidden).length;
  }

  List<PixelLayer> layers;

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
      ignoreChange: (state) => !state.canvasDirty,
      converter: (store) {
        return LayerListModel(
          layers: store.state.layers,
          currentLayerIndex: store.state.layers.indexOfActiveLayer,
          addLayerCallback: () => store.dispatch(AddNewLayerAction()),
          setLayerCallback: (index) =>
              store.dispatch(SetCurrentLayerIndexAction(index)),
          removeLayerCallback: (index) =>
              store.dispatch(RemoveLayerAction(index)),
          toggleLayerHiddenCallback: (index) =>
              store.dispatch(ToggleLayerHiddenAction(index)),
        );
      },
      builder: (context, model) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).unselectedWidgetColor,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor, width: 2.0),
                    bottom: BorderSide(color: Theme.of(context).dividerColor, width: 2.0),
                    left: BorderSide(color: Theme.of(context).dividerColor, width: 2.0)
                  ),
                ),
                child: LayersList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(height: 40.0),
                child: FlatButton.icon(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  highlightColor: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).dividerColor, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('New Layer'),
                  onPressed: () {
                    model.addLayerCallback();
                  },
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
