import 'package:flutter/material.dart';

class ArtboardThumb extends StatelessWidget {
  ArtboardThumb({
    Key key,
    this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: 400.0,
      width: 200.0,
      child: new Container(
        color: Colors.red,
      )
    );
  }
}