import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/colored_text_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/bubble_reaction_widget/bubble_reaction_widget.dart';
import 'package:vude_story_editor/src/widgets/bubble_reaction_widget/widgets/bubble_widget.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/input_field.dart';
import 'package:vude_story_editor/src/widgets/stickers/sticker_bottom_sheet/widgets/giphy_grid_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/sticker_bottom_sheet/widgets/sheet_thumb_widget.dart';
import 'package:vude_story_editor/src/widgets/text_editing_widget/text_editing_widget.dart';
import 'package:vude_story_editor/vude_story_editor.dart';
part 'stickers/sticker_bottom_sheet/sticker_bottom_sheet.dart';
part 'stickers/sticker_bottom_sheet/mention_sticker_sheet.dart';
part 'stickers/sticker_bottom_sheet/add_link_sticker_sheet.dart';
part 'stickers/sticker_bottom_sheet/audio_bottom_sheet.dart';

class StoryOptions extends StatelessWidget {
  const StoryOptions(
      {super.key, required this.profilePicture, required this.primaryColor});
  final String profilePicture;
  final Color primaryColor;
  static showStickerSheet(context) async {
    final controller = StoryEditingController.to;
    await _stickerBottomSheet(context);
    controller.searchMode(false);
    controller.searchTextController.clear();
    controller.showTrendingGifs(true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = StoryEditingController.to;
    return Obx(() => AnimatedSwitcher(
        duration: controller.animationDuration,
        child: controller.inAction.value
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _topOptions(context),
                    const Spacer(),
                    _bottomOptions(),
                  ],
                ),
              )));
  }

  Widget _topOptions(BuildContext context) {
    final controller = StoryEditingController.to;
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black38, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Transform.translate(
                      offset: const Offset(4, 0),
                      child: const Icon(Icons.arrow_back_ios)),
                )),
          ),
          const Spacer(),
          // SvgButton(
          //     icon:
          //         'packages/vude_story_editor/assets/svg/partnership_label_icon.svg',
          //     onPressed: () {}),
          // hSpace(10),
          SvgButton(
              icon: 'packages/vude_story_editor/assets/svg/text_icon.svg',
              onPressed: () {
                showTextEditingDialog(context);
              }),
          hSpace(10),
          SvgButton(
              icon: 'packages/vude_story_editor/assets/svg/sticker_icon.svg',
              onPressed: () async {
                await _stickerBottomSheet(context);
                controller.searchMode(false);
                controller.searchTextController.clear();
                controller.showTrendingGifs(true);
              }),
          if ((controller.stickerElements.first as MainMediaStickerItem)
              .isImage) ...[
            hSpace(10),
            SvgButton(
                icon: 'packages/vude_story_editor/assets/svg/audio_icon.svg',
                onPressed: () {
                  _audioBottomSheet(context);
                })
          ]
        ],
      ),
    );
  }

  Widget _bottomOptions() {
    return SizedBox(
      height: 60,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    StoryEditingController.to.editingComplete();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30)),
                    height: 50,
                    // width: 130,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                    // backgroundColor: Colors.red,
                                    backgroundImage: CachedNetworkImageProvider(
                                        profilePicture)),
                              ),
                            ),
                          ),
                          hSpace(8),
                          const TextWidget('Your story'),
                          hSpace(10)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                StoryEditingController.to.editingComplete();
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextWidget(
                      'Share',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
