import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/state/app_state.dart';

class SelectChangeNotifier extends ChangeNotifier {
  SelectChangeNotifier();
}

class SelectToolOverlayPainter extends CustomPainter {
  SelectToolOverlayPainter(
    this.context,
  ) : super(repaint: _repaintNotifier) {
    _store = StoreProvider.of<AppState>(context);
    _store.onChange.listen(
            (state) => handleStateChange(state)
    );
    _canvasScale = _store.state.canvasScale;
    _selectionPath = _store.state.selectionPath;
  }

  static final _repaintNotifier = SelectChangeNotifier();
  double _canvasScale;
  BuildContext context;
  Path _selectionPath;
  Store<AppState> _store;

  void handleStateChange(AppState state) {
    if (_canvasScale != state.canvasScale ||
          _selectionPath != state.selectionPath ) {
      if (state.selectionPath != null) {
        _selectionPath = Path.from(state.selectionPath);
      }
      else {
        _selectionPath = null;
      }
      _canvasScale = state.canvasScale;
      _repaintNotifier.notifyListeners();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_selectionPath != null) {
      canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
      Path drawPath = Path();
      drawPath.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
//      canvas.drawPath(Path.combine(PathOperation.difference, drawPath, _selectionPath), Paint()
//        ..color = Theme.of(context).primaryColor.withOpacity(0.2)
//        ..strokeWidth = 4.0 / _canvasScale
//        ..filterQuality = FilterQuality.none
//        ..isAntiAlias = true
//      );
      canvas.drawPath(_selectionPath, Paint()
        ..style = PaintingStyle.stroke
        ..color = Theme.of(context).highlightColor
        ..strokeWidth = 3.0 / _canvasScale
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true
      );
    }
  }

  @override
  bool shouldRepaint(SelectToolOverlayPainter oldDelegate) => true;
}


class SelectToolOverlay extends StatelessWidget {
  CustomPaint canvas;

  SelectToolOverlay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: CustomPaint(
          willChange: true,
          painter: SelectToolOverlayPainter(context),
        )
    );
  }
}