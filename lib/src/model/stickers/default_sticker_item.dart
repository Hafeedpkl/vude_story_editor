import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/base_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class DefaultStickerItem extends BaseStickerItem {
  @override
  BaseStickerWidget<BaseStickerItem> builder(
          StickerViewConfig config, BoxConstraints constrains) =>
      _DefaultStickerWidget(this, config, constrains);

  @override
  Rx<Offset> position;

  @override
  RxDouble rotation;

  @override
  RxDouble scale;
  DefaultStickerItem({
    required this.position,
    required this.rotation,
    required this.scale,
  });

  @override
  RxBool isDeletePosition = false.obs;

  @override
  JSON toJson() => {};

  @override
  String get type => 'default';
  factory DefaultStickerItem.fromJson(JSON json) => DefaultStickerItem(
        position: Rx(Offset(double.parse(json['position-x'].toString()),
            double.parse(json['position-y'].toString()))),
        rotation: RxDouble(double.parse(json['rotation'].toString())),
        scale: RxDouble(double.parse(json['scale'].toString())),
      );
}

class _DefaultStickerWidget extends BaseStickerWidget {
  const _DefaultStickerWidget(this.stickerItem, super.config, super.constrains);
  @override
  Widget buildWidget(BuildContext context) {
    return const SizedBox();
  }

  @override
  void onTap(c) {}

  @override
  final DefaultStickerItem stickerItem;
}
