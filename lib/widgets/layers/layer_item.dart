import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
            opacity: active ? 1.0 : 0.0,
            child: Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0),
              elevation: 6.0,
              shadowColor: Theme.of(context).primaryColor.withAlpha(
                  Theme.of(context).brightness == Brightness.dark ? 255 : 128
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
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
                headerContent: (opened) {
                  var content = Row(
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
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              splashColor: const Color(0x9986C040),
                              highlightColor: const Color(0x99B0EF63),
                              child: IconTheme(
                                data: IconThemeData(
                                    color: active
                                        ? Theme
                                        .of(context)
                                        .accentIconTheme
                                        .color
                                        : Theme
                                        .of(context)
                                        .iconTheme
                                        .color
                                ),
                                child: Icon(
                                  (hidden) ? Icons.remove : Icons.remove_red_eye,
                                  size: 20.0,
                                ),
                              ),
                              onPressed: onToggleHidden,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  );
                  if (opened) {
                    return content;
                  }
                  else {
                    return content;
                  }
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
                              color: Theme.of(context).unselectedWidgetColor,
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
                              color: Theme.of(context).unselectedWidgetColor,
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
                              color: Theme.of(context).unselectedWidgetColor,
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
                              color: Theme.of(context).unselectedWidgetColor,
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
                                  color: Theme.of(context).unselectedWidgetColor,
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
                                  color: Theme.of(context).unselectedWidgetColor,
                                ),
                              ),
                            )
                          ]
                      )
                  )
                ],
                onToggled: onToggle,
                active: active,
              ),
            ),
          ),
        ),
      ],
    );
  }
}