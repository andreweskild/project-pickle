import 'dart:ui';

//import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_add_button.dart';
import 'package:project_pickle/widgets/color_selector/palette_list.dart';


double _kBlurAmount = 20.0;

typedef SetActiveColorCallback = void Function(int, Color);
typedef SetColorCallback = void Function(Color);
typedef SetColorIndexCallback = void Function(int);

class ColorSection extends StatelessWidget {
  const ColorSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: PaletteList(),
        ),
        StoreBuilder<AppState>(
          rebuildOnChange: false,
          builder: (context, store) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ColorAddButton(
                color: Colors.red,
                onAccepted: (color) => store.dispatch(AddNewColorToPaletteAction(color)),
              ),
            );
          }
        ),
      ],
    );
  }
}
