import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/widgets/remove_widget.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

abstract class BaseStickerWidget<T extends BaseStickerItem>
    extends StatelessWidget {
  const BaseStickerWidget(this.config, this.constrains, {super.key});
  T get stickerItem;
  final StickerViewConfig config;
  final BoxConstraints constrains;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        height: constrains.maxHeight,
        width: constrains.maxWidth,
        top: _topPosition(),
        left: _leftPosition(),
        child: Transform.scale(
            scale: stickerItem.isDeletePosition.value
                ? 0.5
                : stickerItem.scale.value,
            child: Transform.rotate(
                angle: stickerItem.rotation.value,
                child: _childBuilder(context))),
      ),
    );
  }

  double _topPosition() {
    double deletePosition = RemoveWidget.top;
    if (stickerItem.isMedia) {
      return stickerItem.position.value.dy * constrains.maxHeight;
    } else {
      if (stickerItem.isDeletePosition.value) {
        return constrains.maxHeight * deletePosition -
            (constrains.maxHeight / 2);
      }
      return constrains.maxHeight * stickerItem.position.value.dy -
          (constrains.maxHeight / 2);
    }
  }

  double _leftPosition() {
    double deletePosition = RemoveWidget.left;
    if (stickerItem.isMedia) {
      return stickerItem.position.value.dx * constrains.maxWidth;
    } else {
      if (stickerItem.isDeletePosition.value) {
        return constrains.maxWidth * deletePosition - (constrains.maxWidth / 2);
      }
      return constrains.maxWidth * stickerItem.position.value.dx -
          (constrains.maxWidth / 2);
    }
  }

  Widget _childBuilder(BuildContext context) {
    if (stickerItem.editMode) {
      StoryEditingController controller = StoryEditingController.to;
      return GestureDetector(
        onTap: () => onTap(context),
        child: Listener(
            onPointerUp: (event) =>
                controller.onElementPointerUp(event, stickerItem),
            onPointerDown: (event) {
              controller.onElementPointerDown(event, stickerItem);
            },
            onPointerMove: (event) => controller.onElementPointerMove(
                event, stickerItem, context, constrains),
            child: Center(
                child: AnimatedContainer(
                    duration: Durations.medium2, child: buildWidget(context)))),
      );
    }
    return Listener(
        onPointerDown: (event) {
          onTap.call(context);
        },
        child: Center(child: buildWidget(context)));
  }

  void onTap(BuildContext context);
  Widget buildWidget(BuildContext contex);
}
