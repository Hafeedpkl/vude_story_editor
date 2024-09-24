part of '../../story_options.dart';

_audioBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      elevation: 0,
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.8,
          builder: (context, controller) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15)),
                    width: context.width,
                    child: _AudioSheetContent(controller),
                  )))));
}

class _AudioSheetContent extends StatefulWidget {
  const _AudioSheetContent(this.scrollController);
  final ScrollController scrollController;
  @override
  State<_AudioSheetContent> createState() => __AudioSheetContentState();
}

class __AudioSheetContentState extends State<_AudioSheetContent> {
  final controller = StoryEditingController.to;
  @override
  initState() {
    super.initState();
    controller.onAudioSearch("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SheetThumbWidget(),
        vSpace(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CupertinoSearchTextField(
              placeholder: 'Search music',
              borderRadius: BorderRadius.circular(15),
              onChanged: (value) {
                StoryEditingController.to.debouncer.run(() {
                  StoryEditingController.to.onAudioSearch(value);
                });
              },
              style: const TextStyle(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              prefixInsets: const EdgeInsets.all(10)),
        ),
        _selectedSongWidget(),
        vSpace(10),
        Expanded(
            child: Obx(
          () => Visibility(
            visible: StoryEditingController.to.audioLoading.isFalse,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Visibility(
              visible: StoryEditingController.to.audioTracks.isNotEmpty,
              replacement: const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: TextWidget(
                    'No audio found!',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(
                    bottom: context.mediaQueryViewInsets.bottom),
                controller: widget.scrollController,
                itemCount: controller.audioTracks.length,
                itemBuilder: (context, index) =>
                    _songTile(controller.audioTracks[index]),
              ),
            ),
          ),
        ))
      ],
    );
  }

  Widget _selectedSongWidget() {
    return Obx(
      () => Visibility(
        visible: controller.mainAudioTrack.value != null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            vSpace(10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.mainAudioPlayer.playing) {
                        controller.mainAudioPlayer.pause();
                      } else {
                        if (controller.currentAudioPlayer.playing) {
                          controller.currentAudioPlayer.stop();
                        }
                        controller.mainAudioPlayer.play();
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: StreamBuilder<bool>(
                            stream: controller.mainAudioPlayer.playingStream,
                            builder: (context, snapshot) {
                              return Icon(
                                snapshot.data ?? false
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 20,
                              );
                            })),
                  ),
                  Flexible(
                      child: TextScroll(
                    controller.mainAudioTrack.value?.title ?? "audio",
                    style: const TextStyle(fontSize: 12),
                    velocity: const Velocity(
                      pixelsPerSecond: Offset(40, 0),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () {
                        controller.mainAudioTrack.value = null;
                        controller.mainAudioPlayer.stop();
                        controller.stickerElements
                            .remove(controller.getAudioSticker);
                        controller.update();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _songTile(AudioTrack track) {
    return ListTile(
      onTap: () => controller.setMainAudio(track),
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        width: 40,
        child: track.songThumbnail != null
            ? CachedNetworkImage(imageUrl: track.songThumbnail ?? "")
            : const Center(
                child: SvgIcon(
                    'packages/vude_story_editor/assets/svg/audio_enabled.svg')),
      ),
      title: TextWidget(track.title, fontWeight: FontWeight.w600),
      subtitle: track.artistName != null
          ? TextWidget(track.artistName!, fontSize: 11)
          : null,
      trailing: GestureDetector(
        onTap: () => controller.toggleCurrentAudio(track),
        child: StreamBuilder<bool>(
            stream: controller.currentAudioPlayer.playingStream,
            builder: (context, snapshot) {
              return GetBuilder<StoryEditingController>(builder: (controller) {
                return Icon(
                  (snapshot.data ?? false) &&
                          (controller.currentAudioTrack.value != null &&
                              controller.currentAudioTrack.value == track)
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline,
                  size: 30,
                );
              });
            }),
      ),
    );
  }
}
