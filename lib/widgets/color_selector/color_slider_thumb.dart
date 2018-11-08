import 'package:flutter/material.dart';

class ColorSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const ColorSliderThumbShape();

  static const double _thumbHeight = 13.0;
  static const double _disabledThumbHeight = 13.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size(_thumbHeight * 1.3, isEnabled ? _thumbHeight : _disabledThumbHeight);
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
    canvas.drawShadow(
        Path()..addRRect(
          RRect.fromLTRBR(
              thumbCenter.dx - heightTween.evaluate(enableAnimation) * 1.3,
              thumbCenter.dy - heightTween.evaluate(enableAnimation),
              thumbCenter.dx + heightTween.evaluate(enableAnimation) * 1.3,
              thumbCenter.dy + heightTween.evaluate(enableAnimation),
              Radius.circular(8.0)
          ),
        ),
        Colors.black26,
        6.0,
        false
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
          thumbCenter.dx - heightTween.evaluate(enableAnimation) * 1.3,
          thumbCenter.dy - heightTween.evaluate(enableAnimation),
          thumbCenter.dx + heightTween.evaluate(enableAnimation) * 1.3,
          thumbCenter.dy + heightTween.evaluate(enableAnimation),
          Radius.circular(8.0)
      ),
      new Paint()..color = colorTween.evaluate(enableAnimation),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
          thumbCenter.dx - heightTween.evaluate(enableAnimation) * 1.3,
          thumbCenter.dy - heightTween.evaluate(enableAnimation),
          thumbCenter.dx + heightTween.evaluate(enableAnimation) * 1.3,
          thumbCenter.dy + heightTween.evaluate(enableAnimation),
          Radius.circular(8.0)
      ),
      new Paint()..color = Colors.black26
                 ..strokeWidth = 2.0
                 ..style = PaintingStyle.stroke,
    );
  }
}