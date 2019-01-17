import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/common/two_stage_popup_button.dart';

class ToolButton extends StatelessWidget {
  ToolButton({
    this.active,
    this.onToggle,
    this.icon,
    this.label,
    this.options,
  });

  final bool active;
  final VoidCallback onToggle;
  final Widget icon;
  final String label;
  final Widget options;

  @override
  Widget build(BuildContext context) {
    return TwoStagePopupButton(
      icon: icon,
      headerContent: (opened) {
        if (opened) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: icon
                ),
              ),
              Expanded(
                child: Text(label, softWrap: false,),
              )
            ]
          );
        }
        else {
          return Center(child: icon);
        }
      },
      popupContent: options,
      onToggled: onToggle,
      active: active,
    );
  }

}