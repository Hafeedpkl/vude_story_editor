import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';

class RemoveWidget extends StatelessWidget {
  RemoveWidget({super.key, required this.constraints});
  final BoxConstraints constraints;
  final controller = StoryEditingController.to;
  static double top = .93;
  static double left = .5;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
          top: constraints.maxHeight * .93 - 40,
          left: constraints.maxWidth * .5 - 40,
          child: SizedBox(
            height: 80,
            width: 80,
            child: AnimatedCrossFade(
                duration: controller.animationDuration,
                crossFadeState: controller.showDeleteIcon.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                secondChild: const SizedBox(),
                firstChild: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TextWidget(
                        'Drag to Delete',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      vSpace(3),
                      AnimatedContainer(
                        height: controller.isDeletePosition.value ? 60 : 50,
                        duration: Durations.short4,
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            border: Border.all(
                                width: 2,
                                color: controller.isDeletePosition.value
                                    ? Colors.white
                                    : Colors.white),
                            shape: BoxShape.circle),
                        // radius: controller.isDeletePosition.value ? 30 : 25,
                        child: Center(
                          child: Icon(
                            Icons.delete_outlined,
                            color: Colors.white,
                            size: controller.isDeletePosition.value ? 30 : 25,
                            // size: controller.isDeletePosition.value ? 30 : 20,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
