import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/common/toggle_icon_button.dart';
import 'package:project_pickle/widgets/common/vertical_divider.dart';

/// Presents options and settings to customize the currently selected tool
///
///
class ToolOptionsPanel extends StatelessWidget {
  ToolOptionsPanel({
    Key key,
    this.toolType,
  }) : super(key: key);

  final ToolType toolType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: Material(
        elevation: 2.0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: Theme.of(context).dividerColor,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ToggleIconButton(
                  icon: Icon(Icons.dehaze),
                  toggled: false,
                  onPressed: (){},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ToggleIconButton(
                  icon: Icon(Icons.assessment),
                  toggled: true,
                  onPressed: (){},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: VerticalDivider(
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ToggleIconButton(
                  icon: Icon(Icons.line_style),
                  toggled: false,
                  onPressed: (){},
                ),
              ),
//            FlatButton(
//              color: true ? Theme.of(context).highlightColor : Colors.transparent,
//              textColor: true ? Theme.of(context).accentTextTheme.button.color : Colors.black,
//              child: Icon(Icons.dehaze),
//              padding: const EdgeInsets.all(8.0),
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(6.0),
//              ),
//              onPressed: (){},
//            ),
//            IconButton(
//              icon: Icon(Icons.dehaze),
//              padding: const EdgeInsets.all(0.0),
//              onPressed: (){},
//            ),
//            IconButton(
//              icon: Icon(Icons.dehaze),
//              padding: const EdgeInsets.all(0.0),
//              onPressed: (){},
//            ),
            ],
          ),
        )
      ),
    );
  }
}