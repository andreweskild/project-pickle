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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).unselectedWidgetColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 6.0,
                  color: Theme.of(context).brightness == Brightness.light ? 
                    Theme.of(context).accentIconTheme.color.withAlpha(72) :
                    Colors.black26
                )
              ]
            ),
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
