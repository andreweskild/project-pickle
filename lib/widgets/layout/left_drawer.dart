import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_section.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';

double _kLeftDrawerWidth = 96.0;

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
          width: _kLeftDrawerWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).unselectedWidgetColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 6.0,
                  color: Theme.of(context).brightness == Brightness.light ? 
                    Theme.of(context).accentIconTheme.color.withAlpha(32) :
                    Colors.black26
                )
              ]
            ),
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
