import 'package:flutter/widgets.dart';

import 'package:project_pickle/tangible/tangible.dart';

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
        Align(
          alignment: Alignment.center,
          child: TwoStagePopupButton(
            color: Colors.transparent,
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