import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/color_selector/color_menu_button.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/common/outline_icon_button.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';


class ColorCard extends StatelessWidget {
  const ColorCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return DrawerCard(
        title: 'Color',
        builder: (context, collapsed) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    width: 190.0,
                    child: ColorMenuButton(
                      color: HSLColor(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: OutlineIconButton(
                    icon: Icons.colorize,
                    onPressed: (){},
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}