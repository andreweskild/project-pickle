import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/color_selector/color_section.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';

double _kLeftDrawerWidth = 80.0;

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        return Container(
          width: _kLeftDrawerWidth,
          foregroundDecoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              )
            )
          ),
          child: Card(
            borderSide: BorderSide.none,
            elevation: 0.0,
            borderRadius: BorderRadius.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(width: _kLeftDrawerWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ToolsCard(),
                  Expanded(child: ColorSection()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
