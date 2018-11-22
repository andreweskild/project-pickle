import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/theme.dart';
import 'package:project_pickle/canvas/pixel_buffer.dart';
import 'package:project_pickle/pages/pixel_editor_page.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/state/middleware.dart';
import 'package:project_pickle/state/reducer.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';



final store = Store<AppState>(
  stateReducer,
  middleware: <Middleware<AppState>>[
    TypedMiddleware<AppState, UndoAction>(undoMiddleware),
    TypedMiddleware<AppState, RedoAction>(redoMiddleware),
    TypedMiddleware<AppState, FinalizePixelBufferAction>(recordHistoryMiddleware),
    TypedMiddleware<AppState, FillAreaAction>(recordHistoryMiddleware),
    TypedMiddleware<AppState, AddNewLayerAction>(recordHistoryMiddleware),
    TypedMiddleware<AppState, RemoveLayerAction>(recordHistoryMiddleware),
    TypedMiddleware<AppState, EraseStartAction>(recordHistoryMiddleware),
  ],
  initialState: AppState(
    canvasHistory: Queue<PixelLayerList>(),
    canvasFuture: Queue<PixelLayerList>(),
    canvasWidth: 32,
    canvasHeight: 32,
    drawingBuffer: PixelBuffer(32, 32),
    primaryColor: HSLColor.fromAHSL(1.0, 1.0, 1.0, 1.0),
    secondaryColor: HSLColor.fromAHSL(1.0, 100.0, 1.0, 0.5),
    layers: PixelLayerList()..add(
      PixelLayer(
        name: 'Layer 1',
        width: 32,
        height: 32,
      )
    ),
    palette: <HSLColor>[
      HSLColor.fromAHSL(1.0, 34.0, 0.5, 0.4),
      HSLColor.fromAHSL(1.0, 25.0, 0.8, 0.4),
      HSLColor.fromAHSL(1.0, 155.4, 0.6, 0.6),
      HSLColor.fromAHSL(1.0, 300.8, 0.9, 0.7),
    ],
  ),
);




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Project pickle',
        theme: theme(context),
        home: PixelEditorPage(name: 'Pickle Editor'),
      ),
    );
  }
}
