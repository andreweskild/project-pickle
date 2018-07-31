import 'package:flutter/material.dart';

class ColorSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const ColorSliderThumbShape();

  static const double _thumbHeight = 12.0;
  static const double _disabledThumbHeight = 10.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size.fromRadius(isEnabled ? _thumbHeight : _disabledThumbHeight);
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
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
          thumbCenter.dx - heightTween.evaluate(enableAnimation),
          thumbCenter.dy - heightTween.evaluate(enableAnimation),
          thumbCenter.dx + heightTween.evaluate(enableAnimation),
          thumbCenter.dy + heightTween.evaluate(enableAnimation),
          Radius.circular(8.0)
      ),
      new Paint()..color = colorTween.evaluate(enableAnimation),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
          thumbCenter.dx - heightTween.evaluate(enableAnimation),
          thumbCenter.dy - heightTween.evaluate(enableAnimation),
          thumbCenter.dx + heightTween.evaluate(enableAnimation),
          thumbCenter.dy + heightTween.evaluate(enableAnimation),
          Radius.circular(8.0)
      ),
      new Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black38
        ..strokeWidth = 1.0,
    );
  }
}