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
  final Widget label;
  final Widget options;

  @override
  Widget build(BuildContext context) {
    return TwoStagePopupButton(
      icon: icon,
      label: label,
      popupContent: options,
      onToggled: onToggle,
      active: active,
    );
  }

}