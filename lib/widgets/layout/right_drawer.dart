import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layers/layers_card.dart';
import 'package:project_pickle/widgets/preview_window/preview_card.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 6.0, bottom: 6.0),
              child: PreviewCard(),
            ),
            Expanded(
              child: Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 6.0, bottom: 6.0),
                child: LayersCard(),
              )
            ),
          ],
        ),
      ),
    );
  }
}