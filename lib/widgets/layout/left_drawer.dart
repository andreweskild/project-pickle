import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_card.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_selector_card.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        return SizedBox(
          width: 192.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ToolsCard(),
                Expanded(child: ColorCard()),
//                Divider(height: 1.0),
//                Expanded(
//                    child: PaletteSelectorCard()
//                ),
              ],
            ),
          ),
//          onSizeModeChanged: (sizeMode) {
//            store.dispatch(SetLeftDrawerSizeModeAction(sizeMode));
//          },
        );
      },
    );
  }
}