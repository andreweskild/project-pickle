import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/pixels/canvas_controller.dart';

int _widthBreakpoint = 992;

class CanvasGestureContainer extends StatefulWidget {
  const CanvasGestureContainer({
    Key key,
    this.canvasController,
  }) : super(key: key);

  final CanvasController canvasController;


  @override
  _CanvasGestureContainerState createState() => new _CanvasGestureContainerState();
}

class _CanvasGestureContainerState extends State<CanvasGestureContainer> {
  Size _previousViewportSize;

  Matrix4 _matrix = new Matrix4.diagonal3Values(1.0, 1.0, 1.0);

  bool _initialized = false;

  double padding = 32.0;

  double _previousScale = 1.0;
  double _scale = 1.0;

  Offset _startingFocalPoint;

  Offset _previousOffset;
  Offset _offset = new Offset(0.0, 0.0);

  Store<AppState> _store;

  void _setInitialScale(BoxConstraints constraints) {
    Size viewSize = constraints.biggest;
    Offset focalPoint = new Offset(
      viewSize.width/2,
      viewSize.height/2,
    );
    double initialScale;

    if (constraints.maxWidth > _widthBreakpoint) {
      if (viewSize.width - 512.0 < viewSize.height) {
        initialScale = (viewSize.width - 512.0 - padding*2) / widget.canvasController.width;
      } else {
        initialScale = (viewSize.height - padding*2) / widget.canvasController.height;
      }
    }
    else {
      if (viewSize.width < viewSize.height) {
        initialScale =
            (viewSize.width - padding * 2) / widget.canvasController.width;
      } else {
        initialScale =
            (viewSize.height - padding * 2) / widget.canvasController.height;
      }
    }

    _startingFocalPoint = focalPoint;
    _previousOffset = _offset;
    _previousScale = _scale;

    if(initialScale != 1.0) {
      double newScale = _previousScale * initialScale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;
      final Offset newOffset = focalPoint - normalizedOffset * newScale;

      _updateScale(newScale);
      _offset = newOffset;

      _setScaleOfMatrix(newScale, _matrix);
      _matrix.setTranslationRaw(newOffset.dx, newOffset.dy, 1.0);
    }
  }

  void centerAndFill(BoxConstraints constraints) {
    _matrix = new Matrix4.diagonal3Values(1.0, 1.0, 1.0);
    _offset = new Offset(0.0, 0.0);
    _previousScale = 1.0;
    _updateScale(1.0);

    Size viewSize = constraints.biggest;


    Offset focalPoint = new Offset(
      viewSize.width/2,
      viewSize.height/2,
    );
    double initialScale;



    if (constraints.maxWidth > _widthBreakpoint) {
      if (viewSize.width - 512.0 < viewSize.height) {
        initialScale = (viewSize.width - 512.0 - padding*2) / widget.canvasController.width;
      } else {
        initialScale = (viewSize.height - padding*2) / widget.canvasController.height;
      }
    }
    else {
      if (viewSize.width < viewSize.height) {
        initialScale =
            (viewSize.width - padding * 2) / widget.canvasController.width;
      } else {
        initialScale =
            (viewSize.height - padding * 2) / widget.canvasController.height;
      }
    }

    _startingFocalPoint = focalPoint;
    _previousOffset = _offset;
    _previousScale = _scale;

    if(initialScale != 1.0) {
      double newScale = _previousScale * initialScale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;
      final Offset newOffset = focalPoint - normalizedOffset * newScale;

      _updateScale(newScale);
      _offset = newOffset;

      _setScaleOfMatrix(newScale, _matrix);
      _matrix.setTranslationRaw(newOffset.dx, newOffset.dy, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_store == null) {
      _store = StoreProvider.of<AppState>(context);
    }


    return new LayoutBuilder(
      builder: (context, constraints) {
        if (_previousViewportSize == null) {
          _previousViewportSize = constraints.biggest;
        }

        if(!_initialized) {
          _setInitialScale(constraints);
          _initialized = true;
        }
        else if (_previousViewportSize != constraints.biggest) {
          centerAndFill(constraints);
          _previousViewportSize = constraints.biggest;
        }

        return new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          child: new Container(
            child: new Center (
              child: widget.canvasController,
            ),
            transform: _matrix,
          ),
        );
      }
    );
  }

  void _updateScale(double newScale) {
    _scale = newScale;
    _store.dispatch(SetCanvasScaleAction(newScale));
  }

  void _scaleStart(Offset focal) {
    _startingFocalPoint = focal;
    _previousOffset = _offset;
    _previousScale = _scale;
  }

  void _scaleUpdate(double scale, Offset focal) {
    if(scale != 1.0) {
      double newScale = _previousScale * scale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;
      final Offset newOffset = focal - normalizedOffset * newScale;

      setState((){
        _updateScale(newScale);
        _offset = newOffset;

        _setScaleOfMatrix(newScale, _matrix);
        _matrix.setTranslationRaw(newOffset.dx, newOffset.dy, 1.0);
      });
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _scaleStart(details.focalPoint);
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    _scaleUpdate(details.scale, details.focalPoint);
  }

  void _setScaleOfMatrix(double pScale, Matrix4 pMatrix) {
    pMatrix.setEntry(0,0, pScale);
    pMatrix.setEntry(1,1, pScale);
    pMatrix.setEntry(2,2, pScale);
  }
}