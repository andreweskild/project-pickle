import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'pages/pixel_editor_page.dart';
import 'pages/projects_page.dart';
import 'state/app_state.dart';
import 'tools/tool_types.dart';

final store = new Store<AppState>(
  stateReducer,
  initialState: new AppState(
    currentToolType: ToolType.pencil
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'Project pickle',
        theme: new ThemeData(
          accentColor: Colors.amber,
          primarySwatch: Colors.amber,
          splashColor: Colors.amber,
          highlightColor: Colors.amberAccent,
        ),
        home: new PixelEditorPage(
          name: 'Pickle Editor'
        ),
      ),
    );
  }
}