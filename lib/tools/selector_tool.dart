import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/tools/base_tool.dart';

/// Base class for selector tools.
/// Provides basic functionality for interacting with the state.
class SelectorTool extends BaseTool<Null> {
  VoidCallback onSelectionFinished;

  SelectorTool(context) : super(context);


  void setSelectionPath(Path path) {
    store.dispatch(SetSelectionPathAction(path));
  }

  void deselectPath() {
    store.dispatch(DeselectAction());
  }

}