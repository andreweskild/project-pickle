import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';

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
    return result;
  }
  
  @override
  bool operator ==(dynamic other) {
    if (other is! _PaletteModel) return false;
    _PaletteModel model = other;
    return (model.palette.length == palette.length &&
        model.currentColor == currentColor);
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

class PaletteSelectorCard extends StatelessWidget {
  const PaletteSelectorCard({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
        return StoreConnector<AppState, _PaletteModel>(
          distinct: true,
          converter: (store) => _PaletteModel(
            currentColor: HSLColor.from(store.state.currentColor),
            addToPalette: () => store.dispatch(
              AddCurrentColorToPaletteAction(),
            ),
            palette: store.state.palette,
            setCurrentColor: (color) => store.dispatch(
              SetCurrentColorAction(color)
            )
          ),
          builder: (context, paletteModel) {
            return Material(
              color: Colors.grey.shade200,
              child: Stack(
                children: <Widget>[
                  GridView.extent(
                    padding: EdgeInsets.all(8.0),
                    primary: false,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    maxCrossAxisExtent: 48.0,
                    childAspectRatio: 1.0,
                    shrinkWrap: false,
                    children: paletteModel.palette.map(
                      (hslColor) => new RaisedButton(
                        elevation: 2.0,
                        color: hslColor.toColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          side: BorderSide(color: Colors.black38),
                        ),
                        onPressed: () {
                          paletteModel.setCurrentColor(HSLColor.from(hslColor));
                        },
                      )
                    ).toList(),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: SizedBox(
                      height: 48.0,
                      child: RaisedButton.icon(
                        elevation: 0.0,
                        color: paletteModel.currentColor.toColor(),
                        icon: Icon(Icons.add, color: _getContrastingColor(paletteModel.currentColor.toColor())),
                        label: Text('Add Color',
                          style: TextStyle(
                            color: _getContrastingColor(paletteModel.currentColor.toColor()),
                          ),),
                        onPressed: paletteModel.addToPalette,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Colors.black26,
                            )
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            );
          }
    );
  }
}