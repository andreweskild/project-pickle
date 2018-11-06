import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/common/value_slider.dart';
import 'package:project_pickle/widgets/layout/responsive_app_bar.dart';
import 'package:project_pickle/widgets/tools/tool_options_panel.dart';

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
            appBar: new ResponsiveAppBar(
              elevation: 0.0,
              primary: true,
              centerTitle: true,
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                child: Center(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget> [
                        Icon(Icons.line_weight),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: ValueSlider(
                            value: 1.0,
                            min: 1.0,
                            max: 100.0,
                            onChanged: (value){
                              setState((){
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Icon(Icons.invert_colors),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: ValueSlider(
                            value: 0.4,
                            onChanged: (value){
                              setState((){
                              });
                            },
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Project',
                        style: Theme.of(context).accentTextTheme.title,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: (){},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0,),
                      child: Text(
                        '>',
                        style: Theme.of(context).accentTextTheme.title,
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Current Canvas',
                        style: Theme.of(context).accentTextTheme.title,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: (){},
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.launch, color: Theme.of(context).accentIconTheme.color),
                  onPressed: (){},
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Theme.of(context).accentIconTheme.color),
                  onPressed: (){},
                ),
              ],
            ),
            body: new Stack(
              children: <Widget>[
                widget.body,
                new Align(
                  alignment: Alignment.centerLeft,
                  child: widget.drawer,
                ),
                new Align(
                  alignment: Alignment.centerRight,
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
