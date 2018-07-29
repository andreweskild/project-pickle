import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/common/outline_icon_button.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';

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
    return DrawerCard(
        title: 'Color',
        builder: (context, collapsed) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: StoreConnector<AppState, ColorCardModel>(
              converter: (store) {
                return ColorCardModel(
                  color: store.state.currentColor,
                  setColorCallback: (newColor) => store.dispatch(SetCurrentColorAction(newColor)),
                );
              },
              builder: (context, model) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        width: 190.0,
                        child: ColorMenuButton(
                          color: model.color,
                          onColorChanged: model.setColorCallback,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: OutlineIconButton(
                        icon: Icons.colorize,
                        onPressed: () {},
                      ),
                    ),
                  ],
                );
              }
            ),
          );
        }
    );
  }
}