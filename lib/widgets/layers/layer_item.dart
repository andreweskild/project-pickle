import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';

class _LayerItemModel {
  _LayerItemModel({
    this.hidden,
    this.toggleHiddenCallback,
  });

  bool hidden;
  VoidCallback toggleHiddenCallback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + hidden.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _LayerItemModel) return false;
    _LayerItemModel model = other;
    return (model.hidden == hidden);
  }
}

class LayerItem extends StatelessWidget {
  LayerItem({
    @required this.index,
    this.active,
    this.animationController,
    this.onDelete,
    this.onDuplicate,
    this.onToggle,
    this.canvas,
    this.name,
  });

  final int index;
  final bool active;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onDuplicate;
  final Widget canvas;
  final String name;
  final AnimationController animationController;

  void performPopupAction(BuildContext context, VoidCallback action) {
    Navigator.pop(context, action);
  }

  void _startDeleteAnimation() {
    assert(animationController != null);
    animationController
      ..addStatusListener(
          (status) {
            if(status == AnimationStatus.dismissed) {
              onDelete();
            }
          }
      )..reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
          parent: animationController, curve: Curves.ease
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.ease
        ),
        child: TwoStagePopupButton(
          headerContent: (opened) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kBorderRadius - 2.0)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kBorderRadius - 2.0),
                        child: canvas
                      )
                    )
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    softWrap: false,
                  ),
                ),
              ]
            );
          },
          popupContent: <PopupContentItem>[
            PopupContentItem(
            height: 52.0,
              padding: EdgeInsets.zero,
              child: ListView(
                padding: EdgeInsets.only(left: 12.0, top: 6.0, bottom: 12.0, right: 12.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  StoreConnector<AppState, _LayerItemModel>(
                    converter: (store) => _LayerItemModel(
                      hidden: store.state.layers[index].hidden,
                      toggleHiddenCallback: () => store.dispatch(ToggleLayerHiddenAction(index)),
                    ),
                    builder: (context, layerModel) {
                      return FilterChip(
                        avatar: Icon(Icons.remove_red_eye),
                        selected: !layerModel.hidden,
                        label: Text(
                            "Visible",
                        ),
                        onSelected: (hidden) => layerModel.toggleHiddenCallback(),
                      );
                    }
                  ),
                  HorizontalSpacer(),
                  FilterChip(
                    avatar: Icon(Icons.lock_outline),
                    selected: false,
                    label: Text(
                      "Alpha Lock",
                    ),
                    onSelected: (selected) => {},
                  ),
                  HorizontalSpacer(),
                  FilterChip(
                    avatar: Icon(Icons.layers),
                    selected: true,
                    label: Text(
                        "Clip Layer",
                    ),
                    onSelected: (selected) => {},
                  ),
                ]
              ),
            ),
            PopupContentItem(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 6.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Button(
                      child: Text(
                        "Duplicate",
                      ),
                      onPressed: () {
                        performPopupAction(context, onDuplicate);
//                        onDuplicate();
                      },
                    ),
                  ),
                  HorizontalSpacer(),
                  Expanded(
                    child: Button(
                      child: Text(
                        "Merge",
                      ),
                      onPressed: (){},
                    ),
                  ),
                ]
              )
            ),
            PopupContentItem(
                child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Button(
                          child: Text(
                            "Select",
                          ),
                          onPressed: (){},
                        ),
                      ),
                      HorizontalSpacer(),
                      Expanded(
                        child: Button(
                          child: Text(
                            "Clear Layer",
                          ),
                          onPressed: (){},
                        ),
                      )
                    ]
                )
            ),
            PopupContentItem(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: Button(
                    child: Text(
                        "Delete",
                    ),
                    color: Material.Theme.of(context).errorColor,
                    textColor: Colors.white,
                    onPressed: onDelete == null ? null : () => performPopupAction(context, _startDeleteAnimation),
                  ),
                )
            )
          ],
          onToggled: onToggle,
          active: active,
        ),
      ),
    );
  }
}