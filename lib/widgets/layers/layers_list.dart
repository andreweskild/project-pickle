import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DismissDirection;
import 'package:flutter/rendering.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/reorderable_list.dart';
import 'package:project_pickle/widgets/common/deletable.dart';
import 'package:project_pickle/widgets/layers/layer_list_item.dart';
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
    this.layer,
    this.setActiveCallback,
    this.toggleHidden,
  });

  final PixelLayer layer;
  final ValueSetter<int> setActiveCallback;
  final ValueSetter<int> toggleHidden;
}

class _LayersListState extends State<LayersList> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  

  Widget buildListTile(int index, _LayerListModel listModel) {
    // don't allow deleting of last color in palette
    if(listModel.layers.length > 1) {
      return Deletable(
        key: Key(listModel.layers[index].name + index.toString()),
        direction: DismissDirection.endToStart,
        onDeleted: (direction) => listModel.removeCallback(index),
        background: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFBABA),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75,
              heightFactor: 1.0,
              child: Icon(Icons.delete_outline, color: Color(0xFFDC5353)),
            )
        ), 
        child: StoreConnector<AppState, _LayerModel>(
          converter: (store) {
            return _LayerModel(
              layer: store.state.layers[index],
              setActiveCallback: (index) =>
                  store.dispatch(SetCurrentLayerIndexAction(index)),
              toggleHidden: (index) => store.dispatch(ToggleLayerHiddenAction(index)),
            );
          },
          builder: (context, layerModel) {
            return LayerListItem(
              layerCanvas: layerModel.layer.canvas,
              selected:
                  (index == listModel.layers.indexOfActiveLayer),
              label: layerModel.layer.name,
              hidden: layerModel.layer.hidden,
              onTap: () => layerModel.setActiveCallback(index),
              onToggleHidden: () => layerModel.toggleHidden(index),
            );
          } 
        )
      );
    }
    else {
      return StoreConnector<AppState, _LayerModel>(
          key: Key(listModel.layers[index].name + index.toString()),
          converter: (store) {
            return _LayerModel(
              layer: store.state.layers[index],
              setActiveCallback: (index) =>
                  store.dispatch(SetCurrentLayerIndexAction(index)),
              toggleHidden: (index) => store.dispatch(ToggleLayerHiddenAction(index)),
            );
          },
          builder: (context, layerModel) {
            return LayerListItem(
              layerCanvas: layerModel.layer.canvas,
              selected:
                  (index == listModel.layers.indexOfActiveLayer),
              label: layerModel.layer.name,
              hidden: layerModel.layer.hidden,
              onTap: () => layerModel.setActiveCallback(index),
              onToggleHidden: () => layerModel.toggleHidden(index),
            );
          } 
        );
    }

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
              (index) =>
                buildListTile(model.layers.length - 1 - index, model), // ordering list from end to beginning
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