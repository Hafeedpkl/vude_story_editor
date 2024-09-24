import 'package:vude_story_editor/src/core/enums.dart';

class VerticalDragInfo {
  bool cancel = false;
  
  Direction? direction;

  void update(double primaryDelta) {
    Direction tempDirecion;
    if (primaryDelta > 0) {
      tempDirecion = Direction.down;
    } else {
      tempDirecion = Direction.up;
    }
    if (direction != null && tempDirecion != direction) {
      cancel = true;
    }
    direction = tempDirecion;
  }
}
