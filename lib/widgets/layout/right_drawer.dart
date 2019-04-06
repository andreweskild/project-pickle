import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/preview_window/preview_toolbox.dart';

double _kRightDrawerWidth = 200.0;

class RightDrawer extends StatelessWidget {
  const RightDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        return Container(
          width: _kRightDrawerWidth,
          foregroundDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Theme.of(context).dividerColor,
              )
            )
          ),
          child: Card(
            borderSide: BorderSide.none,
            elevation: 0.0,
            borderRadius: BorderRadius.zero,
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
        );
      },
    );
  }
}
