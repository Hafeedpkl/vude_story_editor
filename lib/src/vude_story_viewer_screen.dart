import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/core/extensions.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/story_view_item_widget/story_view_widgets.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class VudeStoryViewer extends StatefulWidget {
  const VudeStoryViewer(
      {super.key,
      required this.content,
      required this.config,
      // this.mediaEventHandler,
      required this.storyLoading});

  final Storycontent content;
  final StickerViewConfig config;
  static AudioPlayer? currAudioPlayer;
  final RxBool storyLoading;
  // final MediaEventHandler? mediaEventHandler;

  @override
  State<VudeStoryViewer> createState() => _VudeStoryViewerState();
}

class _VudeStoryViewerState extends State<VudeStoryViewer>
    with WidgetsBindingObserver {
  StreamSubscription<PlaybackState>? _playbackSubscription;
  StreamSubscription<LoadState>? _loadingSubscription;
  // Audio
  AudioPlayer? audioPlayer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // widget.content.mediaSticker.setMediaHandle(widget.mediaEventHandler);
    _initPlayer();
    _loadingSubscription =
        widget.config.viewController.loadStateNotifier.listen((loadState) {
      if (loadState == LoadState.loading) {
        widget.config.viewController.pause(force: true);
      } else {
        widget.config.viewController.play(force: true);
      }
    });
  }

  _initPlayer() async {
    if (widget.content.audioSticker != null) {
      audioPlayer = AudioPlayer();
      widget.config.viewController.pause();
      widget.config.viewController.setLoading();
      await audioPlayer!.setUrl(widget.content.audioSticker!.audioUrl);
      'audioPlayer init'.log();
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   VudeStoryViewer.currAudioPlayer = audioPlayer;
      // });
      if (widget.config.viewController.playbackNotifier.value ==
          PlaybackState.pause) {
        widget.config.viewController.play();
      }
      if (widget.config.viewController.loadStateNotifier.value ==
          LoadState.loading) {
        widget.config.viewController.setLoaded();
      }
      audioPlayer!.setLoopMode(LoopMode.all);
      _playbackSubscription =
          widget.config.viewController.playbackNotifier.listen((playbackState) {
        if (playbackState == PlaybackState.pause) {
          audioPlayer!.pause();
        } else {
          audioPlayer!.play();
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      widget.config.viewController.pause();
      log('app paused');
    } else if (state == AppLifecycleState.resumed) {
      widget.config.viewController.play();
      log('app resumed');
    }
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    _playbackSubscription?.cancel();
    _loadingSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox(
              height: Get.height * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LayoutBuilder(builder: (context, constrains) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Container(
                          width: context.width,
                          height: context.height,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                widget.content.bgTopColor,
                                widget.content.bgBottomColor
                              ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                        ),
                        widget.content.mediaSticker
                            .builder(widget.config, constrains),
                        ...widget.content.stickers.map(
                            (item) => item.builder(widget.config, constrains)),
                      ],
                    ),
                  );
                }),
              ),
            ),
            StreamBuilder<LoadState>(
                stream: widget.config.viewController.loadStateNotifier,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == LoadState.success) {
                    return const SizedBox();
                  }
                  return Positioned.fill(
                    child: Container(
                      color: scaffoldBackgroundColor,
                      child: Center(
                        child: snapshot.hasData &&
                                snapshot.data == LoadState.failure
                            ? const TextWidget('Failed to load media')
                            : const StoryViewLoadingwidget(),
                      ),
                    ),
                  );
                }),
          ],
        ));
  }
}
