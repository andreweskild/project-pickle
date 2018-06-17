import 'package:flutter/widgets.dart';

abstract class Tool {
  void handlePanDown(DragDownDetails details);
  void handlePanEnd(DragEndDetails details);
  void handlePanUpdate(DragUpdateDetails details);
  void handleTapUp(TapUpDetails details);
}