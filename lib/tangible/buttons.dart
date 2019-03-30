import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';

import 'shadows.dart';
export 'two_stage_popup_button.dart';

class Button extends StatelessWidget {
  Button({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.highlightColor,
    this.textColor,
  }) : super(key: key);

  final Color color;
  final Color disabledColor;
  final Color disabledTextColor;
  final Color splashColor;
  final Color highlightColor;
  final Color textColor;
  final Widget child;
  final VoidCallback onPressed;

  factory Button.icon({
    Key key,
    @required Widget icon,
    @required Widget label,
    @required VoidCallback onPressed,
    Color color,
    Color disabledColor,
    Color disabledTextColor,
    Color splashColor,
    Color highlightColor,
    Color textColor,
  }) = _ButtonWithIcon;

  @override
  Widget build(BuildContext context) {
    return Material.ButtonTheme(
      height: 52.0,
      child: Material.FlatButton(
        padding: EdgeInsets.zero,
        child: child,
        color: color ?? Material.Theme.of(context).buttonColor,
        colorBrightness: Material.Theme.of(context).brightness,
        disabledColor: disabledColor ?? Material.Theme.of(context).disabledColor,
        disabledTextColor: disabledTextColor ?? Material.Theme.of(context).textTheme.button.color.withAlpha(150),
        textColor: textColor ?? Material.Theme.of(context).textTheme.button.color,
        shape: RoundedRectangleBorder(
          side: onPressed == null ?  BorderSide(color: Material.Theme.of(context).dividerColor.withAlpha(24)) :
            BorderSide(color: Material.Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _ButtonWithIcon extends Button {
  _ButtonWithIcon({
    Key key,
    @required VoidCallback onPressed,
    Color color,
    Color disabledColor,
    Color disabledTextColor,
    Color highlightColor,
    Color splashColor,
    Color textColor,
    @required Widget icon,
    @required Widget label,
  }) : assert(icon != null),
        assert(label != null),
        super(
        key: key,
        onPressed: onPressed,
        color: color,
        disabledColor: disabledColor,
        disabledTextColor: disabledTextColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        textColor: textColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon,
            const SizedBox(width: 8.0),
            label,
          ],
        ),
      );
}

class FlatButton extends StatelessWidget {
  FlatButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color,
    this.splashColor,
    this.highlightColor,
  }) : super(key: key);

  final Color color;
  final Color splashColor;
  final Color highlightColor;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material.ButtonTheme(
      height: 52.0,
      child: Material.FlatButton(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: child,
        color: color ?? Material.Colors.transparent,
        colorBrightness: Material.Theme.of(context).brightness,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  ToggleButton({
    Key key,
    @required this.child,
    @required this.onToggle,
    @required this.toggled,
    this.color,
    this.toggledColor,
    this.splashColor,
    this.shadowColor,
    this.highlightColor,
    this.toggledElevation = 6,
  }) : super(key: key);

  final Color color;
  final Color toggledColor;
  final Color splashColor;
  final Color shadowColor;
  final Color highlightColor;
  final int toggledElevation;
  final Widget child;
  final ValueChanged<bool> onToggle;
  final bool toggled;


  @override
  Widget build(BuildContext context) {
    final currentColor =              // Color used for background of button
    (toggled) ?
    toggledColor ?? Material.Theme
        .of(context)
        .primaryColor :
    color ?? Material.Theme
        .of(context)
        .cardColor;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: currentColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: toggled ? kColoredShadowMap(shadowColor ?? Material.Theme.of(context).accentColor)[toggledElevation] : null,
      ),
      child: Material.Material(
        type: Material.MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Material.InkWell(
          splashColor: splashColor,
          highlightColor: highlightColor,
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            onToggle(toggled);
          },
          child: IconTheme(
              data: IconThemeData(
                  color: toggled
                      ? Material.Theme
                      .of(context)
                      .accentIconTheme
                      .color
                      : Material.Theme
                      .of(context)
                      .iconTheme
                      .color
              ),
            child: DefaultTextStyle(
                style: TextStyle(
                    color: toggled
                        ? Material.Theme
                        .of(context)
                        .accentIconTheme
                        .color
                        : Material.Theme
                        .of(context)
                        .iconTheme
                        .color
                ),
                child: child
            ),
          ),
        ),
      ),
    );
  }
}

class IconButton extends StatelessWidget {
  IconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  final Color color;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    bool _buttonIsDisabled = onPressed == null;

    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
        opacity: _buttonIsDisabled ? 0.5 : 1.0,
        child: Material.FlatButton(
          padding: EdgeInsets.all(0.0),
          child: IconTheme(
            data: IconThemeData(
              color: color ?? Material.Theme.of(context).iconTheme.color,
            ),
            child: icon
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class OutlineIconButton extends StatelessWidget {
  OutlineIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  final Color color;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    bool _buttonIsDisabled = onPressed == null;

    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
        opacity: _buttonIsDisabled ? 0.5 : 1.0,
        child: Material.FlatButton(
          padding: EdgeInsets.all(0.0),
          child: IconTheme(
              data: IconThemeData(
                color: color ?? Material.Theme.of(context).iconTheme.color,
              ),
              child: icon
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: color.withAlpha(40)),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}



