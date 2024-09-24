import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/base_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/giphy_sticker_widget.dart';

class GiphyStickerItem extends BaseStickerItem {
  GiphyStickerItem(
      {required this.position,
      required this.rotation,
      required this.scale,
      required this.url,
      this.editMode = false});

  @override
  final Rx<Offset> position;

  @override
  final RxDouble rotation;

  @override
  final RxDouble scale;
  @override
  final bool editMode;

  @override
  RxBool isDeletePosition = false.obs;

  final String url;
  factory GiphyStickerItem.fromJson(JSON json) => GiphyStickerItem(
      position: Rx(Offset(double.parse(json['position-x'].toString()),
          double.parse(json['position-y'].toString()))),
      rotation: RxDouble(json['rotation'].toDouble()),
      scale: RxDouble(json['scale'].toDouble()),
      url: json['url']);

  @override
  JSON toJson() {
    return {
      'type': type,
      'position-x': position.value.dx,
      'position-y': position.value.dy,
      'rotation': rotation.value,
      'scale': scale.value,
      'url': url,
    };
  }

  @override
  BaseStickerWidget<BaseStickerItem> builder(
          StickerViewConfig config, BoxConstraints constrains) =>
      GiphyStickerWidget(this, config, constrains);

  @override
  String get type => 'giphy';
}
