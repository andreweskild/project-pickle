import 'dart:ui';

abstract class PointerInput {
  void handlePointerInputPosUpdate(Offset pos);
  void handlePointerInputEnd();
}