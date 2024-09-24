import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/base_sticker_item.dart';
import 'package:vude_story_editor/src/model/stickers/sticker_view_config.dart';
import 'package:vude_story_editor/src/widgets/stickers/audio_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class AudioStickerItem extends BaseStickerItem {
  AudioStickerItem(
      {required this.position,
      required this.rotation,
      required this.scale,
      required this.audioName,
      required this.audioUrl,
      this.editMode = false});
  AudioStickerItem.new_({required this.audioName, required this.audioUrl})
      : rotation = RxDouble(0),
        position = Rx<Offset>(const Offset(.5, .5)),
        scale = RxDouble(1),
        editMode = false;
  @override
  BaseStickerWidget<BaseStickerItem> builder(
      StickerViewConfig config, BoxConstraints constrains) {
    return AudioStickerWidget(this, config, constrains);
  }

  @override
  final Rx<Offset> position;

  @override
  final RxDouble rotation;

  @override
  final RxDouble scale;

  String audioName;
  String audioUrl;

  @override
  final bool editMode;

  @override
  JSON toJson() {
    return {
      'type': type,
      'position-x': position.value.dx - .1,
      'position-y': position.value.dy - .5,
      'rotation': rotation.value,
      'scale': scale.value,
      'audioName': audioName,
      'audioUrl': audioUrl
    };
  }

  factory AudioStickerItem.fromJson(JSON json) => AudioStickerItem(
      position: Rx(
          Offset(json['position-x'].toDouble(), json['position-y'].toDouble())),
      rotation: RxDouble(json['rotation'].toDouble()),
      scale: RxDouble(json['scale'].toDouble()),
      audioName: json['audioName'],
      audioUrl: json['audioUrl']);

  @override
  String get type => 'audio';

  @override
  RxBool get isDeletePosition => false.obs;
}
