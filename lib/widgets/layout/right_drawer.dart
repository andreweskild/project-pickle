import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/color_selector/color_selection_card.dart';
import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/palette_selector/palette_card.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SizedBox(
        width: 300.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Column(
              children: <Widget>[
                new ColorSelectionCard(),
                new PaletteCard(),
                new Expanded(child: new LayersCard()),
              ],
            ),
          ),
      ),
    );
  }
}