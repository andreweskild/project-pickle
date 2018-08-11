import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/color_selector/color_card.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_selector_card.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ResponsiveDrawer(
      alignment: DrawerAlignment.start,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ToolsCard(),
          ColorCard(),
          Divider(height: 1.0),
          Expanded(
            child: PaletteSelectorCard()
          ),
        ],
      ),
    );
  }
}