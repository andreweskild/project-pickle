
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/preview_window/preview_toolbox.dart';

double _kRightDrawerWidth = 256.0;

class RightDrawer extends StatelessWidget {
  const RightDrawer({
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
              width: _kRightDrawerWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  PreviewToolbox(),
                  Expanded(
                    child: LayersCard(),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              left: -32.0,
              bottom: 0.0,
              child: ConstrainedBox(
                  constraints: BoxConstraints.expand(width: 32.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
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
