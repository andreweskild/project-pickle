import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/common/outline_icon_button.dart';

class DrawerCardHeader extends StatelessWidget {
  DrawerCardHeader({
    Key key,
    this.alignment = DrawerAlignment.start,
    this.collapsed,
    @required this.onToggleCollapse,
    this.title,
  }) : super(key: key);

  final DrawerAlignment alignment;
  final bool collapsed;
  final VoidCallback onToggleCollapse;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Divider(
            height: 1.0,
            color: Colors.grey.shade400,
          ),
        ),
        Positioned(
          left: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: AnimatedOpacity(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 150),
                  opacity: collapsed ? 0.0 : 1.0,
                  child: Text(title ?? '')
              ),
            ),
          ),
        ),
        Align(
          alignment: (alignment == DrawerAlignment.start) ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlineIconButton(
              icon: (collapsed) ? Icons.arrow_forward : Icons.arrow_back,
              onPressed: onToggleCollapse,
            ),
          ),
        ),

      ],
    );
  }

}