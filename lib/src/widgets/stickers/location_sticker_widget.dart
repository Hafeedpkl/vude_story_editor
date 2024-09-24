import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/core/enums.dart';
import 'package:vude_story_editor/src/model/stickers/location_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class LocationStickerWidget extends BaseStickerWidget {
  const LocationStickerWidget(this.stickerItem, super.constrains, super.config,
      {super.key});

  @override
  final LocationStickerItem stickerItem;

  @override
  void onTap(context) {
    log('log ${stickerItem.bgDecoration.value}');
    if (stickerItem.editMode) {
      stickerItem.toggleDecoration();
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    // final String text= ''
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: stickerItem.bgDecoration.value == BgDecoration.d1
              ? Colors.black26
              : stickerItem.bgDecoration.value == BgDecoration.d2
                  ? Colors.black
                  : Colors.white,
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, -1),
            child: Icon(
              Icons.location_on,
              color: stickerItem.bgDecoration.value == BgDecoration.d3
                  ? Colors.black
                  : Colors.white,
              size: stickerItem.location.length > 30 ? 11 : 15,
            ),
          ),
          hSpace(3),
          Flexible(
            child: TextWidget(
              stickerItem.location.toUpperCase(),
              fontWeight: FontWeight.bold,
              color: stickerItem.bgDecoration.value == BgDecoration.d3
                  ? Colors.black
                  : Colors.white,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: stickerItem.location.length > 30 ? 11 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
