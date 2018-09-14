import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';

class _ToolOptionsModel {
  _ToolOptionsModel({
    this.size,
    this.opacity,
    this.sizeCallback,
    this.opacityCallback,
  });

  final double size;
  final double opacity;
  ValueChanged<double> sizeCallback;
  ValueChanged<double> opacityCallback;


  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + size.hashCode;
    result = 37 * result + opacity.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! _ToolOptionsModel) return false;
    _ToolOptionsModel model = other;
    return (model.size == size &&
        model.opacity == opacity);
  }
}

/// Small panel with controls for adjusting tool opacity and size.
///
///
class ToolOptionsPanel extends StatefulWidget {
  ToolOptionsPanel({
    Key key,
  }) : super(key: key);

  ToolOptionsPanelState createState() => ToolOptionsPanelState();
}

class ToolOptionsPanelState extends State<ToolOptionsPanel> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ToolOptionsModel>(
      distinct: true,
      converter: (store) {
        return _ToolOptionsModel(
          size: store.state.toolSize,
          opacity: store.state.toolOpacity,
          sizeCallback: (value) => store.dispatch(SetToolSizeAction(value)),
          opacityCallback: (value) => store.dispatch(SetToolOpacityAction(value)),
        );
      },
      builder: (context, model) {
        return SizedBox(
          height: 64.0,
          child: Material(
            elevation: 4.0,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12.0, bottom: 4.0),
                        child: Text('Size'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ValueSlider(
                          value: model.size,
                          min: 1.0,
                          max: 100.0,
                          onChanged: (value){
                            setState((){
                              model.sizeCallback(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12.0, bottom: 4.0),
                        child: Text('Opacity'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ValueSlider(
                          value: model.opacity,
                          onChanged: (value){
                            setState((){
                              model.opacityCallback(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}