// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'package:vude_story_editor/src/model/stickers/audio_sticker_item.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class Storycontent {
  Storycontent(
      {required this.mediaFileUrl,
      required this.storyThumbnail,
      required this.mediaSticker,
      this.audioSticker,
      required this.isLocal,
      required this.bgTopColor,
      required this.bgBottomColor,
      required this.stickers});
  String mediaFileUrl;
  String storyThumbnail;
  Color bgTopColor, bgBottomColor;
  final MainMediaStickerItem mediaSticker;
  final AudioStickerItem? audioSticker;
  List<BaseStickerItem> stickers;
  final bool isLocal;
  factory Storycontent.fromJson(JSON json, String file, String mediaType) {
    return Storycontent(
        mediaFileUrl: file,
        storyThumbnail: json['thumbnail'] ?? "",
        mediaSticker: MainMediaStickerItem.fromJson(
            json['media_sticker'], file, mediaType),
        bgTopColor: (json['bg_color_top'] as String).toHexColor,
        bgBottomColor: (json['bg_color_bottom'] as String).toHexColor,
        stickers: baseStickerFromJson(json['sticker_datas']),
        audioSticker: (json['audio_sticker']) != null &&
                json['audio_sticker']['audioName'] != null &&
                json['audio_sticker']['audioUrl'] != null
            ? AudioStickerItem.fromJson(json['audio_sticker'])
            : null,
            isLocal: false);
  }
  JSON toJson() => {
        'media_sticker': mediaSticker.toJson(),
        'bg_color_top': bgTopColor.hexValue,
        'bg_color_bottom': bgBottomColor.hexValue,
        'sticker_datas': stickers.map((e) => e.toJson()).toList(),
        'audio_sticker': audioSticker?.toJson()
      };
}

// class Story {
//   final String filePath;
//   final String thumbnailUrl;
//   final Storycontent storyData;
//   Story(
//       {required this.filePath,
//       required this.thumbnailUrl,
//       required this.storyData});

//   factory Story.fromJson(JSON json) => Story(
//       filePath: json['media_url'],
//       thumbnailUrl: json['thumbnail_url'],
//       storyData: json['story_data']);
// }
