import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/horizontal_divider.dart';
import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
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
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: 196.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  PreviewToolbox(),
                  HorizontalDivider(height: 2.0),
                  Expanded(
                    child: LayersCard(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
