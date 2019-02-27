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
  final List<PopupContentItem> options;

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
          child: TwoStagePopupButton(
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
          ),
        ),
      ],
    );
  }

}