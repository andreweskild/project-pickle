import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/square_icon_button.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';
import 'package:project_pickle/widgets/layout/responsive_app_bar.dart';

class UndoModel {
  UndoModel({
    this.canUndo,
    this.callback,
  });

  final bool canUndo;
  final VoidCallback callback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + canUndo.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! UndoModel) return false;
    UndoModel model = other;
    return (model.canUndo == canUndo);
  }
}

class RedoModel {
  RedoModel({
    this.canRedo,
    this.callback,
  });

  final bool canRedo;
  final VoidCallback callback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + canRedo.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! UndoModel) return false;
    UndoModel model = other;
    return (model.canUndo == canRedo);
  }
}


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
              elevation: 6.0,
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
              elevation: 6.0,
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
                        borderRadius: BorderRadius.circular(8.0),
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
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: (){},
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 6.0, 12.0),
                  child: StoreConnector<AppState, UndoModel>(
                    converter: (store) {
                      return UndoModel(
                        canUndo: store.state.canvasHistory.isNotEmpty,
                        callback: () => store.dispatch(UndoAction()),
                      );
                    },
                    builder: (context, model) {
                      return SquareIconButton (
                        icon: Icon(Icons.undo),
                        onPressed: model.canUndo ? model.callback : null,
                      );
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
                  child: StoreConnector<AppState, RedoModel>(
                      converter: (store) {
                        return RedoModel(
                          canRedo: store.state.canvasFuture.isNotEmpty,
                          callback: () => store.dispatch(RedoAction()),
                        );
                      },
                      builder: (context, model) {
                        return SquareIconButton (
                          icon: Icon(Icons.redo),
                          onPressed: model.canRedo ? model.callback : null,
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
                  child: SquareIconButton(
                    icon: Icon(Icons.launch, color: Theme.of(context).accentIconTheme.color),
                    onPressed: (){},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 12.0, 12.0, 12.0),
                  child: SquareIconButton(
                    icon: Icon(Icons.settings, color: Theme.of(context).accentIconTheme.color),
                    onPressed: (){},
                  ),
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                widget.body,
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 1.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                            color: Theme.of(context).brightness == Brightness.light ? 
                              Theme.of(context).accentIconTheme.color.withAlpha(72) :
                              Colors.black38
                          )
                        ]
                      ),
                    )
                  )
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: widget.drawer,
                ),
                Align(
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
