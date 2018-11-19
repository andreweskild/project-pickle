import 'package:redux/redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

void _rollbackLayerState(Store<AppState> store) {
  store.state.canvasFuture.add(
    store.state.layers
  );
  store.state.layers = store.state.canvasHistory.removeLast();
}

final undoMiddleware = (
    Store<AppState> store,
    UndoAction action,
    NextDispatcher next
) {
  if (store.state.canvasHistory.isNotEmpty) {
    _rollbackLayerState(store);
    store.state.canvasDirty = true;
    next(action);
  }
};

void _rollForwardLayerState(Store<AppState> store) {
  store.state.canvasHistory.add(
      store.state.layers
  );
  store.state.layers = store.state.canvasFuture.removeLast();
}

final redoMiddleware = (
    Store<AppState> store,
    RedoAction action,
    NextDispatcher next
) {
  if (store.state.canvasFuture.isNotEmpty) {
    _rollForwardLayerState(store);
    store.state.canvasDirty = true;
    next(action);
  }
};

void _saveLayerState(Store<AppState> store) {
  store.state.canvasHistory.add(PixelLayerList.from(store.state.layers));
  store.state.canvasFuture.clear();
}

final recordHistoryMiddleware = (
    Store<AppState> store,
    dynamic action,
    NextDispatcher next
) {
  _saveLayerState(store);
  next(action);
};