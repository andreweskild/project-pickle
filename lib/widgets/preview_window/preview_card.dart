import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class _PreviewModel {
  _PreviewModel({
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
    if (other is! _PreviewModel) return false;
    _PreviewModel model = other;
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
            child: StoreConnector<AppState, _PreviewModel>(
              distinct: true,
              converter: (store) {
                return _PreviewModel(
                  layers: store.state.layers,
                );
              },
              builder: (context, model) {
                print('rebuilding preview');
                return Material(
                  color: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: UnconstrainedBox(
                    child: Transform.scale(
                      alignment: Alignment.topLeft,
                      origin: Offset(16.0, 16.0),
                      scale: 3.0,
                      child: Container(
                        height: 32.0,
                        width: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black38,
                            width: 1.0 / 3.0,
                          ),
                        ),
                      child: Stack(
                        children: model.layers,
                      ),
                      ),
                    ),
                  )
                );
              }
            )
          ),
        );
      }
    );
  }
}