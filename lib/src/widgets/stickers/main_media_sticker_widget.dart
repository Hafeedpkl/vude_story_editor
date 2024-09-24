import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';
import 'package:vude_story_editor/src/widgets/story_view_item_widget/story_image.dart';
import 'package:vude_story_editor/src/widgets/story_view_item_widget/story_video.dart';
import 'package:vude_story_editor/src/widgets/text_editing_widget/text_editing_widget.dart';
import 'package:vude_story_editor/src/widgets/video_player_widget.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class MainMediaStickerWidget extends BaseStickerWidget {
  const MainMediaStickerWidget(this.stickerItem, super.config, super.constrains,
      {super.key});

  @override
  final MainMediaStickerItem stickerItem;

  @override
  Widget buildWidget(BuildContext context) {
    return SizedBox(
        width: context.width,
        height: context.height,
        child: stickerItem.isPost
            ? _PostMediaWidget(stickerItem: stickerItem, config: config)
            : _MediaContent(stickerItem: stickerItem, config: config)
        //  Visibility(
        //     visible: stickerItem.mediaType == 'video',
        //     replacement: stickerItem.isFile
        //         ? Image.file(
        //             File(stickerItem.file),
        //             fit: BoxFit.contain,
        //           )
        //         : RawImage(image: config.currentImageFrame!.value),
        // StoryImage(stickerItem, config.viewController),
        //  ImageViewer(
        //     stickerItem: stickerItem,
        //     context: context,
        //   ),
        // child: VideoPlayer(config.playerController!)
        // StoryVideo(stickerItem, config.viewController)
        // VideoPlayerWidget(
        //   isViewMode: true,
        //   isEditMode: stickerItem.editMode,
        //   url: stickerItem.file,
        //   isLocalFile: stickerItem.editMode,
        //   mediaEventHandler: stickerItem.mediaEventHandler,
        // ),
        // )
        );
  }

  @override
  void onTap(context) {
    if (stickerItem.editMode) {
      showTextEditingDialog(context);
    } else {
      // if (stickerItem.isPost) config.onTapPost?.call(stickerItem.storyPost!.id);
    }
  }
}

class _PostMediaWidget extends StatelessWidget {
  const _PostMediaWidget({
    required this.stickerItem,
    required this.config,
  });

  final MainMediaStickerItem stickerItem;
  final StickerViewConfig config;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _MediaContent(
                  stickerItem: stickerItem,
                  config: config,
                  showVideoOptions: true,
                ),
                if (stickerItem.storyPost!.videoDetails.length > 1)
                  const Positioned(
                    left: 10,
                    top: 10,
                    child: SvgIcon(
                      'packages/vude_story_editor/assets/svg/post_muliple.svg',
                      size: 20,
                    ),
                  )
              ],
            ),
            vSpace(5),
            TextWidget(
              '@${stickerItem.storyPost!.username}',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )
          ],
        ),
      ),
    );
  }
}

class _MediaContent extends StatelessWidget {
  const _MediaContent(
      {required this.stickerItem,
      required this.config,
      this.showVideoOptions = false});

  final MainMediaStickerItem stickerItem;
  final StickerViewConfig config;
  final bool showVideoOptions;
  @override
  Widget build(BuildContext context) {
    if (stickerItem.editMode) {
      if (stickerItem.isImage) {
        if (stickerItem.isFile) {
          return Image.file(File(stickerItem.mediaUrl));
        } else {
          return CachedNetworkImage(imageUrl: stickerItem.mediaUrl);
        }
      } else {
        return Center(
          child: VideoPlayerWidget(
            url: stickerItem.mediaUrl,
            isEditMode: stickerItem.editMode,
            isLocalFile: stickerItem.isFile,
            showViewOptions: showVideoOptions,
          ),
        );
      }
    } else {
      return stickerItem.isImage
          ? StoryImage(config, stickerItem, key: Key(stickerItem.toString()))
          : StoryVideo(config, stickerItem,
              key: Key(stickerItem.toString()),
              showViewOptions: showVideoOptions);
    }
  }
}
