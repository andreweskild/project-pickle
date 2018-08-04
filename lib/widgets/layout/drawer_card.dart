import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/drawer_card_header.dart';

typedef DrawerCardChildBuilder = Widget Function(BuildContext context, bool collapsed);

class DrawerCard extends StatefulWidget {
  const DrawerCard({
    Key key,
    this.alignment = DrawerAlignment.start,
    @required this.builder,
    this.collapsed = false,
    this.title,
  }) : super(key: key);

  final DrawerAlignment alignment;
  final String title;
  final DrawerCardChildBuilder builder;
  final bool collapsed;

  @override
  _DrawerCardState createState() => _DrawerCardState();
}

class _DrawerCardState extends State<DrawerCard> {

  bool _currentlyCollapsed;

  @override
  void initState() {
    _currentlyCollapsed = widget.collapsed;
    super.initState();
  }

  void _toggleCollapsed(){
    setState(() {
      _currentlyCollapsed = !_currentlyCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.centerLeft,
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
      width: _currentlyCollapsed ? 116.0 : 264.0,
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: <Widget>[
            DrawerCardHeader(
              alignment: widget.alignment,
              collapsed: _currentlyCollapsed,
              onToggleCollapse: _toggleCollapsed,
              title: widget.title,
            ),
            widget.builder(context, _currentlyCollapsed)
          ],
        ),
      ),
    );
  }
}