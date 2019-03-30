import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DismissDirection;
import 'package:flutter/rendering.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/reorderable_list.dart';
import 'package:project_pickle/widgets/layers/layer_item.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

class LayersList extends StatefulWidget {
  const LayersList({ Key key }) : super(key: key);

  @override
  _LayersListState createState() => _LayersListState();
}

typedef _LayerReorderCallback = void Function(int, int);

class _LayerListModel {
  _LayerListModel({
    this.layers,
    this.reorderCallback,
    this.removeCallback,
    this.newLayerCallback,
  });

  final PixelLayerList layers;
  final _LayerReorderCallback reorderCallback;
  final ValueSetter<int> removeCallback;
  final VoidCallback newLayerCallback;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layers.length.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _LayerListModel) return false;
    _LayerListModel model = other;
    return (model.layers.length == layers.length);
  }
}

class _LayerModel {
  _LayerModel({
    this.isActiveLayer,
    this.layer,
    this.setActiveCallback,
    this.toggleHidden,
    this.duplicateLayer,
    this.deleteLayer,
  });

  final bool isActiveLayer;
  final PixelLayer layer;
  final ValueSetter<int> setActiveCallback;
  final ValueSetter<int> toggleHidden;
  final ValueSetter<int> duplicateLayer;
  final ValueSetter<int> deleteLayer;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layer.hashCode;
    result = 37 * result + isActiveLayer.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _LayerModel) return false;
    _LayerModel model = other;
    return (model.isActiveLayer == this.isActiveLayer) &&
      (model.layer.name == this.layer.name);
  }
}

class _LayersListState extends State<LayersList> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildListTile(int index, String name, bool canDelete) {
    return StoreConnector<AppState, _LayerModel>(
      key: Key(name + index.toString()),
      converter: (store) {
        return _LayerModel(
          isActiveLayer: index == store.state.layers.indexOfActiveLayer,
          layer: store.state.layers[index],
          setActiveCallback: (index) =>
              store.dispatch(SetCurrentLayerIndexAction(index)),
          toggleHidden: (index) => store.dispatch(ToggleLayerHiddenAction(index)),
          duplicateLayer: (index) => store.dispatch(DuplicateLayerAction(index)),
          deleteLayer: (index) => store.dispatch(RemoveLayerAction(index)),
        );
      },
      distinct: true,
      builder: (context, layerModel) {
        return LayerItem(
          index: index,
          animationController: layerModel.layer.animationController,
          canvas: layerModel.layer.canvas,
          active: layerModel.isActiveLayer,
          name: layerModel.layer.name,
          onToggle: () => layerModel.setActiveCallback(index),
          onDelete: canDelete ? () => layerModel.deleteLayer(index) : null,
          onDuplicate: () => layerModel.duplicateLayer(index),
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: StoreConnector<AppState, _LayerListModel>(
        converter: (store) {
          if (store.state.layersDirty) {
            store.state.layersDirty = false;
          }
          return _LayerListModel(
            layers: store.state.layers,
            removeCallback: (index) => store.dispatch(RemoveLayerAction(index)),
            reorderCallback: (oldIndex, newIndex) => store.dispatch(ReorderLayerAction(oldIndex, newIndex)),
            newLayerCallback: (){}
          );
        },
        ignoreChange: (state) => !state.layersDirty,
        builder: (context, model) {
          return ReorderableList(
            onReorder: (oldIndex, newIndex) {
              // we have to adjust incoming indexes because list was flipped to better
              // reflect the drawing order of layers in layer list
              int tempOld = model.layers.length - 1 - oldIndex;
              int tempNew = model.layers.length - newIndex;
              model.reorderCallback(tempOld, tempNew);
            },
            padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
            children: List.generate(model.layers.length,
              (index) {
                int currentReversedIndex = model.layers.length - 1 - index; // ordering list from end to beginning
                PixelLayer currentLayer = model.layers[currentReversedIndex];
                return buildListTile(currentReversedIndex, currentLayer.name,
                    (model.layers.length > 1)
                );
              }
            ),
            feedbackDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.transparent,
            ),
            spacing: 12.0,
          );
        },
      ),
    );
  }
}