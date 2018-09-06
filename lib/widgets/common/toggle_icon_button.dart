import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Icon Button that shows a rounded background when [selected] is true
class ToggleIconButton extends StatelessWidget {
  ToggleIconButton({
    Key key,
    @required this.icon,
    this.toggled = false,
    @required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onPressed;
  final bool toggled;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: toggled ? Theme.of(context).highlightColor : Colors.transparent,
      textColor: toggled ? Theme.of(context).accentTextTheme.button.color : Colors.black,
      child: icon,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      onPressed: onPressed,
    );
  }
}