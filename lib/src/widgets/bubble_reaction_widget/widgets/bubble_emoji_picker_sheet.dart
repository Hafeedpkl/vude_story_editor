part of '../bubble_reaction_widget.dart';

_bubbleEmojiBottomSheet(BuildContext context) {
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
                      child: _BubbleEmojiContent(controller))))));
}

class _BubbleEmojiContent extends StatefulWidget {
  const _BubbleEmojiContent(this.scrollController);
  final ScrollController scrollController;
  @override
  State<_BubbleEmojiContent> createState() => __BubbleEmojiContentState();
}

class __BubbleEmojiContentState extends State<_BubbleEmojiContent> {
  final controller = StoryEditingController.to;
  @override
  void initState() {
    controller.getEmojis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SheetThumbWidget(),
        vSpace(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CupertinoSearchTextField(
            enableIMEPersonalizedLearning: true,
            autocorrect: true,
            style: const TextStyle(color: Colors.white),
            prefixInsets: const EdgeInsets.symmetric(horizontal: 12),
            onChanged: controller.searchEmojis,
          ),
        ),
        vSpace(15),
        Expanded(
          child: GridView.builder(
            controller: widget.scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6),
            itemCount: controller.emojiList.length,
            itemBuilder: (context, index) => Center(
                child: GestureDetector(
              onTap: () {
                Get.back();
                controller
                    .selectedBubbleEmoji(controller.emojiList[index].emoji);
              },
              child: TextWidget(
                controller.emojiList[index].emoji,
                fontSize: 30,
                // fontFamily: 'noto-emoji',
                // package: 'vude_story_editor',
              ),
            )),
          ),
        )
      ],
    );
  }
}
