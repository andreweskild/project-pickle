import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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



//final store = Store<AppState>(
//  stateReducer,
//  middleware: <Middleware<AppState>>[
//    TypedMiddleware<AppState, UndoAction>(undoMiddleware),
//    TypedMiddleware<AppState, RedoAction>(redoMiddleware),
//    TypedMiddleware<AppState, FinalizePixelBufferAction>(recordHistoryMiddleware),
//    TypedMiddleware<AppState, FillAreaAction>(recordHistoryMiddleware),
//    TypedMiddleware<AppState, AddNewLayerAction>(recordHistoryMiddleware),
//    TypedMiddleware<AppState, RemoveLayerAction>(recordHistoryMiddleware),
//    TypedMiddleware<AppState, EraseStartAction>(recordHistoryMiddleware),
//  ],
//  initialState: AppState(
//    canvasHistory: Queue<PixelLayerList>(),
//    canvasFuture: Queue<PixelLayerList>(),
//    canvasWidth: 32,
//    canvasHeight: 32,
//    darkMode: false,
//    drawingBuffer: PixelBuffer(32, 32),
//    layers: PixelLayerList(),
////    layers: PixelLayerList()..add(
////      PixelLayer(
////        name: 'Layer 1',
////        width: 32,
////        height: 32,
////      )
////    ),
//    palette: <Color>[
//      Colors.purple,
//      Colors.amber,
//      Colors.red,
//      Colors.green,
//      Colors.blue,
//      Colors.orange,
//      Colors.cyanAccent
//    ],
//  ),
//);

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//      statusBarColor: Color(0xFFC4FB81),
//      systemNavigationBarColor: Color(0xFFC4FB81),
//      systemNavigationBarDividerColor: Color(0xFFC4FB81),
//      //or set color with: Color(0xFF0000FF)
//    ));
//    return StoreProvider(
//      store: store,
//      child: MaterialApp(
//        title: 'Project pickle',
//        theme: theme(context, store.state.darkMode),
//        home: PixelEditorPage(name: 'Pickle Editor'),
//      ),
//    );
//  }
//}

class MyApp extends StatefulWidget {
  @override
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin{
  Store<AppState> _store;

  @override
  void initState() {
    _store = Store<AppState>(
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
        darkMode: false,
        drawingBuffer: PixelBuffer(32, 32),
        layers: PixelLayerList(),
//    layers: PixelLayerList()..add(
//      PixelLayer(
//        name: 'Layer 1',
//        width: 32,
//        height: 32,
//      )
//    ),
        palette: <Color>[
          Colors.purple,
          Colors.amber,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.cyanAccent
        ],
        tickerProvider: this
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xFFECEAEC),
      systemNavigationBarColor: Color(0xFFC4FB81),
      systemNavigationBarDividerColor: Color(0xFFC4FB81),
      //or set color with: Color(0xFF0000FF)
    ));
    return StoreProvider(
      store: _store,
      child: MaterialApp(
        title: 'Project pickle',
        theme: theme(context, _store.state.darkMode),
        home: PixelEditorPage(name: 'Pickle Editor'),
      ),
    );
  }
}
