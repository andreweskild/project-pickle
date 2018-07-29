import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class PreviewModel {
  PreviewModel({
    this.layers,
  }) {
    layerCount = layers.length;
  }

  List<PixelCanvasLayer> layers;

  int currentLayerIndex;
  int layerCount;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layerCount.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! PreviewModel) return false;
    PreviewModel model = other;
    return (model.layerCount == layerCount);
  }
}

class PreviewCard extends StatelessWidget {
  const PreviewCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerCard(
      alignment: DrawerAlignment.end,
      title: 'Preview',
      builder: (context, collapsed) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: StoreConnector<AppState, PreviewModel>(
              builder: (context, model) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                );
              }
            )
          ),
        );
      }
    );
  }
}