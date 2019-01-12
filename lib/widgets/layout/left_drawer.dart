import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_section.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';

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
          width: 72.0,
          child: Material(
            color: Theme.of(context).unselectedWidgetColor,
            elevation: 8.0,
            shadowColor: Colors.black38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ToolsCard(),
                Expanded(child: ColorSection()),
              ],
            ),
          ),
        );
      },
    );
  }
}
