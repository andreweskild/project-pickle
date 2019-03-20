import 'dart:ui';

import 'constants.dart';

import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';


class Card extends StatelessWidget {
  Card({
    Key key,
    this.child,
    this.color,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8.0)),
    this.elevation = 24.0,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final double elevation;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    Color _color = color ?? Material.Theme.of(context).cardColor;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Material.Material(
            elevation: elevation,
            animationDuration: Duration.zero,
            color: Material.Colors.transparent,
            shadowColor: Material.Theme.of(context).brightness == Material.Brightness.dark ?
              Material.Colors.black54 : Material.Colors.black54,
          ),
        ),
        ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: kBlurAmount,
              sigmaY: kBlurAmount,
            ),
            child: Material.Material(
              color: _color.withAlpha(kSurfaceOpacity),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class CardHeader extends StatelessWidget {
  CardHeader({
    Key key,
    this.child,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8.0)),
    this.color,
    this.height = 72.0,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final BorderRadius borderRadius;
  final Color color;
  final double height;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    Color _getContrastingColor(Color color) {
      if (color.computeLuminance() > 0.5) {
        return Material.Colors.black;
      }
      else {
        return Material.Colors.white;
      }
    }

    Color headerColor = (color == null) ?
      Material.Theme.of(context).buttonColor :
      color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: height,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Material.Material(
              animationDuration: Duration.zero,
              color: headerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: borderRadius.topLeft,
                    topRight: borderRadius.topRight
                ),
              ),
              child: Material.Theme(
                data: Material.Theme.of(context).copyWith(
                  splashColor: _getContrastingColor(headerColor).withAlpha(25),
                  highlightColor: _getContrastingColor(headerColor).withAlpha(25),
                ),
                child: Material.InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.only(
                      topLeft: borderRadius.topLeft,
                      topRight: borderRadius.topRight
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: Material.Theme.of(context).accentTextTheme.button.color,
                    ),
                    child: DefaultTextStyle(
                        style: TextStyle(
                          color: Material.Theme.of(context).accentTextTheme.button.color,
                        ),
                        child: child
                    ),
                  ),
                ),
              )
            ),
          )
        ),
        Material.Divider(
          height: 1.0,
          color: Color.alphaBlend(Material.Theme.of(context).dividerColor, headerColor),
        ),
      ],
    );
  }
}