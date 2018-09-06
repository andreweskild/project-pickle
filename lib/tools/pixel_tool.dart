import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/widgets/common/toggle_button_group.dart';
import 'package:project_pickle/widgets/common/toggle_button.dart';
import 'package:project_pickle/widgets/common/vertical_divider.dart';

class PixelTool extends BaseDrawingTool {
  PixelTool(context) : super(context) {

  }

  Offset _lastPoint;

  get options => <Widget>[
//    Padding(
//      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//      child: Padding(
//        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//        child: Row(
//          children: <Widget>[
//            OutlineButton(
//              borderSide: BorderSide(
//                color: Colors.black26,
//              ),
//              highlightedBorderColor: Colors.black26,
//              child: Center(child: Icon(Icons.remove)),
//              padding: const EdgeInsets.all(8.0),
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(6.0),
//                  bottomLeft: Radius.circular(6.0),
//                ),
//              ),
//              onPressed: (){},
//            ),
//            Material(
//              elevation: 0.0,
//              color: Colors.white,
//              shape: Border(
//                top: BorderSide(color: Colors.black26, width: 1.0),
//                bottom: BorderSide(color: Colors.black26, width: 1.0),
//              ),
//              child: Center(
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: SizedBox(
//                    width: 48.0,
//                    height: 26.0,
//                    child: TextField(
//                      decoration: InputDecoration(
//                        counterText: '',
//                        contentPadding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
//                      ),
//                      maxLength: 3,
//                      keyboardType: TextInputType.number,
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            OutlineButton(
//              borderSide: BorderSide(
//                color: Colors.black26
//              ),
//              child: Icon(Icons.add),
//              padding: const EdgeInsets.all(8.0),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.only(
//                    topRight: Radius.circular(6.0),
//                    bottomRight: Radius.circular(6.0),
//                  )
//              ),
//              onPressed: (){},
//            )
//          ],
//        ),
//      )
//    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
            child: Text('Size'),
          ),
          Slider(
            min: 0.0,
            max: 1.0,
            value: 0.0,
            onChanged: (value){},
          ),
          SizedBox(
            width: 20.0,
            child: Center(
              child: TextField(
                maxLength: 3,
                decoration: null
              ),
            ),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
      child: Text('Shape')
    ),
    ToggleButtonGroup<int>(
      groupValue: 2,
      borderRadius: BorderRadius.circular(6.0),
      side: BorderSide(color: Colors.black26),
      onChanged: (value){},
      actions: <ToggleButtonAction<int>>[
        ToggleButtonAction<int>(
          icon: Icon(Icons.brightness_1),
          onChanged: (value){},
          groupValue: 2,
          value: 1,
        ),
        ToggleButtonAction<int>(
          icon: Icon(Icons.crop_square),
          onChanged: (value){},
          groupValue: 2,
          value: 1,
        )
      ],
    )
  ];


  @override
  void onPixelInputUpdate(Offset pos) {
    if ( _lastPoint != null &&
        ((_lastPoint.dx - pos.dx).abs() > 1 ||
            (_lastPoint.dy - pos.dy).abs() > 1)) {
      drawOverlayPixelLine(_lastPoint, pos);
    }
    else {
      drawOverlayPixel(pos);
    }
    _lastPoint = pos;
  }

  @override
  void onPixelInputUp() {
    saveOverlayToLayer();
    _lastPoint = null;
  }

}