import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/bubble_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/colored_text_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/default_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/giphy_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/location_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/model/stickers/text_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

abstract class BaseStickerItem {
  String get type;
  Rx<Offset> get position;
  RxDouble get scale;
  RxDouble get rotation;
  BaseStickerWidget builder(
      StickerViewConfig config, BoxConstraints constrains);
  bool get isMedia => false;
  bool get editMode => false;
  @override
  toString() =>
      '{type:$type, position:$position, scale:$scale, rotation:$rotation}';
  JSON toJson();
  RxBool get isDeletePosition;
}

List<BaseStickerItem> baseStickerFromJson(list) {
  return List.from(list.map((e) => _baseStickerSelector(e)).toList());
}

_baseStickerSelector(JSON json) => switch (json['type']) {
      'text-main' => TextStickerItem.fromJson(json),
      'text-colored' => ColoredTextStickerItem.fromJson(json),
      'location' => LocationStickerItem.fromJson(json),
      'giphy' => GiphyStickerItem.fromJson(json),
      'bubble-reaction' => BubbleStickerItem.fromJson(json),
      _ => DefaultStickerItem.fromJson(json)
    };
