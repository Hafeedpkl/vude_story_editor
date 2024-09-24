part of '../../story_options.dart';

_stickerBottomSheet(context) {
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
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15)),
          width: context.width,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      StoryEditingController.to.searchMode(false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      child: Icon(Icons.close),
                    ),
                  )),
              vSpace(10),
              const _StickerSearchBar(),
              vSpace(30),
              Expanded(
                child: Obx(
                  () => StoryEditingController.to.searchMode.isFalse
                      ? _StickerMainGridView(
                          key: const Key('main_grid'),
                          scrollController: controller)
                      : StickerSearchGrid(
                          key: const Key('search_grid'),
                          scrollController: controller),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class _StickerSearchBar extends StatefulWidget {
  const _StickerSearchBar();

  @override
  State<_StickerSearchBar> createState() => _StickerSearchBarState();
}

class _StickerSearchBarState extends State<_StickerSearchBar> {
  final controller = StoryEditingController.to;
  @override
  void initState() {
    super.initState();
    controller.searchFocusNode.addListener(() {
      if (controller.searchFocusNode.hasFocus) {
        StoryEditingController.to.searchMode(true);
      }
    });
  }

  @override
  dispose() {
    controller.searchFocusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Visibility(
            visible: StoryEditingController.to.searchMode.value,
            replacement: hSpace(30),
            child: IconButton(
                onPressed: () {
                  controller.searchFocusNode.unfocus();
                  controller.searchMode(false);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          Expanded(
            child: TextField(
              focusNode: controller.searchFocusNode,
              controller: controller.searchTextController,
              onChanged: (value) {
                controller.debouncer.run(() {
                  controller.onSearchGifs(value);
                });
              },
              decoration: InputDecoration(
                  fillColor: Colors.black45,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  filled: true,
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: borderDarkGreen)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: borderDarkGreen)),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: themeColor,
                  )),
            ),
          ),
          hSpace(30)
        ],
      ),
    );
  }
}

class _StickerMainGridView extends StatelessWidget {
  const _StickerMainGridView({required this.scrollController, super.key});
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListView(
        clipBehavior: Clip.antiAlias,
        controller: scrollController,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _IconTextStickerButton(
                ontap: () {
                  Get.back();
                  StoryEditingController.to.getLocation(coloredSticker: true);
                },
                text: ' Location',
                bgColor: const Color(0xFF0000B5),
                textColor: Colors.white,
                leadingWidget: const Icon(Icons.location_on),
              ),
              _IconTextStickerButton(
                text: '@Mention',
                textColor: const Color(0xFFFF3C00),
                ontap: () async {
                  Get.back();
                  StoryEditingController.to.inAction(true);
                  await _mentionBottomSheet(context);
                  StoryEditingController.to.inAction(false);
                },
              ),
              _IconTextStickerButton(
                leadingWidget: const SvgIcon(
                    'packages/vude_story_editor/assets/svg/link_sticker_icon.svg'),
                text: ' Link',
                bgColor: const Color(0xFF2196F3),
                textColor: Colors.white,
                ontap: () async {
                  Get.back();
                  StoryEditingController.to.inAction(true);
                  await _addLinkStickerSheet(context);
                  StoryEditingController.to.inAction(false);
                },
              ),
            ],
          ),
          vSpace(30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * .06),
            child: Row(
              mainAxisAlignment: (StoryEditingController
                          .to.stickerElements.first as MainMediaStickerItem)
                      .isImage
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceEvenly,
              children: [
                if ((StoryEditingController.to.stickerElements.first
                        as MainMediaStickerItem)
                    .isImage)
                  _IconTextStickerButton(
                    ontap: () {
                      Get.back();
                      _audioBottomSheet(context);
                    },
                    leadingWidget: const SvgIcon(
                        'packages/vude_story_editor/assets/svg/music_note_sticker_icon.svg'),
                    text: ' Music',
                    bgColor: const Color(0xFFC90081),
                    textColor: Colors.white,
                  ),
                GestureDetector(
                  onTap: () async {
                    Get.back();
                    // StoryEditingController.to.bubbleSelectionMode(true);
                    StoryEditingController.to.inAction(true);
                    showDialog(
                      context: context,
                      builder: (context) => const BubbleReactionWidget(),
                    );
                    StoryEditingController.to.inAction(false);
                  },
                  child: const BubbleWidget(bubbleSize: 60),
                ),
                Center(
                    child: _IconTextStickerButton(
                  ontap: () {
                    StoryEditingController.to.searchFocusNode.requestFocus();
                  },
                  leadingWidget: const Icon(Icons.search),
                  text: 'GIF ',
                  bgColor: Colors.grey,
                  textColor: Colors.white,
                )),
              ],
            ),
          ),
          vSpace(30),
          // const _IconTextStickerButton(
          //   leadingWidget: SvgIcon(
          //       'packages/vude_story_editor/assets/svg/basket_sticker_icon.svg'),
          //   text: ' Product',
          //   bgColor: Color(0xFFEB4D77),
          //   textColor: Colors.white,
          // )
        ],
      ),
    );
  }
}

class _IconTextStickerButton extends StatelessWidget {
  const _IconTextStickerButton(
      {required this.text,
      this.bgColor = Colors.white,
      this.textColor = Colors.black,
      this.leadingWidget,
      this.child,
      this.ontap});
  final String text;
  final Color bgColor;
  final Color textColor;
  final Widget? leadingWidget;
  final Widget? child;
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingWidget != null) leadingWidget!,
                child ??
                    TextWidget(
                      text,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
