import 'package:flutter/widgets.dart';

abstract class Tool {
  const Tool(
    @required this.context,
    @required this.overlay)
    : assert(context != null),
      assert(overlay != null);

  final BuildContext context;
  final Widget overlay;
}