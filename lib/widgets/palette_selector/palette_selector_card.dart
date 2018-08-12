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
    @required this.sizeMode,
  }) : super(key: key);

  final DrawerSizeMode sizeMode;


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
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: GridView.extent(
                      padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                      primary: false,
                      crossAxisSpacing: 12.0,
                      maxCrossAxisExtent: 64.0,
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
                      mainAxisSpacing: 12.0,
                    ),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(12.0),
//                    child: RaisedButton(
//                      padding: const EdgeInsets.all(0.0),
//                      elevation: 2.0,
//                      color: paletteModel.currentColor.toColor(),
//                      child: Padding(
//                        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
//                        child: Row(
//                          mainAxisSize: MainAxisSize.max,
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.only(right: 3.0),
//                              child: Icon(Icons.add),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(left: 3.0),
//                              child: Text('Add Color'),
//                            ),
//                          ],
//                        ),
//                      ),
//                      onPressed: paletteModel.addToPalette,
//                      shape: RoundedRectangleBorder(
//                        side: BorderSide(
//                          color: Colors.black38,
//                        ),
//                        borderRadius: BorderRadius.circular(6.0),
//                      ),
//                    ),
//                  ),
//                Material(
//                  color: paletteModel.currentColor.toColor(),
//                  child: ListTile(
//                    contentPadding: EdgeInsets.all(0.0),
//                    trailing: IconButton(
//                      icon: Icon(Icons.add),
//                      onPressed: paletteModel.addToPalette,
//                    ),
//                  ),
//                ),
                ]
              ),
            );
          }
    );
  }
}