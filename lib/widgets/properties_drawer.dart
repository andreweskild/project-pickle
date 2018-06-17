import 'package:flutter/material.dart';

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