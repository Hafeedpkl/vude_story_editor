import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/model/stickers/bubble_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/bubble_reaction_widget/widgets/bubble_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class BubbleStickerWidget extends BaseStickerWidget {
  const BubbleStickerWidget(this.stickerItem, super.constrains, super.config,
      {super.key});
  @override
  final BubbleStickerItem stickerItem;

  @override
  Widget buildWidget(BuildContext context) {
    return BubbleWidget(
      emoji: stickerItem.emoji,
    );
  }

  @override
  void onTap(c) => false;
}
