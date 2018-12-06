import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/common/horizontal_divider.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';

typedef SetActiveColorCallback = void Function(int, Color);
typedef SetColorCallback = void Function(Color);
typedef SetColorTypeCallback = void Function(ColorType);
typedef SetColorIndexCallback = void Function(int);

class ColorCardModel {
  ColorCardModel({
    this.activeColorIndex,
    this.addToPalette,
    this.palette,
    this.setActiveColorCallback,
    this.setActiveColorIndexCallback,
  });

  final int activeColorIndex;
  VoidCallback addToPalette;
  final List<Color> palette;
  final SetColorIndexCallback setActiveColorIndexCallback;
  final SetActiveColorCallback setActiveColorCallback;

  Color get activeColor => palette[activeColorIndex];

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + activeColorIndex.hashCode;
    result = 37 * result + palette.hashCode;
    result = 37 * result + activeColor.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! ColorCardModel) return false;
    ColorCardModel model = other;
    return (model.activeColorIndex == activeColorIndex &&
        model.palette.length == palette.length &&
        model.activeColor == activeColor);
  }
}

class ColorCard extends StatelessWidget {
  const ColorCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ColorCardModel>(
        distinct: true,
        converter: (store) {
          return ColorCardModel(
            addToPalette: () => store.dispatch(AddNewColorToPaletteAction()),
            activeColorIndex: store.state.activeColorIndex,
            setActiveColorCallback: (index, newColor) =>
                store.dispatch(SetPaletteColorAction(index, newColor)),
            setActiveColorIndexCallback: (index) =>
                store.dispatch(SetActiveColorIndexAction(index)),
            palette: List.from(store.state.palette),
          );
        },
        builder: (context, model) {
          List<Widget> colors = List.generate(
            model.palette.length,
            (index) {
              return Padding(
                key: Key(model.palette[index].toString() + index.toString()),
                padding: const EdgeInsets.all(6.0),
                child: SizedBox(
                  height: 40.0,
                  child: ColorMenuButton (
                    active: model.activeColorIndex == index,
                    onColorChanged: (color){
                      model.setActiveColorCallback(index, color);
                    },
                    onToggled: () => model.setActiveColorIndexCallback(index),
                    color: model.palette[index],
                  ),
                ),
              );
            }
          );
          return Column(
            children: <Widget>[
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).unselectedWidgetColor,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor, width: 2.0),
                      right: BorderSide(color: Theme.of(context).dividerColor, width: 2.0)
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(6.0),
                    children: colors,
                  ),
                ),
              ),
              HorizontalDivider(height: 2.0),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 40.0,
                  child: StoreBuilder<AppState>(
                    builder: (context, store) {
                      return RaisedButton(
                        elevation: 0.0,
                        highlightElevation: 0.0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2.0,
                            color: Theme
                                .of(context)
                                .dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Theme
                            .of(context)
                            .scaffoldBackgroundColor,
                        padding: EdgeInsets.zero,
                        onPressed: () => store.dispatch(AddNewColorToPaletteAction()),
                        child: Center(child: Icon(Icons.add)),
                      );
                    }
                  ),
                )
              )
            ],
          );
        });
  }
}
