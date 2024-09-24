part of 'text_editing_widget.dart';

class _BottomOptions extends GetWidget<StoryEditingController> {
  const _BottomOptions(this.stickerItem);
  final TextStickerItem stickerItem;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: context.mediaQueryViewInsets.bottom,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _bottomOptionSwitcher(),
            _bottomButtons(context),
          ],
        ));
  }

  Widget _bottomOptionSwitcher() {
    return Obx(
      () => switch (controller.bottomOption.value) {
        BottomOption.mention =>
          MentionUserWidget(stickerItem, ontap: controller.onMentionSelect),
        BottomOption.text => _TextFontSelectorWidget(stickerItem),
        BottomOption.color => _ColorSelectorWidget(stickerItem),
      },
    );
  }

  SizedBox _bottomButtons(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: 60,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            height: 10,
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      controller.textEditingController.value = TextEditingValue(
                          text: "${controller.textEditingController.text} @");
                      if (controller.textEditingController.text.isNotEmpty &&
                          controller.textEditingController.text
                              .split("@")
                              .last
                              .isEmpty) {
                        return;
                      }
                      log('mention');
                      controller.bottomOption(BottomOption.mention);
                    },
                    child: const Center(
                      child: TextWidget(
                        "@mention",
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      Get.back();
                      _controller.editTextItem = null;
                      _controller.getLocation();
                    },
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.place),
                          hSpace(5),
                          const TextWidget(
                            "Location",
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextFontSelectorWidget extends StatefulWidget {
  const _TextFontSelectorWidget(this.stickerItem);
  final TextStickerItem stickerItem;

  @override
  State<_TextFontSelectorWidget> createState() =>
      _TextFontSelectorWidgetState();
}

class _TextFontSelectorWidgetState extends State<_TextFontSelectorWidget> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: .110,
        initialPage: widget.stickerItem.fontSelected.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 60,
      alignment: Alignment.center,
      child: PageView.builder(
        controller: _pageController,
        pageSnapping: false,
        allowImplicitScrolling: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: FontFam.values.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) => Obx(
          () => GestureDetector(
            onTap: () {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            },
            child: Container(
              width: context.width * .1,
              height: context.width * .1,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.stickerItem.fontSelected.value == index
                    ? Colors.white
                    : Colors.black.withOpacity(0.4),
              ),
              // border: Border.all(
              //     color: widget.stickerItem.fontSelected.value == index
              //         ? _controller.themeColor.withOpacity(0.7)
              //         : Colors.transparent,
              //     width: 2),
              child: Text(
                'Aa',
                style: TextStyle(
                    fontFamily: FontFam.values[index].name,
                    color: widget.stickerItem.fontSelected.value == index
                        ? Colors.black
                        : Colors.white,
                    fontSize: 18,
                    package: 'vude_story_editor'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onPageChanged(int value) {
    widget.stickerItem.changeFont(value);
  }
}

class _ColorSelectorWidget extends StatelessWidget {
  const _ColorSelectorWidget(this.stickerItem);
  final TextStickerItem stickerItem;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: 60,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: textColors.length,
        itemBuilder: (context, index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            stickerItem.changeColor(textColors[index]);
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: textColors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white,
                          width: stickerItem.colorSelected.value ==
                                  textColors[index]
                              ? 2.5
                              : 1)),
                  height: context.height * .03,
                  width: context.height * .03,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MentionUserWidget extends StatefulWidget {
  const MentionUserWidget(this.stickerItem, {super.key, required this.ontap});
  final dynamic stickerItem;
  final Function(MentionUser user) ontap;
  @override
  State<MentionUserWidget> createState() => MentionUserWidgetState();
}

class MentionUserWidgetState extends State<MentionUserWidget> {
  late bool coloredSticker;
  @override
  initState() {
    super.initState();
    _controller.getMentionUsers("");
    coloredSticker = widget.stickerItem is ColoredTextStickerItem;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !_controller.mentionUsersLoading.value,
        replacement: coloredSticker
            ? const SizedBox()
            : _TextFontSelectorWidget(widget.stickerItem),
        child: SizedBox(
          width: context.width,
          height: 80,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: _controller.mentionUsers.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                widget.ontap.call(_controller.mentionUsers[index]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            placeholder: (c, s) => Image.asset(
                                'packages/vude_story_editor/assets/images/default_avatar.jpeg'),
                            imageUrl:
                                _controller.mentionUsers[index].profilePicture,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
                                'packages/vude_story_editor/assets/images/default_avatar.jpeg'),
                          ),
                        ),
                      ),
                      vSpace(5),
                      TextWidget(
                        _controller.mentionUsers[index].name,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
