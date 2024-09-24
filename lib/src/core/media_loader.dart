import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vude_story_editor/src/core/enums.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class MediaLoader {
  String url;
  File? file;
  StoryMediaType mediaType;
  ui.Codec? frames;
  Map<String, dynamic>? requestHeaders;
  LoadState state = LoadState.loading;
  MediaLoader(this.url, this.mediaType, {this.requestHeaders});
  void loadVideo(VoidCallback onComplete) {
    if (file != null) {
      state = LoadState.success;
      onComplete();
    }
    final fileStream = DefaultCacheManager()
        .getFileStream(url, headers: requestHeaders as Map<String, String>?);

    fileStream.listen(
      (fileResponse) {
        if (fileResponse is FileInfo) {
          if (file == null) {
            state = LoadState.success;
            file = fileResponse.file;
            onComplete();
          }
        }
      },
    );
  }

  Future loadImage(VoidCallback onComplete) async {
    if (frames != null) {
      state = LoadState.success;
      onComplete();
    }
    final fileStream = DefaultCacheManager()
        .getFileStream(url, headers: requestHeaders as Map<String, String>?);

    fileStream.listen((fileResponse) {
      if (fileResponse is! FileInfo || frames != null) return;
      'loading imageBytes'.log();
      final Uint8List imageBytes = fileResponse.file.readAsBytesSync();

      state = LoadState.success;

      ui.instantiateImageCodec(imageBytes).then((codec) {
        frames = codec;
        onComplete();
      }, onError: (e) {
        state = LoadState.failure;
        onComplete();
      });
    }, onError: (error) {
      state = LoadState.failure;
      onComplete();
    });
  }
}
