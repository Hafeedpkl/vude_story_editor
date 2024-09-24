import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vude_story_editor/src/utils/media_event_handler.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {super.key,
      required this.url,
      this.isLocalFile = false,
      this.useSafeArea = false,
      this.showViewOptions = false,
      this.mediaEventHandler,
      required this.isEditMode});
  final String url;
  final bool isLocalFile;
  final bool useSafeArea;
  final bool isEditMode;
  final bool showViewOptions;
  final MediaEventHandler? mediaEventHandler;
  static VideoPlayerController? currPlayerController;
  static RxBool isDragging = false.obs;
  static Rxn<Duration> position = Rxn();
  static Rxn<Duration> duration = Rxn();

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  final RxBool isLoaded = false.obs;
  final RxBool isPaused = false.obs;
  double currentVisibility = 0.0;

  @override
  void initState() {
    super.initState();

    _initPlayer();
  }

  _initPlayer() async {
    log('init plsyerr    ...');
    videoPlayerController = !widget.isLocalFile
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
        : VideoPlayerController.file(File(widget.url));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoPlayerWidget.currPlayerController = videoPlayerController;
    });

    widget.mediaEventHandler?.onMediaLoading?.call();

    try {
      await videoPlayerController.initialize();
    } catch (_) {}

    if (videoPlayerController.value.hasError) {
      widget.mediaEventHandler?.onMediaError?.call();
    } else {
      widget.mediaEventHandler?.onMediaLoaded?.call();
      videoPlayerController.play();
    }
    videoPlayerController.setLooping(widget.isEditMode);
    isLoaded(true);

    // if (currentVisibility > 0.5 && !videoPlayerController.value.isPlaying) {
    //   videoPlayerController.play();
    //   isPaused(!videoPlayerController.value.isPlaying);
    // }
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    if (widget.url != oldWidget.url) {
      _initPlayer();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    VideoPlayerWidget.currPlayerController = null;
    super.deactivate();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video${widget.url}'),
      onVisibilityChanged: (info) {
        currentVisibility = info.visibleFraction;
        if (info.visibleFraction == 1 &&
            isLoaded.value &&
            !videoPlayerController.value.isPlaying) {
          videoPlayerController.play();
          isPaused(!videoPlayerController.value.isPlaying);
        }
        if (info.visibleFraction == 0) {
          videoPlayerController.pause();
          isPaused(!videoPlayerController.value.isPlaying);
        }
      },
      child: Obx(() => isLoaded.value
              ? Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: getVideoView(),
                    ),
                    if (widget.showViewOptions)
                      Positioned(
                          right: 10,
                          top: 10,
                          child: ValueListenableBuilder(
                              valueListenable: videoPlayerController,
                              builder: (context, value, _) {
                                return TextWidget(
                                  _videoDuration(
                                      value.duration - value.position),
                                  fontWeight: FontWeight.bold,
                                );
                              }))
                  ],
                )
              : const SizedBox()
          // ShimmerBox.expand(opacity: 0.2)
          ),
    );
  }

  Widget getVideoView() {
    Widget player = SizedBox(
        height: videoPlayerController.value.size.height,
        width: videoPlayerController.value.size.width,
        child: VideoPlayer(videoPlayerController));

    // if (widget.isZoomingEnabled) {
    //   player = ZoomOverlay(
    //       twoTouchOnly: true,
    //       animationCurve: Curves.fastOutSlowIn,
    //       animationDuration: const Duration(milliseconds: 300),
    //       isZooming: PostFileViewer.isZooming,
    //       child: player);
    // }

    return player;
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n, {int pads = 2}) => n.toString().padLeft(pads, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60), pads: 1);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  pauseVideo() {
    videoPlayerController.pause();
    _togglePlay();
  }

  playVideo() {
    videoPlayerController.play();
    _togglePlay();
  }

  _togglePlay() {
    isPaused(!videoPlayerController.value.isPlaying);
  }
}

class _VideoPlayerProgressBar extends StatefulWidget {
  const _VideoPlayerProgressBar(this.videoPlayerController);
  final VideoPlayerController videoPlayerController;

  @override
  State<_VideoPlayerProgressBar> createState() =>
      _VideoPlayerProgressBarState();
}

class _VideoPlayerProgressBarState extends State<_VideoPlayerProgressBar> {
  final RxnDouble progress = RxnDouble();
  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.addListener(listener);
  }

  @override
  void deactivate() {
    widget.videoPlayerController.removeListener(listener);
    super.deactivate();
  }

  void listener() {
    if (!mounted) {
      return;
    }
    final controller = widget.videoPlayerController;
    VideoPlayerWidget.position.value = controller.value.position;
    VideoPlayerWidget.duration.value = controller.value.duration;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.videoPlayerController;
    return Visibility(
      visible: controller.value.isInitialized,
      replacement: SizedBox(
        height: 3.92,
        child: LinearProgressIndicator(
          color: Colors.white24,
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
      ),
      child: SliderTheme(
        data: SliderThemeData(
            trackShape: CustomSliderTrackShape(),
            activeTrackColor: Colors.white,
            trackHeight: 3.92,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
            inactiveTrackColor: Colors.black.withOpacity(0.3),
            overlayShape: SliderComponentShape.noOverlay),
        child: Slider(
          value: controller.value.position.inMilliseconds.toDouble(),
          max: controller.value.duration.inMilliseconds.toDouble(),
          onChanged: (value) {
            controller.seekTo(Duration(milliseconds: value.toInt()));
          },
          onChangeStart: (_) => VideoPlayerWidget.isDragging(true),
          onChangeEnd: (_) => VideoPlayerWidget.isDragging(false),
        ),
      ),
    );
  }
}

class CustomSliderTrackShape extends RectangularSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
