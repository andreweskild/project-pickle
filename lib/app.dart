import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/pages/pixel_editor_page.dart';
import 'package:project_pickle/pages/projects_page.dart';
import 'package:project_pickle/state/app_state.dart';

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