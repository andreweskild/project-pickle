import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Icon Button that shows a rounded background when [selected] is true
class ToggleIconButton extends StatefulWidget {
  ToggleIconButton({
    Key key,
    @required this.icon,
    this.toggled = false,
    @required this.onToggled,
  }) : super(key: key);
  final Widget icon;
  final VoidCallback onToggled;
  final bool toggled;

  _ToggleIconButtonState createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  bool _toggled;

  @override
  void initState() {
    _toggled = widget.toggled;
    super.initState();
  }

  void _toggleCallback() {
    setState((){
      widget.onToggled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: FlatButton(
        color: _toggled ? Theme.of(context).highlightColor : Colors.transparent,
        textColor: _toggled ? Theme.of(context).accentTextTheme.button.color : Colors.black,
        child: widget.icon,
        padding: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        onPressed: _toggleCallback,
      ),
    );
  }
}