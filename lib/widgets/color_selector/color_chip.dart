import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';

class ColorChip extends StatefulWidget {
  ColorChip({
    Key key,
    this.color,
    this.label,
    this.selected = false,
  }) : super(key: key);

  final Color color;
  final String label;
  final bool selected;


  @override
  _ColorChipState createState() => new _ColorChipState();
}

class _ColorChipState extends State<ColorChip> {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, String>(
      converter: (store) => store.state.currentToolType.toString(),
      builder: (context, toolType) {
        return new Padding(
          padding: new EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
          child: new Chip(
            avatar: (widget.selected) ? new Icon(Icons.check, color: Colors.white,) : null,
            backgroundColor: widget.color,
            label: new ConstrainedBox(
              constraints: new BoxConstraints.expand(height: 24.0),
                child: new Icon(
                  Icons.check,
                  color: (widget.color.computeLuminance() > 0.5) ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.7)
                )
            ),
            labelPadding: new EdgeInsets.all(0.0),
            labelStyle: new TextStyle(
              color: (widget.color.computeLuminance() > 0.5) ? Colors.black : Colors.white
            ),
            padding: new EdgeInsets.all(0.0),
            shape: new StadiumBorder(
              side: new BorderSide(
                color: Color.lerp(widget.color, Colors.black, 0.2),
              ),
            ),
          )
        );
      },
    );
  }
}