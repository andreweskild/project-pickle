import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/widgets/common/square_button.dart';
import 'package:project_pickle/widgets/common/two_stage_popup_button.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';

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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SquareButton(
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SquareButton(
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
                    ),
                  ]
                )
              ),
              PopupContentItem(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SquareButton(
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SquareButton(
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
                    ),
                  ]
                )
              ),
              PopupContentItem(
                  child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SquareButton(
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
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SquareButton(
                              child: Text(
                                "Clear Layer",
                                style: TextStyle(
                                  inherit: true,
                                  fontWeight: FontWeight.normal,
                                )
                              ),
                              onPressed: (){},
                            ),
                          ),
                        )
                      ]
                  )
              ),
              PopupContentItem(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: SquareButton(

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