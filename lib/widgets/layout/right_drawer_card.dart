import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class RightDrawerCard extends StatelessWidget {
  const RightDrawerCard({
    Key key,
    this.title,
    this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: new Card(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(16.0)),
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new ListTile(
                title: Text(title, textAlign: TextAlign.end,),
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              )
            ]..addAll(children),
          ),
        ),
      ),
    );
  }
}