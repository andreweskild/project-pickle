import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/common/list_item.dart';
import 'package:project_pickle/widgets/layout/right_drawer_card.dart';


class LayersCard extends StatelessWidget {
  const LayersCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    const layers = <String>[
      'layer-1',
      'another-layer',
      'test-layer',
      'background-layer'
    ];

    return new RightDrawerCard(
      title: 'Layers',
      children: <Widget>[
        new Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
            child: new ConstrainedBox(
              constraints: new BoxConstraints.expand(),
              child: new ListView(
                shrinkWrap: true,
                children: layers.map(
                  (name) => new ListItem(
                    icon: new SizedBox(
                      height: 48.0,
                      child: new AspectRatio(
                        aspectRatio: 1.0,
                        child: new Material(
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ),
                    label: name,
                    onTap: (){},
                  )
                ).toList(),
              )
            ),
          ),
        )
      ],
    );
  }
}