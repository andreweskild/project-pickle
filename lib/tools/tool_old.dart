import 'package:flutter/widgets.dart';

abstract class Tool {
  const Tool(
    @required this.context,
    this.overlay)
    : assert(context != null);

  final BuildContext context;
  final Widget overlay;
}