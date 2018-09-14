import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/widgets/common/toggle_icon_button.dart';
import 'package:project_pickle/widgets/common/popup_button.dart';

class _PreviewModel {
  _PreviewModel({
    this.layers,
    this.sizeMode,
  }) {
    layerCount = layers.length;
  }

  List<PixelCanvasLayer> layers;
  DrawerSizeMode sizeMode;
  int currentLayerIndex;
  int layerCount;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layerCount.hashCode;
    result = 37 * result + sizeMode.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _PreviewModel) return false;
    _PreviewModel model = other;
    return (model.layerCount == layerCount &&
        model.sizeMode == sizeMode);
  }
}

class PreviewToolbox extends StatelessWidget {
  PreviewToolbox({
    Key key,
  }) : super(key: key);

  Widget _cachedPreview;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _PreviewModel>(
      distinct: true,
      converter: (store) {
        return _PreviewModel(
          layers: store.state.layers.where((
              layer) => !layer.hidden).toList(),
          sizeMode: store.state.rightDrawerSizeMode,
        );
      },
      builder: (context, model) {
        if (_cachedPreview == null) {
          _cachedPreview = DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Material(
                          elevation: 2.0,
                          color: Colors.white,
                          child: UnconstrainedBox(
                            child: Transform.scale(
                              scale: constraints.maxHeight / 32.0,
                              child: SizedBox(
                                height: 32.0,
                                width: 32.0,
                                child: Stack(
                                  children: model.layers,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  )
              ),
            ),
          );
        }
        return DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  opacity: (model.sizeMode == DrawerSizeMode.Mini) ? 0.0 : 1.0,
                  child: _cachedPreview,
                ),
                AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  opacity: (model.sizeMode == DrawerSizeMode.Mini) ? 1.0 : 0.0,
                  child: PopupButton(
                    child: Icon(Icons.crop),
                    popupContent: _cachedPreview,
                  ),
                ),
              ],
            ),
          ),
        );
//        if(model.sizeMode == DrawerSizeMode.Mini) {
//          return ToggleIconButton(
//            icon: Icon(Icons.crop),
//            onPressed: (){},
//          );
//        }
//        else {
//          return _cachedPreview;
//        }
      }
    );
  }
}