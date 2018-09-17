import 'package:flutter/material.dart';

/// Button that can be collapsed to an icon button

class CollapsibleButton extends StatelessWidget {
  const CollapsibleButton({
    Key key,
    this.icon,
    this.label,
    this.collapsed = false,
    this.onPressed
  }) : super(key: key);

  final bool collapsed;
  final Widget icon;
  final Widget label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
        return RaisedButton(
          padding: EdgeInsets.all(0.0),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedPadding(
                curve: Curves.ease,
                duration: Duration(milliseconds: 150),
                padding: collapsed ? const EdgeInsets.only(right: 0.0) : const EdgeInsets.only(right: 72.0),
                child: icon,
              ),
              AnimatedOpacity(
                curve: Curves.ease,
                duration: Duration(milliseconds: 150),
                opacity: collapsed ? 0.0 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 36.0, right: 4.0),
                  child: Center(child: label),
                ),
              )
            ],
          ),
          onPressed: onPressed,
        );
  }
}