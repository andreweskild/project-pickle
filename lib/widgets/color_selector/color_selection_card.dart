import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/app_state.dart';

typedef void ColorUpdateCallback(
  HSLColor color, 
  {double h, double s, double l}
);

class _ColorModel {
  ColorUpdateCallback callback;
  HSLColor currentColor;

  _ColorModel({
    this.callback,
    this.currentColor,
  });


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + currentColor.hashCode;
    result = 37 * result + callback.hashCode;
    return result;
  }
  
  @override
  bool operator ==(dynamic other) {
    if (other is! _ColorModel) return false;
    _ColorModel model = other;
    return (model.currentColor == currentColor &&
      model.callback == callback);
  }
}


class ColorSelectionCard extends StatelessWidget {
  double _h, _s, _l;


  HSLColor updateColorWith(HSLColor color, {double h, double s, double l}) {
    if (h != null) color.h = h;
    if (s != null) color.s = s;
    if (l != null) color.l = l;
    return color;
  }

  Color getContrastingColor(Color color) {
    if (color.computeLuminance() > 0.5) {
      return Colors.black;
    }
    else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: new Card(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0)
        ),
        child: StoreConnector<AppState, _ColorModel>(
          distinct: true,
          converter: (store) {
            return new _ColorModel(
              callback: (color, {h, s, l}) {
                store.dispatch(
                  new SetCurrentColorAction(
                    updateColorWith(color, h: h, s: s, l: l)
                  )
                );
              },
              currentColor: store.state.currentColor,
            );
          },
          builder: (context, colorModel) {
            return new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Material(
                  elevation: 1.0,
                  color: colorModel.currentColor.toColor(),
                  borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(16.0), 
                    topRight: new Radius.circular(16.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 48.0),
                    child: new ListTile(
                      title: Text(
                        "Color", 
                        textAlign: TextAlign.start,
                        style: new TextStyle(
                          color: getContrastingColor(colorModel.currentColor.toColor())
                        ),
                      ),
                      trailing: new IconButton(
                        icon: new Icon(
                          Icons.arrow_back, 
                          color: getContrastingColor(colorModel.currentColor.toColor()),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text('H'),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                showValueIndicator: ShowValueIndicator.always,
                                valueIndicatorShape: new PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: colorModel.currentColor.copyWith(h: _h).toColor(),
                              ),
                              child: Slider(
                                onChanged: (value) { 
                                  colorModel.callback(colorModel.currentColor, h: value);
                                  _h = value;
                                },
                                label: '',
                                value: colorModel.currentColor.h,
                                min: 0.0,
                                max: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text('S'),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                showValueIndicator: ShowValueIndicator.always,
                                valueIndicatorShape: new PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: colorModel.currentColor.copyWith(h: _h, s: _s).toColor(),
                              ),
                              child: Slider(
                                onChanged: (value) { 
                                  colorModel.callback(colorModel.currentColor, s: value);
                                  _s = value;
                                },
                                label: '',
                                value: colorModel.currentColor.s,
                                min: 0.0,
                                max: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text('L'),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                showValueIndicator: ShowValueIndicator.always,
                                valueIndicatorShape: new PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: colorModel.currentColor.copyWith(h: _h, l: _l).toColor(),
                              ),
                              child: Slider(
                                onChanged: (value) { 
                                  colorModel.callback(colorModel.currentColor, l: value);
                                  _l = value;
                                },
                                label: '',
                                value: colorModel.currentColor.l,
                                min: 0.0,
                                max: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}