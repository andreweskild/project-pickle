import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layer_list_item.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

typedef SetLayerIndexCallback = void Function(int);

class LayerListModel {
  LayerListModel({
    this.layers,
    this.currentLayerIndex,
    this.addLayerCallback,
    this.setLayerCallback,
  }) {
    layerCount = layers.length;
  }

  List<PixelCanvasLayer> layers;

  int currentLayerIndex;
  int layerCount;

  VoidCallback addLayerCallback;
  SetLayerIndexCallback setLayerCallback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + layerCount.hashCode;
    result = 37 * result + currentLayerIndex.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! LayerListModel) return false;
    LayerListModel model = other;
    return (model.layerCount == layerCount &&
            model.currentLayerIndex == currentLayerIndex);
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
        addLayerCallback: () => store.dispatch(AddNewLayerAction('Layer ${store.state.layers.length + 1}')),
        setLayerCallback: (index) => store.dispatch(SetCurrentLayerIndexAction(index)),
      ),
      builder: (context, model) {
        return DrawerCard(
          alignment: DrawerAlignment.end,
          title: 'Layers',
          builder: (context, collapsed) {
            return Expanded(
              child: Stack(
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 58.0),
                    children: List<Widget>.generate(
                      model.layers.length, 
                      (index) {
                        return LayerListItem(
                          icon: AnimatedContainer(
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 150),
                            height: (collapsed) ? 96.0 : 48.0,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side: BorderSide(color: Colors.black38),
                                ),
                                child: Transform.scale(
                                  alignment: Alignment.topLeft,
                                  scale: 48.0 / 32.0,
                                  child: model.layers[index].canvas
                                ),
                              )
                            ),
                          ),
                          isHighlighted: (model.currentLayerIndex == index),
                          label: AnimatedOpacity(
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 150),
                            opacity: (collapsed) ? 0.0 : 1.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(model.layers[index].name),
                            ),
                          ),
                          onTap:() => model.setLayerCallback(index),
                        );
                      }
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RaisedButton(
                        child: SizedBox(
                          height: 40.0,
                          width: 104.0,
                          child: Stack(
                            children: <Widget>[
                              AnimatedAlign(
                                duration: Duration(milliseconds: 150),
                                alignment: (collapsed) ? Alignment.center : Alignment.centerLeft, 
                                child: Icon(Icons.add)
                              ),
                              Positioned(
                                left: 32.0, 
                                bottom: 0.0,
                                top: 0.0,
                                child: Center(
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 150),
                                    opacity: (collapsed) ? 0.0 : 1.0,
                                    child: Text('New Layer')
                                  )
                                )
                              )
                            ]
                          ),
                        ),
                        onPressed: model.addLayerCallback,
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
    );
  }
}