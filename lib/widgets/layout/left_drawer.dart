import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            SizedBox(
              width: _kLeftDrawerWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ToolsCard(),
                  Expanded(child: ColorSection()),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              right: -32.0,
              bottom: 0.0,
              child: ConstrainedBox(
                  constraints: BoxConstraints.expand(width: 32.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.black.withAlpha(10), Colors.transparent],
                            tileMode: TileMode.clamp
                        )
                    ),
                  )
              ),
            ),
          ],
        );
      },
    );
  }
}
