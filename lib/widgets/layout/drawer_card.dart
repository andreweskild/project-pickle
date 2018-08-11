import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/drawer_card_header.dart';

typedef DrawerCardChildBuilder = Widget Function(BuildContext context);

class DrawerCard extends StatefulWidget {
  const DrawerCard({
    Key key,
    this.alignment = DrawerAlignment.start,
    @required this.builder,
    this.collapsed = true,
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

  @override
  Widget build(BuildContext context) {
    return widget.builder(context,);
  }
}