import '../tools/tool_types.dart';

class SetCurrentToolTypeAction {
  final ToolType toolType;

  SetCurrentToolTypeAction(this.toolType);
}

class AppState {
  AppState({
    this.currentToolType
  });

  ToolType currentToolType;
}

AppState stateReducer(AppState state, dynamic action) {
  
  if (action is SetCurrentToolTypeAction) {
    return new AppState(
      currentToolType: action.toolType
    );
  }
  else {
    return state;
  }
}