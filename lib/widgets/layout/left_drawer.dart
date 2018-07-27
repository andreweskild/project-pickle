import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/color_selector/color_selection_card.dart';
import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_card.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Column(
          children: <Widget>[
            ToolsCard(),
//                new ColorSelectionCard(),
//                new Expanded(child: new PaletteCard()),
          ],
        ),
      ),
    );
  }
}