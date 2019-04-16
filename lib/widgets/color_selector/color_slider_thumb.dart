import 'package:flutter/material.dart';

import 'package:project_pickle/tangible/constants.dart';

class ColorSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const ColorSliderThumbShape(this.color);

  static const double _thumbHeight = 40.0;
  static const double _disabledThumbHeight = 40.0;
  final Color color;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size(_thumbHeight, isEnabled ? _thumbHeight : _disabledThumbHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset thumbCenter, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
      }) {
    final Canvas canvas = context.canvas;
    final Tween<double> heightTween = new Tween<double>(
      begin: _disabledThumbHeight,
      end: _thumbHeight,
    );
    final ColorTween colorTween = new ColorTween(
      begin: sliderTheme.thumbColor,
      end: color,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
          thumbCenter.dx - heightTween.evaluate(enableAnimation) * .5,
          thumbCenter.dy - heightTween.evaluate(enableAnimation) * .5,
          thumbCenter.dx + heightTween.evaluate(enableAnimation) * .5,
          thumbCenter.dy + heightTween.evaluate(enableAnimation) * .5,
          Radius.circular(kBorderRadius)
      ),
      new Paint()..color = colorTween.evaluate(activationAnimation),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
          thumbCenter.dx - heightTween.evaluate(enableAnimation) * .5,
          thumbCenter.dy - heightTween.evaluate(enableAnimation) * .5,
          thumbCenter.dx + heightTween.evaluate(enableAnimation) * .5,
          thumbCenter.dy + heightTween.evaluate(enableAnimation) * .5,
          Radius.circular(kBorderRadius)
      ),
      new Paint()..color = Colors.black26
                 ..strokeWidth = 1.0
                 ..style = PaintingStyle.stroke,
    );
  }
}