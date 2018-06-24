import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/tools/tools_card.dart';
import 'package:project_pickle/widgets/preview_window/preview_card.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
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
                new Expanded(child: new ToolsCard()),
                new PreviewCard(),
              ],
            ),
          ),
      ),
    );
  }
}