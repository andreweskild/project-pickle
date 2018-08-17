import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/data_objects/tool_types.dart';

/// Icon Button that shows a rounded background when [selected] is true
class ToggleIconButton extends StatelessWidget {
  ToggleIconButton({
    Key key,
    @required this.icon,
    this.selected = false,
    @required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: selected ? Theme.of(context).highlightColor : Colors.transparent,
      textColor: selected ? Theme.of(context).accentTextTheme.button.color : Colors.black,
      child: icon,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      onPressed: onPressed,
    );
  }
}