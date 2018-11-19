import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_card.dart';
import 'package:project_pickle/widgets/common/horizontal_divider.dart';
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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(right: BorderSide(color: Theme.of(context).dividerColor, width: 2.0))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ToolsCard(),
                HorizontalDivider(
                  height: 2.0,
                ),
                Expanded(child: ColorCard()),
              ],
            ),
          ),
        );
      },
    );
  }
}
