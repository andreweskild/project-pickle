import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tangible/tangible.dart';

class LayerItem extends StatelessWidget {
  LayerItem({
    this.active,
    this.animationController,
    this.hidden = false,
    this.onDuplicate,
    this.onToggle,
    this.onToggleHidden,
    this.canvas,
    this.name,
  });

  final bool active;
  final bool hidden;
  final VoidCallback onToggle;
  final VoidCallback onToggleHidden;
  final VoidCallback onDuplicate;
  final Widget canvas;
  final String name;
  final AnimationController animationController;

  VoidCallback _menuAction;

  void performPopupAction(BuildContext context, VoidCallback action) {
    if (action != null) { _menuAction = action; }
    Navigator.pop(context, action);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Material.Theme.of(context).buttonColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: active ? kColoredShadowMap(Material.Theme.of(context).accentColor)[6] : null,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
            parent: animationController, curve: Curves.ease
        ),
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.ease
          ),
          child: TwoStagePopupButton(
            onCompleted: _menuAction,
            color: Material.Theme.of(context).unselectedWidgetColor,
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
                          borderRadius: BorderRadius.circular(6.0)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
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
                    FilterChip(
                      avatar: Icon(Icons.remove_red_eye),
                      selected: true,
                      label: Text(
                          "Hidden",
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                          )
                      ),
                      onSelected: (selected) => {},
                    ),
                    SizedBox(
                      width: 12.0
                    ),
                    FilterChip(
                      avatar: Icon(Icons.lock_outline),
                      selected: false,
                      label: Text(
                        "Alpha Lock",
                        style: TextStyle(
                          inherit: true,
                          fontWeight: FontWeight.normal,
                        )
                      ),
                      onSelected: (selected) => {},
                    ),
                    SizedBox(
                        width: 12.0
                    ),
                    FilterChip(
                      avatar: Icon(Icons.layers),
                      selected: true,
                      label: Text(
                          "Clip Layer",
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                          )
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
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                          )
                        ),
                        onPressed: () {
                          performPopupAction(context, onDuplicate);
//                        onDuplicate();
                        },
                      ),
                    ),
                    Expanded(
                      child: Button(
                        child: Text(
                          "Merge",
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                          )
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
                          "Alpha Lock",
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                          )
                        ),
                        onPressed: (){},
                      ),
                    ),
                    Expanded(
                      child: Button(
                        child: Text(
                          "Clip Layer",
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                          )
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
                              style: TextStyle(
                                inherit: true,
                                fontWeight: FontWeight.normal,
                              )
                            ),
                            onPressed: (){},
                          ),
                        ),
                        Expanded(
                          child: Button(
                            child: Text(
                              "Clear Layer",
                              style: TextStyle(
                                inherit: true,
                                fontWeight: FontWeight.normal,
                              )
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
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          )
                      ),
                      color: Material.Theme.of(context).errorColor,
                      onPressed: (){},
                    ),
                  )
              )
            ],
            onToggled: onToggle,
            active: active,
          ),
        ),
      ),
    );
  }
}