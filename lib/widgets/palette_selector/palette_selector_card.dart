import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';

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
    return DrawerCard(
      title: 'Palette',
      builder: (context, collapsed) {
        return Expanded(
          child: StoreConnector<AppState, _PaletteModel>(
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
              return Stack(
                children: <Widget>[
                  GridView.extent(
                    padding: EdgeInsets.all(12.0),
                    primary: false,
                    crossAxisSpacing: 12.0,
                    maxCrossAxisExtent: 48.0,
                    childAspectRatio: 1.0,
                    shrinkWrap: false,
                    children: paletteModel.palette.map(
                      (hslColor) => new RaisedButton(
                        elevation: 1.0,
                        color: hslColor.toColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          side: BorderSide(color: Colors.black38),
                        ),
                        onPressed: () {
                          paletteModel.setCurrentColor(HSLColor.from(hslColor));
                        },
                      )
                    ).toList(),
                    mainAxisSpacing: 12.0,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RaisedButton(
                        color: paletteModel.currentColor.toColor(),
                        child: SizedBox(
                          height: 40.0,
                          width: 128.0,
                          child: Stack(
                            children: <Widget>[
                              AnimatedAlign(
                                duration: Duration(milliseconds: 150),
                                alignment: (collapsed) ? Alignment.center : Alignment.centerLeft, 
                                child: Icon(
                                  Icons.add,
                                  color: _getContrastingColor(paletteModel.currentColor.toColor()),
                                )
                              ),
                              Positioned(
                                left: 32.0, 
                                bottom: 0.0,
                                top: 0.0,
                                child: Center(
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 150),
                                    opacity: (collapsed) ? 0.0 : 1.0,
                                    child: Text(
                                      'Add to Palette',
                                      style: TextStyle(
                                        color: _getContrastingColor(paletteModel.currentColor.toColor()),
                                      )
                                    )
                                  )
                                )
                              )
                            ]
                          ),
                        ),
                        onPressed: paletteModel.addToPalette,
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          side: BorderSide(color: Colors.black38)
                        ),
                      ),
                    ),
                  ),
                ]
              );
            }
          ),
        );
      }
    );
  }
}