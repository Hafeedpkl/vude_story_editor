import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'dart:ui' as ui show Image;
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/story_view_item_widget/story_view_widgets.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class StoryImage extends StatefulWidget {
  const StoryImage(this.config, this.stickerItem, {super.key});
  final StickerViewConfig config;
  final MainMediaStickerItem stickerItem;

  @override
  State<StoryImage> createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  StreamSubscription<PlaybackState>? playbackSubscription;
  ui.Image? image;
  Timer? _timer;

  @override
  void initState() {
    _initImage();
    super.initState();
  }

  _initImage() async {
    'loading image '.log('init');
    playbackSubscription =
        widget.config.viewController.playbackNotifier.listen((playbackState) {
      if (widget.stickerItem.medialoader!.frames == null) {
        return;
      }
      if (playbackState == PlaybackState.pause) {
        _timer?.cancel();
      } else {
        _imageForward();
      }
    });
    widget.config.viewController.setLoading();
    widget.config.viewController.pause(force: true);
    await widget.stickerItem.medialoader!.loadImage(() async {
      if (mounted) {
        switch (widget.stickerItem.medialoader!.state) {
          case LoadState.loading:
            widget.config.viewController.setLoading();
            break;
          case LoadState.success:
            await _imageForward();
            widget.config.viewController.setLoaded();
            widget.config.viewController.play(force: true);

            break;
          case LoadState.failure:
            widget.config.viewController.setFailure();
            break;
        }
      }
    });
  }

  _imageForward() async {
    _timer?.cancel();
    if (widget.config.viewController.playbackNotifier.value ==
        PlaybackState.pause) {
      return;
    }
    final nextFrame =
        await widget.stickerItem.medialoader!.frames!.getNextFrame();
    image = nextFrame.image;

    if (nextFrame.duration > Duration.zero) {
      _timer = Timer(nextFrame.duration, _imageForward);
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  dispose() {
    playbackSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.stickerItem.medialoader!.state) {
      LoadState.success => RawImage(image: image, fit: BoxFit.contain),
      LoadState.failure => const Center(
          child: TextWidget('Image failed to load'),
        ),
      _ => const Center(child: StoryViewLoadingwidget())
    };
  }
}
