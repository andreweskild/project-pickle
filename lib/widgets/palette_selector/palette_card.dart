import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/right_drawer_card.dart';


class PaletteCard extends StatelessWidget {
  const PaletteCard({
    Key key,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    var paletteList = <Color>[
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.grey
    ];
    return new RightDrawerCard(
      title: 'Palette',
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
          child: new AspectRatio(
            aspectRatio: 1.2,
            child: new GridView.count(
              primary: false,
              padding: const EdgeInsets.all(8.0),
              crossAxisSpacing: 8.0,
              crossAxisCount: 2,
              childAspectRatio: 3.2,
              children: paletteList.map(
                (color) => new RaisedButton(
                  elevation: 1.0,
                  color: color, 
                  shape: new RoundedRectangleBorder( borderRadius: new BorderRadius.all(new Radius.circular(12.0))),
                  onPressed: (){},
                )
              ).toList(),
              mainAxisSpacing: 8.0,
            )
          ),
        )
      ],
    );
  }
}