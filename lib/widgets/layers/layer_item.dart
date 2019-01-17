import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/common/two_stage_popup_button.dart';

class LayerItem extends StatelessWidget {
  LayerItem({
    this.active,
    this.hidden = false,
    this.onToggle,
    this.onToggleHidden,
    this.canvas,
    this.name,
    this.options,
  });

  final bool active;
  final bool hidden;
  final VoidCallback onToggle;
  final VoidCallback onToggleHidden;
  final Widget canvas;
  final String name;
  final Widget options;

  @override
  Widget build(BuildContext context) {
    return TwoStagePopupButton(
      headerContent: (opened) {
        var content = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
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
                  fontWeight: FontWeight.w500,
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
      popupContent: options,
      onToggled: onToggle,
      active: active,
    );
  }
}