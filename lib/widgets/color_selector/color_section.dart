import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/widgets/common/horizontal_divider.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_add_button.dart';
import 'package:project_pickle/widgets/color_selector/palette_list.dart';

typedef SetActiveColorCallback = void Function(int, Color);
typedef SetColorCallback = void Function(Color);
typedef SetColorTypeCallback = void Function(ColorType);
typedef SetColorIndexCallback = void Function(int);

class ColorSection extends StatelessWidget {
  const ColorSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).unselectedWidgetColor,
              border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor, width: 2.0),
                  right: BorderSide(color: Theme.of(context).dividerColor, width: 2.0)
              ),
            ),
            child: PaletteList(),
          ),
        ),
        HorizontalDivider(height: 2.0),
        Padding(
            padding: EdgeInsets.all(12.0),
            child: SizedBox(
              height: 40.0,
              child: StoreBuilder<AppState>(
                  builder: (context, store) {
//                    return RaisedButton(
//                      elevation: 0.0,
//                      highlightElevation: 0.0,
//                      shape: RoundedRectangleBorder(
//                        side: BorderSide(
//                          width: 2.0,
//                          color: Theme
//                              .of(context)
//                              .dividerColor,
//                        ),
//                        borderRadius: BorderRadius.circular(8.0),
//                      ),
//                      color: Theme
//                          .of(context)
//                          .scaffoldBackgroundColor,
//                      padding: EdgeInsets.zero,
//                      onPressed: () => store.dispatch(AddNewColorToPaletteAction()),
//                      child: Center(child: Icon(Icons.add)),
//                    );
                    return ColorAddButton(
                      color: Colors.red,
                      onAccepted: (color) => store.dispatch(AddNewColorToPaletteAction(color)),
                    );
                  }
              ),
            )
        )
      ],
    );
  }
}
