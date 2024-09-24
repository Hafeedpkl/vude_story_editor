import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/base_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/bubble_sticker_widget.dart';

class BubbleStickerItem extends BaseStickerItem {
  BubbleStickerItem(
      {required this.position,
      required this.rotation,
      required this.scale,
      required this.emoji,
      this.editMode = false});
  @override
  Rx<Offset> position;

  @override
  RxDouble rotation;

  @override
  RxDouble scale;
  @override
  bool editMode;

  String emoji;

  factory BubbleStickerItem.fromJson(JSON json) => BubbleStickerItem(
      position: Rx(Offset(double.parse(json['position-x'].toString()),
          double.parse(json['position-y'].toString()))),
      rotation: RxDouble((json['rotation'].toDouble())),
      scale: RxDouble(json['scale'].toDouble()),
      emoji: json['emoji']);

  @override
  JSON toJson() {
    return {
      'type': type,
      'position-x': position.value.dx,
      'position-y': position.value.dy,
      'rotation': rotation.value,
      'scale': scale.value,
      'emoji': emoji
    };
  }

  @override
  String get type => 'bubble-reaction';
  @override
  BaseStickerWidget<BaseStickerItem> builder(
      StickerViewConfig config, BoxConstraints constrains) {
    return BubbleStickerWidget(this, config, constrains);
  }

  @override
  final RxBool isDeletePosition = false.obs;
}
