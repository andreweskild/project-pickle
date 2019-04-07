import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';


class Divider extends StatelessWidget {
//  const Divider({
//    Key key,
//    this.height = 16.0,
//    this.width = 1.0,
//    this.color
//  }) : assert(height >= 0.0),
//        super(key: key);
  final double thickness;
  final Color color;

  double _height;
  double _width;

  Divider.vertical({
    Key key,
    this.thickness = 1.0,
    this.color
  }) : assert(thickness >= 0.0),
        super(key: key) {
    _width = thickness;
  }

  Divider.horizontal({
    Key key,
    this.thickness = 1.0,
    this.color
  }) : assert(thickness >= 0.0),
        super(key: key) {
    _height = thickness;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}