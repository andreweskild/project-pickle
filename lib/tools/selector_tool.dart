import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';

class SelectorTool extends BaseTool<Null> {
  VoidCallback onSelectionFinished;

  SelectorTool(context) : super(
    context, null
  );

  void setSelectionPath(Path path) {
    store.dispatch(SetSelectionPathAction(path));
  }

  void deselectPath() {
    store.dispatch(DeselectAction());
  }

}