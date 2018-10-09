import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/common/expandable_button.dart';

class ToolListButton extends ExpandableButton {
  ToolListButton({bool isExpanded, IconData icon, String label, List<Widget> options}) : super(
    isExpanded: isExpanded,
    body: Column(
      children: options
    ),
    headerBuilder: (context, expanded) {
      return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: expanded ? Theme.of(context).accentTextTheme.button.color : Theme.of(context).textTheme.button.color,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(color: expanded ? Theme.of(context).accentTextTheme.button.color : Theme.of(context).textTheme.button.color),
                  ),
                ),
              ],
            ),
          )
      );
    },
  );
}