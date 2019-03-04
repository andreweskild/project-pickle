import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

class _PreviewModel {
  _PreviewModel({
    this.layers,
    this.canvasDirty,
  });

  bool canvasDirty;
  PixelLayerList layers;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + canvasDirty.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _PreviewModel) return false;
    _PreviewModel model = other;
    return (model.canvasDirty == canvasDirty);
  }
}

class PreviewToolbox extends StatelessWidget {
  PreviewToolbox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _PreviewModel>(
      ignoreChange: (state) => !state.canvasDirty,
      converter: (store) {
        return _PreviewModel(
          layers: PixelLayerList(layers: store.state.layers.where((layer) => !layer.hidden).toList()),
        );
      },
      builder: (context, model) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
                left: BorderSide(
                    color: Theme.of(context).dividerColor
                ),
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor
                )
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).unselectedWidgetColor,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Material(
                        elevation: 4.0,
                        shadowColor: Colors.black26,
                        color: Colors.white,
                        child: UnconstrainedBox(
                          child: Transform.scale(
                            scale: constraints.maxHeight / 32.0,
                            child: SizedBox(
                              height: 32.0,
                              width: 32.0,
                              child: Stack(
                                children: model.layers.map(
                                        (layer) {
                                      return Positioned.fill(
                                        child: layer.canvas
                                      );
                                    }
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
              ),
            ),
          ),
        );
      });
  }
}
