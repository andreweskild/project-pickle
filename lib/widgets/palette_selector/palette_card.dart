import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/left_drawer_card.dart';

typedef void ColorSetCallback(hslColor);

class _PaletteModel {
  final List<HSLColor> palette;
  final HSLColor currentColor;
  VoidCallback addToPalette;
  ColorSetCallback setCurrentColor;

  _PaletteModel({
    this.addToPalette,
    this.currentColor,
    this.palette,
    this.setCurrentColor,
  });

  
  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + palette.hashCode;
    result = 37 * result + currentColor.hashCode;
    result = 37 * result + addToPalette.hashCode;
    result = 37 * result + setCurrentColor.hashCode;
    return result;
  }
  
  @override
  bool operator ==(dynamic other) {
    if (other is! _PaletteModel) return false;
    _PaletteModel model = other;
    return (model.palette.length == palette.length &&
        model.currentColor == currentColor &&
        model.addToPalette == addToPalette &&
        model.setCurrentColor == setCurrentColor);
  }
}


Color getContrastingColor(Color color) {
  if (color.computeLuminance() > 0.5) {
    return Colors.black;
  }
  else {
    return Colors.white;
  }
}

class PaletteCard extends StatelessWidget {
  const PaletteCard({
    Key key,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return new LeftDrawerCard(
      title: 'Palette',
      children: <Widget>[
        new Expanded(
          child: new StoreConnector<AppState, _PaletteModel>(
            distinct: true,
            converter: (store) => new _PaletteModel(
              currentColor: store.state.currentColor,
              addToPalette: () => store.dispatch(
                new AddCurrentColorToPaletteAction(),
              ),
              palette: store.state.palette,
              setCurrentColor: (color) => store.dispatch(
                new SetCurrentColorAction(color)
              )
            ),
            builder: (context, paletteModel) {
              return new Stack(
                children: <Widget>[
                  new GridView.count(
                    padding: new EdgeInsets.all(8.0),
                    primary: false,
                    crossAxisSpacing: 8.0,
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    children: paletteModel.palette.map(
                      (hslColor) => new RaisedButton(
                        elevation: 1.0,
                        child: (hslColor == paletteModel.currentColor) ? 
                          new Icon(Icons.check, color: Colors.white,) : null,
                        color: (hslColor == paletteModel.currentColor) ? 
                          Color.lerp(hslColor.toColor(), Colors.black, 0.3) : hslColor.toColor(),
                        shape: new RoundedRectangleBorder( borderRadius: new BorderRadius.all(new Radius.circular(16.0))),
                        onPressed: () {
                          paletteModel.setCurrentColor(new HSLColor.from(hslColor));
                        },
                      )
                    ).toList(),
                    mainAxisSpacing: 8.0,
                  ),
                  new Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new FloatingActionButton(
                        backgroundColor: paletteModel.currentColor.toColor(),
                        child: new Icon(Icons.add, color: getContrastingColor(paletteModel.currentColor.toColor()),),
                        onPressed: () {
                          if (!paletteModel.palette.contains(paletteModel.currentColor)) {
                            paletteModel.addToPalette();
                          }
                        },
                        mini: true,
                        shape: new RoundedRectangleBorder( borderRadius: new BorderRadius.all(new Radius.circular(12.0))),
                        tooltip: 'Add Current Color to Palette',
                      ),
                    ),
                  )
                ]
              );
            }
          ),
        )
      ],
    );
  }
}