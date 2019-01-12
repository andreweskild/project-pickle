import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/preview_window/preview_toolbox.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        return SizedBox(
          width: 196.0,
          child: Material(
            color: Theme.of(context).unselectedWidgetColor,
            elevation: 24.0,
            shadowColor: Colors.black,
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
