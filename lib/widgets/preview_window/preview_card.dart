import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/right_drawer_card.dart';


class PreviewCard extends StatelessWidget {
  const PreviewCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return new RightDrawerCard(
      title: 'Preview',
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
          child: new AspectRatio(
            aspectRatio: 1.2,
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: new BorderRadius.circular(12.0),
              ),
            )
          ),
        )
      ],
    );
  }
}