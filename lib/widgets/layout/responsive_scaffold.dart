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
              primary: true,
              title: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Project',
                      style: Theme.of(context).textTheme.title,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: (){},
                  ),
                  Text(
                    '>',
                    style: Theme.of(context).textTheme.title,
                  ),
                  FlatButton(
                    child: Text(
                      'Current Canvas',
                      style: Theme.of(context).textTheme.title,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: (){},
                  )
                ],
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: (){},
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){},
                ),
              ],
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
