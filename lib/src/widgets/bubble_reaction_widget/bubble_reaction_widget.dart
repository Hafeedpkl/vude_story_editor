import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/model/stickers/bubble_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/bubble_reaction_widget/widgets/bubble_widget.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/stickers/sticker_bottom_sheet/widgets/sheet_thumb_widget.dart';
part 'widgets/bubble_emoji_picker_sheet.dart';

class BubbleReactionWidget extends GetWidget<StoryEditingController> {
  const BubbleReactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
                onTap: () {
                  controller.stickerElements.add(BubbleStickerItem(
                      position: Rx(const Offset(.5, .5)),
                      rotation: RxDouble(0),
                      scale: RxDouble(1),
                      editMode: true,
                      emoji:
                          StoryEditingController.to.selectedBubbleEmoji.value));
                  controller.update();
                  Get.back();
                },
                child: const TextWidget(
                  'Done',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          Positioned.fill(
            child: Center(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextWidget(
                      'Customize your reaction',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    vSpace(50),
                    Obx(
                      () => BubbleWidget(
                        emoji: controller.selectedBubbleEmoji.value,
                      ),
                    ),
                    vSpace(100)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: context.height * .03,
            right: 0,
            left: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...controller.recommentedBubbleEmojis.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                          onTap: () {
                            controller.selectedBubbleEmoji(e);
                          },
                          child: TextWidget(
                            e,
                            fontSize: 35,
                            // fontFamily: 'noto-emoji',
                            // package: 'vude_story_editor',
                          )))),
                  hSpace(8),
                  GestureDetector(
                    onTap: () {
                      _bubbleEmojiBottomSheet(context);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white12,
                      radius: 18,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
