import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/model/stickers/giphy_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class GiphyStickerWidget extends BaseStickerWidget {
  const GiphyStickerWidget(this.stickerItem, super.constrains, super.config,
      {super.key});
  @override
  final GiphyStickerItem stickerItem;
  @override
  Widget buildWidget(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: stickerItem.url,
      fit: BoxFit.contain,
    );
  }

  @override
  void onTap(context) {}
}
