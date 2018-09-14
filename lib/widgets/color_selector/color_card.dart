import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
//import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

typedef SetColorCallback = void Function(HSLColor);

class ColorCardModel {
  ColorCardModel({
    this.addToPalette,
    this.color,
    this.palette,
    this.setColorCallback,
  });

  final HSLColor color;
  VoidCallback addToPalette;
  final List<HSLColor> palette;
  final SetColorCallback setColorCallback;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + color.hashCode;
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
        model.color == color);
  }
}


Color _getContrastingColor(Color color) {
  if (color.computeLuminance() > 0.5) {
    return Colors.black;
  }
  else {
    return Colors.white;
  }
}

class ColorCard extends StatelessWidget {
  const ColorCard({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          )
      ),
      child: StoreConnector<AppState, ColorCardModel>(
        distinct: true,
        converter: (store) {
          return ColorCardModel(
            color: store.state.currentColor,
            setColorCallback: (newColor) => store.dispatch(SetCurrentColorAction(newColor)),
            palette: store.state.palette,
          );
        },
        builder: (context, model) {
          return Column(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 40.0),
                        child: ColorMenuButton(
                          color: model.color,
                          onColorChanged: model.setColorCallback,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.expand(height: 40.0),
                          child: ColorMenuButton(
                            color: model.color,
                            onColorChanged: model.setColorCallback,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.extent(
                  padding: EdgeInsets.all(12.0),
                  primary: false,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  maxCrossAxisExtent: 48.0,
                  childAspectRatio: 1.0,
                  shrinkWrap: false,
                  children: model.palette.map(
                          (hslColor) => new RaisedButton(
                        elevation: 0.0,
                        color: hslColor.toColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          side: BorderSide(color: Colors.black26),
                        ),
                        onPressed: () {
                          model.setColorCallback(hslColor);
                        },
                      )
                  ).toList(),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}