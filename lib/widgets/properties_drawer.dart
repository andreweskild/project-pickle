import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/color_selector/color_selection_rect.dart';
import 'package:project_pickle/widgets/color_selector/hue_slider.dart';


class ObjectPropertiesDrawer extends StatelessWidget {
  const ObjectPropertiesDrawer({
    Key key,
    this.child,
  }) : super(key: key);


  final Widget child;


  @override
  Widget build(BuildContext context) {
    return new Drawer(
      elevation: 2.0,
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new ColorSelectionRect(),
          new HueSlider(),
          new ListTile(
            title: new Text('Properties 1'),
            onTap: () {
            },
          ),
          new ListTile(
            title: new Text('Properties 2'),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}