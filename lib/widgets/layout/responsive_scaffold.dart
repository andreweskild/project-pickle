import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatefulWidget {
  ResponsiveScaffold({
    Key key,
    this.name,
    this.body,
    this.drawer,
    this.endDrawer,
  }) : super(key: key);

  final String name;


  final Widget body;

  final Widget drawer;
  final Widget endDrawer;

  @override
  _ResponsiveScaffoldState createState() => new _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  static const int _widthBreakpoint = 992;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder (
      builder: (context, constraints) {
        // returns proper scaffold based on window width
        if(constraints.maxWidth < _widthBreakpoint) {
          // return Mobile Scaffold
          return new Scaffold(
            appBar: new AppBar(
              elevation: 0.5,
              title: new Text(widget.name),
              primary: true,
            ),
            body: widget.body,
            drawer: widget.drawer,
            endDrawer: widget.endDrawer,
          );
        }
        else {
          // return Desktop Scaffold
          return new Scaffold(
            appBar: new AppBar(
              elevation: 1.0,
              title: new Text(widget.name),
              primary: true,
            ),
            body: new Stack(
              children: <Widget>[
                widget.body,
                new Align(
                  alignment: Alignment(-1.0, 0.0),
                  child: widget.drawer,
                ),
                new Align(
                  alignment: Alignment(1.0, 0.0),
                  child: widget.endDrawer,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
