import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';

typedef SetActiveColorCallback = void Function(int, HSLColor);
typedef SetColorCallback = void Function(HSLColor);
typedef SetColorTypeCallback = void Function(ColorType);
typedef SetColorIndexCallback = void Function(int);

class ColorCardModel {
  ColorCardModel({
    this.activeColorIndex,
    this.activeColorType,
    this.addToPalette,
    this.primaryColor,
    this.secondaryColor,
    this.palette,
    this.setActiveColorTypeCallback,
    this.setActiveColorCallback,
    this.setPrimaryColorCallback,
    this.setSecondaryColorCallback,
    this.setActiveColorIndexCallback,
  });

  final ColorType activeColorType;
  final int activeColorIndex;
  final HSLColor primaryColor;
  final HSLColor secondaryColor;
  VoidCallback addToPalette;
  final List<HSLColor> palette;
  final SetColorIndexCallback setActiveColorIndexCallback;
  final SetColorTypeCallback setActiveColorTypeCallback;
  final SetColorCallback setPrimaryColorCallback;
  final SetColorCallback setSecondaryColorCallback;
  final SetActiveColorCallback setActiveColorCallback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + activeColorIndex.hashCode;
    result = 37 * result + activeColorType.hashCode;
    result = 37 * result + primaryColor.hashCode;
    result = 37 * result + secondaryColor.hashCode;
    result = 37 * result + palette.hashCode;
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
        model.activeColorType == activeColorType &&
        model.primaryColor == primaryColor &&
        model.secondaryColor == secondaryColor);
  }
}

class ColorCard extends StatelessWidget {
  const ColorCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ColorCardModel>(
        ignoreChange: (state) => !state.canvasDirty,
        converter: (store) {
          return ColorCardModel(
            activeColorIndex: store.state.activeColorIndex,
            activeColorType: store.state.activeColorType,
            primaryColor: store.state.primaryColor,
            secondaryColor: store.state.secondaryColor,
            setActiveColorCallback: (index, newColor) =>
                store.dispatch(SetPaletteColorAction(index, newColor)),
            setActiveColorIndexCallback: (index) =>
                store.dispatch(SetActiveColorIndexAction(index)),
            setActiveColorTypeCallback: (colorType) =>
                store.dispatch(SetActiveColorTypeAction(colorType)),
            setPrimaryColorCallback: (newColor) =>
                store.dispatch(SetPrimaryColorAction(newColor)),
            setSecondaryColorCallback: (newColor) =>
                store.dispatch(SetSecondaryColorAction(newColor)),
            palette: store.state.palette,
          );
        },
        builder: (context, model) {
          return Column(
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: Column(
//                  children: <Widget>[
//                    AspectRatio(
//                      aspectRatio: 1.2,
//                        child: ColorMenuButton(
//                          color: model.primaryColor,
//                          active:
//                              model.activeColorType == ColorType.Primary,
//                          onColorChanged: model.setPrimaryColorCallback,
//                          onToggled: () {
//                            model.setActiveColorTypeCallback(
//                                ColorType.Primary);
//                          }),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(top: 12.0),
//                      child: AspectRatio(
//                        aspectRatio: 1.2,
//                          child: ColorMenuButton(
//                            color: model.secondaryColor,
//                            active: model.activeColorType ==
//                                ColorType.Secondary,
//                            onColorChanged:
//                                model.setSecondaryColorCallback,
//                            onToggled: () {
//                              model.setActiveColorTypeCallback(
//                                  ColorType.Secondary);
//                            }),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
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
                    primary: false,
                    shrinkWrap: false,
                    children: List.generate(
                      model.palette.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            height: 32.0,
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
                    )
//                    children: model.palette
//                        .map((hslColor) => Padding(
//                          padding: const EdgeInsets.all(6.0),
//                          child: SizedBox(
//                            height: 32.0,
//                            child: new ColorMenuButton(
//                                  onColorChanged: (color){},
//                                  onToggled: (){},
//                                  color: hslColor,
//                                ),
//                          ),
//                        ))
//                        .toList(),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
