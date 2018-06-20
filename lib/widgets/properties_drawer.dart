import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/color_selector/color_chip.dart';


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
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new ColorChip(
                    color: Colors.blue,
                    label: 'Foreground',
                  ),
                ),
                new Expanded(
                  child: new ColorChip(
                    color: Colors.yellow,
                    label: 'Background'
                  ),
                ),
              ],
            ),
          ),
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