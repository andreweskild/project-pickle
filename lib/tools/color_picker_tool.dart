import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';

class ColorPickerTool extends BaseTool<Widget> {
  ColorPickerTool(context)
      : super(
      context,
      Placeholder(color: Colors.black12),
  );

  Color _currentSelectedColor;


  @override
  void onPixelInputUpdate(Offset pos) {
    _currentSelectedColor = getPixelColor(pos);
  }

  @override
  void onPixelInputUp() {
    updateCurrentColor(_currentSelectedColor);
    _currentSelectedColor = null;
  }


  Color getPixelColor(Offset pos) {
    for (var layer in store.state.layers.reversed.where((layer) => !layer.hidden)) {
      if (layer.pixels.containsKey(pos)) {
        return layer.pixels[pos];
      }
    }

    return Colors.white;
  }

  void updateCurrentColor(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    if(store.state.activeColorType == ColorType.Primary) {
      store.dispatch(SetPrimaryColorAction(hslColor));
    }
    else {
      store.dispatch(SetSecondaryColorAction(hslColor));
    }
  }

}