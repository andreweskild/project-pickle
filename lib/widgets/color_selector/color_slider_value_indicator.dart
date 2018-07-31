import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorSliderValueIndicatorShape extends SliderComponentShape {
  /// Create a slider value indicator in the shape of an upside-down pear.
  const ColorSliderValueIndicatorShape();

  // These constants define the shape of the default value indicator.
  // The value indicator changes shape based on the size of
  // the label: The top lobe spreads horizontally, and the
  // top arc on the neck moves down to keep it merging smoothly
  // with the top lobe as it expands.

  // Radius of the top lobe of the value indicator.
  static const double _topLobeRadius = 16.0;
  // Designed size of the label text. This is the size that the value indicator
  // was designed to contain. We scale it from here to fit other sizes.
  static const double _labelTextDesignSize = 14.0;
  // Radius of the bottom lobe of the value indicator.
  static const double _bottomLobeRadius = 6.0;
  // The starting angle for the bottom lobe. Picked to get the desired
  // thickness for the neck.
  static const double _bottomLobeStartAngle = -1.1 * math.pi / 4.0;
  // The ending angle for the bottom lobe. Picked to get the desired
  // thickness for the neck.
  static const double _bottomLobeEndAngle = 1.1 * 5 * math.pi / 4.0;
  // The padding on either side of the label.
  static const double _labelPadding = 8.0;
  static const double _distanceBetweenTopBottomCenters = 40.0;
  static const Offset _topLobeCenter = const Offset(0.0, -_distanceBetweenTopBottomCenters);
  static const double _topNeckRadius = 14.0;
  // The length of the hypotenuse of the triangle formed by the center
  // of the left top lobe arc and the center of the top left neck arc.
  // Used to calculate the position of the center of the arc.
  static const double _neckTriangleHypotenuse = _topLobeRadius + _topNeckRadius;
  // Some convenience values to help readability.
  static const double _twoSeventyDegrees = 3.0 * math.pi / 2.0;
  static const double _ninetyDegrees = math.pi / 2.0;
  static const double _thirtyDegrees = math.pi / 6.0;
  static const Size _preferredSize = const Size.fromHeight(_distanceBetweenTopBottomCenters + _topLobeRadius + _bottomLobeRadius);
  // Set to true if you want a rectangle to be drawn around the label bubble.
  // This helps with building tests that check that the label draws in the right
  // place (because it prints the rect in the failed test output). It should not
  // be checked in while set to "true".
  static const bool _debuggingLabelLocation = false;

  static Path _bottomLobePath; // Initialized by _generateBottomLobe
  static Offset _bottomLobeEnd; // Initialized by _generateBottomLobe

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => _preferredSize;

  // Adds an arc to the path that has the attributes passed in. This is
  // a convenience to make adding arcs have less boilerplate.
  static void _addArc(Path path, Offset center, double radius, double startAngle, double endAngle) {
    final Rect arcRect = new Rect.fromCircle(center: center, radius: radius);
    path.arcTo(arcRect, startAngle, endAngle - startAngle, false);
  }

  // Generates the bottom lobe path, which is the same for all instances of
  // the value indicator, so we reuse it for each one.
  static void _generateBottomLobe() {
    const double bottomNeckRadius = 4.5;
    const double bottomNeckStartAngle = _bottomLobeEndAngle - math.pi;
    const double bottomNeckEndAngle = 0.0;

    final Path path = new Path();
    final Offset bottomKnobStart = new Offset(
      _bottomLobeRadius * math.cos(_bottomLobeStartAngle),
      _bottomLobeRadius * math.sin(_bottomLobeStartAngle),
    );
    final Offset bottomNeckRightCenter = bottomKnobStart +
        new Offset(
          bottomNeckRadius * math.cos(bottomNeckStartAngle),
          -bottomNeckRadius * math.sin(bottomNeckStartAngle),
        );
    final Offset bottomNeckLeftCenter = new Offset(
      -bottomNeckRightCenter.dx,
      bottomNeckRightCenter.dy,
    );
    final Offset bottomNeckStartRight = new Offset(
      bottomNeckRightCenter.dx - bottomNeckRadius,
      bottomNeckRightCenter.dy,
    );
    path.moveTo(bottomNeckStartRight.dx, bottomNeckStartRight.dy);
    _addArc(
      path,
      bottomNeckRightCenter,
      bottomNeckRadius,
      math.pi - bottomNeckEndAngle,
      math.pi - bottomNeckStartAngle,
    );
    _addArc(
      path,
      Offset.zero,
      _bottomLobeRadius,
      _bottomLobeStartAngle,
      _bottomLobeEndAngle,
    );
    _addArc(
      path,
      bottomNeckLeftCenter,
      bottomNeckRadius,
      bottomNeckStartAngle,
      bottomNeckEndAngle,
    );

    _bottomLobeEnd = new Offset(
      -bottomNeckStartRight.dx,
      bottomNeckStartRight.dy,
    );
    _bottomLobePath = path;
  }

  Offset _addBottomLobe(Path path) {
    if (_bottomLobePath == null || _bottomLobeEnd == null) {
      // Generate this lazily so as to not slow down app startup.
      _generateBottomLobe();
    }
    path.extendWithPath(_bottomLobePath, Offset.zero);
    return _bottomLobeEnd;
  }

  // Determines the "best" offset to keep the bubble on the screen. The calling
  // code will bound that with the available movement in the paddle shape.
  double _getIdealOffset(
      RenderBox parentBox,
      double halfWidthNeeded,
      double scale,
      Offset center,
      ) {
    const double edgeMargin = 4.0;
    final Rect topLobeRect = new Rect.fromLTWH(
      -_topLobeRadius - halfWidthNeeded,
      -_topLobeRadius - _distanceBetweenTopBottomCenters,
      2.0 * (_topLobeRadius + halfWidthNeeded),
      2.0 * _topLobeRadius,
    );
    // We can just multiply by scale instead of a transform, since we're scaling
    // around (0, 0).
    final Offset topLeft = (topLobeRect.topLeft * scale) + center;
    final Offset bottomRight = (topLobeRect.bottomRight * scale) + center;
    double shift = 0.0;
    if (topLeft.dx < edgeMargin) {
      shift = edgeMargin - topLeft.dx;
    }
    if (bottomRight.dx > parentBox.size.width - edgeMargin) {
      shift = parentBox.size.width - bottomRight.dx - edgeMargin;
    }
    shift = scale == 0.0 ? 0.0 : shift / scale;
    return shift;
  }

  void _drawValueIndicator(
      RenderBox parentBox,
      Canvas canvas,
      Offset center,
      Paint paint,
      double scale,
      TextPainter labelPainter,
      ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    // The entire value indicator should scale with the size of the label,
    // to keep it large enough to encompass the label text.
    final double textScaleFactor = labelPainter.height / _labelTextDesignSize;
    final double overallScale = scale * textScaleFactor;
    canvas.scale(overallScale, overallScale);
    final double inverseTextScale = textScaleFactor != 0 ? 1.0 / textScaleFactor : 0.0;
    final double labelHalfWidth = labelPainter.width / 2.0;

    // This is the needed extra width for the label.  It is only positive when
    // the label exceeds the minimum size contained by the round top lobe.
    final double halfWidthNeeded = math.max(
      0.0,
      inverseTextScale * labelHalfWidth - (_topLobeRadius - _labelPadding),
    );

    double shift = _getIdealOffset(parentBox, halfWidthNeeded, overallScale, center);
    double leftWidthNeeded;
    double rightWidthNeeded;
    if (shift < 0.0) {
      // shifting to the left
      shift = math.max(shift, -halfWidthNeeded);
    } else {
      // shifting to the right
      shift = math.min(shift, halfWidthNeeded);
    }
    rightWidthNeeded = halfWidthNeeded + shift;
    leftWidthNeeded = halfWidthNeeded - shift;

    final Path path = new Path();
    final Offset bottomLobeEnd = _addBottomLobe(path);

    // The base of the triangle between the top lobe center and the centers of
    // the two top neck arcs.
    final double neckTriangleBase = _topNeckRadius - bottomLobeEnd.dx;
    // The parameter that describes how far along the transition from round to
    // stretched we are.
    final double leftAmount = math.max(0.0, math.min(1.0, leftWidthNeeded / neckTriangleBase));
    final double rightAmount = math.max(0.0, math.min(1.0, rightWidthNeeded / neckTriangleBase));
    // The angle between the top neck arc's center and the top lobe's center
    // and vertical.
    final double leftTheta = (1.0 - leftAmount) * _thirtyDegrees;
    final double rightTheta = (1.0 - rightAmount) * _thirtyDegrees;
    // The center of the top left neck arc.
    final Offset neckLeftCenter = new Offset(
      -neckTriangleBase,
      _topLobeCenter.dy + math.cos(leftTheta) * _neckTriangleHypotenuse,
    );
    final Offset neckRightCenter = new Offset(
      neckTriangleBase,
      _topLobeCenter.dy + math.cos(rightTheta) * _neckTriangleHypotenuse,
    );
    final double leftNeckArcAngle = _ninetyDegrees - leftTheta;
    final double rightNeckArcAngle = math.pi + _ninetyDegrees - rightTheta;
    // The distance between the end of the bottom neck arc and the beginning of
    // the top neck arc. We use this to shrink/expand it based on the scale
    // factor of the value indicator.
    final double neckStretchBaseline = bottomLobeEnd.dy - math.max(neckLeftCenter.dy, neckRightCenter.dy);
    final double t = math.pow(inverseTextScale, 3.0);
    final double stretch = (neckStretchBaseline * t).clamp(0.0, 10.0 * neckStretchBaseline);
    final Offset neckStretch = new Offset(0.0, neckStretchBaseline - stretch);

    assert(!_debuggingLabelLocation ||
            () {
          final Offset leftCenter = _topLobeCenter - new Offset(leftWidthNeeded, 0.0) + neckStretch;
          final Offset rightCenter = _topLobeCenter + new Offset(rightWidthNeeded, 0.0) + neckStretch;
          final Rect valueRect = new Rect.fromLTRB(
            leftCenter.dx - _topLobeRadius,
            leftCenter.dy - _topLobeRadius,
            rightCenter.dx + _topLobeRadius,
            rightCenter.dy + _topLobeRadius,
          );
          final Paint outlinePaint = new Paint()
            ..color = const Color(0xffff0000)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
          canvas.drawRect(valueRect, outlinePaint);
          return true;
        }());

    _addArc(
      path,
      neckLeftCenter + neckStretch,
      _topNeckRadius,
      0.0,
      -leftNeckArcAngle,
    );
    _addArc(
      path,
      _topLobeCenter - new Offset(leftWidthNeeded, 0.0) + neckStretch,
      _topLobeRadius,
      _ninetyDegrees + leftTheta,
      _twoSeventyDegrees,
    );
    _addArc(
      path,
      _topLobeCenter + new Offset(rightWidthNeeded, 0.0) + neckStretch,
      _topLobeRadius,
      _twoSeventyDegrees,
      _twoSeventyDegrees + math.pi - rightTheta,
    );
    _addArc(
      path,
      neckRightCenter + neckStretch,
      _topNeckRadius,
      rightNeckArcAngle,
      math.pi,
    );
    canvas.drawShadow(path, Colors.black, 2.0, false);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, paint
      ..color = Colors.black38
      ..style = PaintingStyle.stroke
    );

    // Draw the label.
    canvas.save();
    canvas.translate(shift, -_distanceBetweenTopBottomCenters + neckStretch.dy);
    canvas.scale(inverseTextScale, inverseTextScale);
    labelPainter.paint(canvas, Offset.zero - new Offset(labelHalfWidth, labelPainter.height / 2.0));
    canvas.restore();
    canvas.restore();
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
    final ColorTween enableColor = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.valueIndicatorColor,
    );
    _drawValueIndicator(
      parentBox,
      context.canvas,
      thumbCenter,
      new Paint()..color = enableColor.evaluate(enableAnimation),
      activationAnimation.value,
      labelPainter,
    );
  }
}