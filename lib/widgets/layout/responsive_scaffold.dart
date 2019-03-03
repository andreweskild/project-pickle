import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/square_icon_button.dart';
import 'package:project_pickle/widgets/common/square_button.dart';
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
              leading: Row(
                children: <Widget>[
                  FlatButton(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Text(
                      'Projects',
                      style: Theme.of(context).accentTextTheme.title,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: (){},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Text(
                      '>',
                      style: Theme.of(context).accentTextTheme.title,
                    ),
                  ),
                  FlatButton(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Text(
                      'Current Project Name',
                      style: Theme.of(context).accentTextTheme.title,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: (){},
                  ),
                ],
              ),
              actions: <Widget>[
                StoreConnector<AppState, UndoModel>(
                  converter: (store) {
                    return UndoModel(
                      canUndo: store.state.canvasHistory.isNotEmpty,
                      callback: () => store.dispatch(UndoAction()),
                    );
                  },
                  builder: (context, model) {
                    return SquareIconButton (
                      icon: Icon(Icons.undo),
                      color: Theme.of(context).accentIconTheme.color,
                      onPressed: model.canUndo ? model.callback : null,
                    );
                  }
                ),
                SizedBox(
                  width: 12.0,
                ),
                StoreConnector<AppState, RedoModel>(
                    converter: (store) {
                      return RedoModel(
                        canRedo: store.state.canvasFuture.isNotEmpty,
                        callback: () => store.dispatch(RedoAction()),
                      );
                    },
                    builder: (context, model) {
                      return SquareIconButton (
                        icon: Icon(Icons.redo),
                        color: Theme.of(context).accentIconTheme.color,
                        onPressed: model.canRedo ? model.callback : null,
                      );
                    }
                ),
                SizedBox(
                  width: 12.0,
                ),
                SquareIconButton (
                  icon: Icon(Icons.more_vert),
                  color: Theme.of(context).accentIconTheme.color,
                  onPressed: (){},
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                widget.body,
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 32.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withAlpha(15), Colors.transparent],
                              tileMode: TileMode.clamp
                          )
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
