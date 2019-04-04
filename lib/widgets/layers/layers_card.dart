import 'dart:ui';

import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layers_list.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

double _kBlurAmount = 20.0;

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
    return Card(
      color: Material.Theme.of(context).unselectedWidgetColor,
      elevation: 0.0,
      borderRadius: BorderRadius.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: LayersList(),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(height: 56.0),
                child: StoreConnector<AppState, VoidCallback>(
                  ignoreChange: (state) => !state.layersDirty,
                  converter: (store) => () => store.dispatch(AddNewLayerAction()),
                  builder: (context, callback) {
                    return Button(
                      child: Text('NEW LAYER'),
                      onPressed: () {
                        callback();
                      },
                    );
                  }
                ),
              ),
            ),
          ],
        ),
    );
  }
}
