import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/preview_window/preview_toolbox.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveDrawer(
      alignment: DrawerAlignment.end,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          PreviewToolbox(),
          Expanded(
            child: LayersCard()
          ),
        ],
      ),
    );
  }
}