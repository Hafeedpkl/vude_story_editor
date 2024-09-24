import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/model/stickers/colored_text_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class ColoredTextStickerWidget extends BaseStickerWidget {
  const ColoredTextStickerWidget(this.stickerItem,super.constrains, super.config, {super.key});
  @override
  final ColoredTextStickerItem stickerItem;
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: stickerItem.backgroundColor,
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, -1),
            child: GradientShade(
                gradient: LinearGradient(
                    colors: stickerItem.coloredSticker.iconGradientColor,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter),
                child: stickerItem.coloredSticker.leadingIcon),
          ),
          Flexible(
            child: GradientShade(
              gradient: LinearGradient(
                  colors: stickerItem.coloredSticker.textGradientColor),
              child: TextWidget(
                stickerItem.secondaryText?.toUpperCase() ??
                    stickerItem.text.toUpperCase(),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: stickerItem.text.value.length > 30 ? 11 : 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onTap(context) {
    if (stickerItem.editMode) {
      stickerItem.toggleBgDecoration();
    } else {
      if (stickerItem.stickerType == 'link') {
        config.onUrlStickerTap?.call(stickerItem.text.value);
      } else if (stickerItem.stickerType == 'mention') {
        config.onMentionTap?.call(stickerItem.text.value);
      }
    }
  }
}
