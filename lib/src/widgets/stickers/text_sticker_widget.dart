import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/core/enums.dart';
import 'package:vude_story_editor/src/model/stickers/text_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';
import 'package:vude_story_editor/src/widgets/text_editing_widget/text_editing_widget.dart';

class TextStickerWidget extends BaseStickerWidget {
  @override
  final TextStickerItem stickerItem;

  const TextStickerWidget(this.stickerItem, super.constrains, super.config,
      {super.key});

  @override
  onTap(context) {
    if (stickerItem.editMode) {
      StoryEditingController.to.editTextItem = stickerItem;
      showTextEditingDialog(context);
    }
  }

  @override
  Widget buildWidget(context) {
    return Visibility(
      visible: stickerItem.editMode
          ? StoryEditingController.to.editTextItem != stickerItem
          : true,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius:
                BorderRadius.circular(stickerItem.fontSize.value > 15 ? 6 : 2)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: stickerItem.bgDecoration.value == BgDecoration.d1
                      ? null
                      : stickerItem.bgColor.value,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13),
              child: Linkify(
                  text: stickerItem.text.value,
                  strutStyle: StrutStyle.disabled,
                  linkifiers: const [UserTagLinkifier()],
                  textAlign: stickerItem.textAlign.value,
                  style: TextStyle(
                      fontSize: stickerItem.fontSize.value,
                      fontWeight: FontWeight.w600,
                      color: stickerItem.fontColor.value,
                      fontFamily: stickerItem.fontName.value,
                      height: 1,
                      overflow: TextOverflow.clip,
                      package: 'vude_story_editor'),
                  linkStyle: TextStyle(
                    color: stickerItem.fontColor.value.withOpacity(0.9),
                    decoration: TextDecoration.none,
                  ),
                  onOpen: !stickerItem.editMode
                      ? (link) {
                          config.onMentionTap
                              ?.call(link.text.replaceAll('@', ''));
                        }
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
