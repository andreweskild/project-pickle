import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';

typedef SetColorCallback = void Function(HSLColor);
typedef SetColorTypeCallback = void Function(ColorType);

class ColorCardModel {
  ColorCardModel({
    this.activeColorType,
    this.addToPalette,
    this.primaryColor,
    this.secondaryColor,
    this.palette,
    this.setActiveColorTypeCallback,
    this.setPrimaryColorCallback,
    this.setSecondaryColorCallback,
  });

  final ColorType activeColorType;
  final HSLColor primaryColor;
  final HSLColor secondaryColor;
  VoidCallback addToPalette;
  final List<HSLColor> palette;
  final SetColorTypeCallback setActiveColorTypeCallback;
  final SetColorCallback setPrimaryColorCallback;
  final SetColorCallback setSecondaryColorCallback;

  @override
  int get hashCode {
    int result = 17;
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
    return (model.palette.length == palette.length &&
        model.activeColorType == activeColorType &&
        model.primaryColor == primaryColor &&
        model.secondaryColor == secondaryColor);
  }
}

Color _getContrastingColor(Color color) {
  if (color.computeLuminance() > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
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
            activeColorType: store.state.activeColorType,
            primaryColor: store.state.primaryColor,
            secondaryColor: store.state.secondaryColor,
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.33,
                        child: ColorMenuButton(
                          color: model.primaryColor,
                          active:
                              model.activeColorType == ColorType.Primary,
                          onColorChanged: model.setPrimaryColorCallback,
                          onToggled: () {
                            model.setActiveColorTypeCallback(
                                ColorType.Primary);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: AspectRatio(
                        aspectRatio: 1.33,
                          child: ColorMenuButton(
                            color: model.secondaryColor,
                            active: model.activeColorType ==
                                ColorType.Secondary,
                            onColorChanged:
                                model.setSecondaryColorCallback,
                            onToggled: () {
                              model.setActiveColorTypeCallback(
                                  ColorType.Secondary);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).unselectedWidgetColor,
                    border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: GridView.count(
                    padding: EdgeInsets.all(12.0),
                    primary: false,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    crossAxisCount: 1,
                    childAspectRatio: 1.33,
                    shrinkWrap: false,
                    children: model.palette
                        .map((hslColor) => new RaisedButton(
                              elevation: 0.0,
                              color: hslColor.toColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                side: BorderSide(color: Colors.black12, width: 2.0),
                              ),
                              onPressed: () {
                                if (model.activeColorType ==
                                    ColorType.Primary) {
                                  model.setPrimaryColorCallback(hslColor);
                                } else {
                                  model.setSecondaryColorCallback(hslColor);
                                }
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
