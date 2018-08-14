import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

typedef SetColorCallback = void Function(HSLColor);

class ColorCardModel {
  ColorCardModel({
    this.color,
    this.setColorCallback,
  });

  final HSLColor color;
  final SetColorCallback setColorCallback;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + color.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! ColorCardModel) return false;
    ColorCardModel model = other;
    return (model.color == color);
  }
}

class ColorCard extends StatelessWidget {
  const ColorCard({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 12.0, right: 12.0),
      child: StoreConnector<AppState, ColorCardModel>(
        distinct: true,
        converter: (store) {
          return ColorCardModel(
            color: HSLColor.from(store.state.currentColor),
            setColorCallback: (newColor) => store.dispatch(SetCurrentColorAction(HSLColor.from(newColor))),
          );
        },
        builder: (context, model) {
          return SizedBox(
            width: 190.0,
            child: ColorMenuButton(
              color: HSLColor.from(model.color),
              onColorChanged: model.setColorCallback,
            ),
          );
        }
      ),
    );
  }
}