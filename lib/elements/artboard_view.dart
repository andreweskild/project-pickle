import 'package:flutter/material.dart';

class Artboard extends StatefulWidget {
  const Artboard({
    Key key,
    this.name,
    this.height,
    this.width,
    this.children,
  }) : super(key: key);

  final String name;
  final double height;
  final double width;

  final List<Widget> children;

  @override
  _ArtboardState createState() => new _ArtboardState();
}

class _ArtboardState extends State<Artboard> {

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.tightFor(
        height: widget.height,
        width: widget.width,
      ),
      child: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: new Stack (
              children: widget.children,
        ),
      ),
    );
  }
}