import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({
    Key key,
    this.color,
    this.width = 1.0,
  }) : super(key: key);

  final Color color;
  final double width;

  static BorderSide createBorderSide(BuildContext context, { Color color, double width = 0.0 }) {
    assert(width != null);
    return new BorderSide(
      color: color ?? Theme.of(context).dividerColor,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(
        child: Container(
          width: 0.0,
          decoration: BoxDecoration(
            border: Border(
              right: createBorderSide(context, color: color),
            )
          ),
        )
      )
    );
  }
}