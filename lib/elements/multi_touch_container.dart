import 'package:flutter/widgets.dart';

class MultiTouchContainer extends StatefulWidget {
  const MultiTouchContainer({
    Key key,
    this.child,
    this.onTap,
    this.doubleTapHandler,
  }) : super(key: key);

  final Widget child;

  final onTap;
  final doubleTapHandler;

  @override
  _MultiTouchState createState() => new _MultiTouchState();
}

class _MultiTouchState extends State<MultiTouchContainer> {
  Matrix4 _matrix = new Matrix4.diagonal3Values(1.0, 1.0, 1.0);

  double _previousScale = 1.0;
  double _scale = 1.0;

  Offset _startingFocalPoint;

  Offset _previousOffset;
  Offset _offset = new Offset(0.0, 0.0);


  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: new Container(
        child: new Center (
          child: widget.child,
        ),
        transform: _matrix,
      ),
    );
  }


  void _handleScaleStart(ScaleStartDetails details) {
    _startingFocalPoint = details.focalPoint;
    _previousOffset = _offset;
    _previousScale = _scale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if(details.scale != 1.0) {
    double newScale = _previousScale * details.scale;

    // Ensure that item under the focal point stays in the same place despite zooming
    final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;
    final Offset newOffset = details.focalPoint - normalizedOffset * newScale;

    setState(() {
      _scale = newScale;
      _offset = newOffset;

      _setScaleOfMatrix(newScale, _matrix);
      _matrix.setTranslationRaw(newOffset.dx, newOffset.dy, 1.0);
    });
    }
  }

  void _setScaleOfMatrix(double pScale, Matrix4 pMatrix) {
    pMatrix.setEntry(0,0, pScale);
    pMatrix.setEntry(1,1, pScale);
    pMatrix.setEntry(2,2, pScale);
  }
}