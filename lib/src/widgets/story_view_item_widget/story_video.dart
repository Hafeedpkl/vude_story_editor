import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/story_view_item_widget/story_view_widgets.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class StoryVideo extends StatefulWidget {
  const StoryVideo(this.config, this.stickerItem,
      {super.key, this.showViewOptions = false});
  final StickerViewConfig config;
  final MainMediaStickerItem stickerItem;
  final bool showViewOptions;
  @override
  State<StoryVideo> createState() => _VideoPlayerSectionState();
}

class _VideoPlayerSectionState extends State<StoryVideo> {
  StreamSubscription<PlaybackState>? playbacksubscription;
  VideoPlayerController? videoPlayerController;
  @override
  initState() {
    super.initState();
    _initVideo();
  }

  _initVideo() {
    'loading video '.log('init');
    widget.config.viewController.pause();
    widget.config.viewController.setLoading();
    widget.stickerItem.medialoader!.loadVideo(() async {
      switch (widget.stickerItem.medialoader!.state) {
        case LoadState.success:
          videoPlayerController =
              VideoPlayerController.file(widget.stickerItem.medialoader!.file!);
          await videoPlayerController!.initialize().then((v) {
            setState(() {});
            widget.config.viewController.play();
          });
          playbacksubscription = widget.config.viewController.playbackNotifier
              .listen((playBackState) {
            if (playBackState == PlaybackState.pause) {
              videoPlayerController!.pause();
            } else {
              videoPlayerController!.play();
            }
          });
          widget.config.viewController.setLoaded();
          break;
        case LoadState.failure:
          widget.config.viewController.setFailure();
          break;
        default:
          widget.config.viewController.setLoading();
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  dispose() {
    videoPlayerController?.dispose();
    playbacksubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null ||
        !videoPlayerController!.value.isInitialized) {
      return const SizedBox();
    }
    return switch (widget.stickerItem.medialoader!.state) {
      LoadState.success => Center(
          child: AspectRatio(
            aspectRatio: videoPlayerController!.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(videoPlayerController!),
                if (widget.showViewOptions)
                  Positioned(
                      right: 10,
                      top: 10,
                      child: ValueListenableBuilder(
                          valueListenable: videoPlayerController!,
                          builder: (context, value, _) {
                            return TextWidget(
                              _videoDuration(value.duration - value.position),
                              fontWeight: FontWeight.bold,
                            );
                          }))
              ],
            ),
          ),
        ),
      LoadState.failure => const Center(
          child: TextWidget('Failed to Load Video'),
        ),
      _ => const Center(child: StoryViewLoadingwidget())
    };
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n, {int pads = 2}) => n.toString().padLeft(pads, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60), pads: 1);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
