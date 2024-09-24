import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/core/media_loader.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/stickers/main_media_sticker_widget.dart';
import 'package:vude_story_editor/vude_story_editor.dart';
import 'dart:ui' as ui show Image;

class MainMediaStickerItem extends BaseStickerItem {
  MainMediaStickerItem(
      {required this.position,
      required this.rotation,
      required this.scale,
      required this.file,
      this.editMode = false,
      this.storyPost,
      this.isFile = false,
      required this.mediaType})
      : medialoader = MediaLoader(file,
            mediaType == 'image' ? StoryMediaType.image : StoryMediaType.video);

  @override
  String get type => 'media';
  @override
  Rx<Offset> position;

  @override
  RxDouble rotation, scale;

  @override
  final bool isMedia = true;
  @override
  final bool editMode;
  final String file;
  final bool isFile;
  final String mediaType;
  final StoryPost? storyPost;
  bool get isImage => mediaType == 'image';
  bool get isPost => storyPost != null;
  MediaEventHandler? mediaEventHandler;
  MediaLoader? medialoader;
  Rx<ui.Image?>? imageFrame;
  @override
  RxBool isDeletePosition = false.obs;
  String get mediaUrl => file;
  @override
  BaseStickerWidget<BaseStickerItem> builder(
          StickerViewConfig config, BoxConstraints constrains) =>
      MainMediaStickerWidget(this, config, constrains, key: Key(file));

  factory MainMediaStickerItem.fromJson(
          JSON json, String media, String mediaType) =>
      MainMediaStickerItem(
          position: Rx(Offset(
              json['position-x'].toDouble(), json['position-y'].toDouble())),
          rotation: RxDouble(json['rotation'].toDouble()),
          scale: RxDouble(json['scale'].toDouble()),
          mediaType: mediaType,
          file: media,
          storyPost: json['post_details'] == null
              ? null
              : StoryPost.fromJson(json['post_details']));
  @override
  JSON toJson() => {
        'position-x': position.value.dx,
        'position-y': position.value.dy,
        'rotation': rotation.value,
        'scale': scale.value,
        'post_details': storyPost?.toJson()
      };

  setMediaHandle(MediaEventHandler? mediaEventHandler) {
    this.mediaEventHandler = mediaEventHandler;
  }
}
