import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/tool.dart';

class SelectorTool extends Tool {
  VoidCallback onSelectionFinished;
  Store<AppState> _store;

  void handleSelectionPosUpdate(Offset pos) => {};
  void handleSelectionEnd() => {};

  SelectorTool(context) : super(context) {
    _store = StoreProvider.of<AppState>(context);
  }

  void setSelectionPath(Path path) {
    _store.dispatch(SetSelectionPath(path));
  }

  void deselectPath() {
    _store.dispatch(DeselectAction());
  }

}