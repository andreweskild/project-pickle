import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'backdrop_menu_item.dart';

class ProjectCard extends StatelessWidget {
  ProjectCard({
    Key key,
    this.name,
    this.height,
    this.width,
  }) : super(key: key);

  final String name;

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.tightFor(width: 256.0),
      child: new AspectRatio(
        aspectRatio: width/height,
        child: new Backdrop(
          title: name,
          frontLayer: new ConstrainedBox(
            constraints: new BoxConstraints.expand(),
            child: new InkWell(
              child: new Text('TEST'),
              onTap: (){ print('TEST'); },
            ),
          ),
          menuItems: <Widget>[
            BackdropMenuItem(
              icon: new Icon(Icons.delete),
              label: new Text('Delete'),
              onTap: (){},
            ),
            BackdropMenuItem(
              icon: new Icon(Icons.content_copy),
              label: new Text('Duplicate'),
              onTap: (){},
            ),
          ],
        )
      ),
    );
  }
}

