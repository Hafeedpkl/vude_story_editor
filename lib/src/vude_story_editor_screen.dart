import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/src/widgets/remove_widget.dart';
import 'package:vude_story_editor/src/widgets/story_options.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/vude_story_editor.dart';

class VudeStoryEditor extends StatefulWidget {
  const VudeStoryEditor(
      {super.key,
      required this.file,
      required this.profilePicture,
      required this.primaryColor,
      this.draftStickers,
      required this.onTapLocation,
      required this.onMentionSearch,
      required this.onAudioSearch,
      required this.giphyApiKey,
      required this.onEditComplete,
      this.storyPost});
  final String file;
  final String profilePicture;
  final Color primaryColor;
  final RxList<BaseStickerItem>? draftStickers;
  final FutureOr<String> Function() onTapLocation;
  final String giphyApiKey;
  final StoryPost? storyPost;

  /// extends with [AudioTrack] class to perform Future API Operation
  final FutureOr<List<AudioTrack>> Function(String query) onAudioSearch;

  /// extends with [MentionUser] class to perform Future API Operation
  final FutureOr<List<MentionUser>> Function(String query) onMentionSearch;

  final Function(Storycontent content) onEditComplete;
  @override
  State<VudeStoryEditor> createState() => _VudeStoryEditorState();
}

class _VudeStoryEditorState extends State<VudeStoryEditor> {
  late StoryEditingController controller;
  // VerticalDragInfo? _verticalDragInfo;
  @override
  void initState() {
    super.initState();
    controller = Get.put(StoryEditingController());
    controller.initDatas(
        file: widget.file,
        drafts: widget.draftStickers,
        onMention: widget.onMentionSearch,
        onTapLocation: widget.onTapLocation,
        onAudioSearch: widget.onAudioSearch,
        giphyKey: widget.giphyApiKey,
        storyPost: widget.storyPost,
        onEditComplete: widget.onEditComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      primary: true,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: Get.height,
              child: Column(
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      key: controller.mainImageBoundaryKey,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return GestureDetector(
                                // onTapUp: (details) {
                                //   'onTapUp'.log();
                                // },
                                // onTapDown: (details) {
                                //   'onTapDown'.log();
                                // },
                                // onVerticalDragUpdate: (d) {
                                //   _verticalDragInfo ??= VerticalDragInfo();
                                //   _verticalDragInfo!.update(d.primaryDelta!);
                                // },
                                // onVerticalDragEnd: (d) {
                                //   if (_verticalDragInfo != null) {
                                //     if (_verticalDragInfo!.direction ==
                                //         Direction.up) {
                                //       StoryOptions.showStickerSheet(context);
                                //     }
                                //   }
                                // },
                                onScaleStart: controller.onScaleStart,
                                onScaleUpdate: (details) => controller
                                    .onScaleUpdate(details, constraints),
                                onTap: controller.onScreenTap,
                                child: GetBuilder<StoryEditingController>(
                                    builder: (controller) {
                                  return Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration: controller.animationDuration,
                                        width: context.width,
                                        height: context.height,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: controller.bgColors ??
                                                    [
                                                      Colors.grey.shade500,
                                                      Colors.blueGrey.shade700,
                                                    ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                      ),
                                      Positioned.fill(
                                        child: Stack(
                                          children: [
                                            ...controller.stickerElements.map(
                                                (item) => item.builder(
                                                    StickerViewConfig(
                                                        viewController:
                                                            StoryViewController()),
                                                    constraints)),
                                          ],
                                        ),
                                      ),
                                      RemoveWidget(constraints: constraints),
                                    ],
                                  );
                                }));
                          }),
                        ),
                      ),
                    ),
                  ),
                  vSpace(60)
                ],
              ),
            ),
            StoryOptions(
                profilePicture: widget.profilePicture,
                primaryColor: widget.primaryColor),
          ],
        ),
      ),
    );
  }
}
