part of '../../story_options.dart';

_mentionBottomSheet(BuildContext context) {
  return showDialog(
      context: context, builder: (context) => _MentionBottomSheetWidget());
}

class _MentionBottomSheetWidget extends StatelessWidget {
  _MentionBottomSheetWidget();
  final ColoredTextStickerItem stickerItem = ColoredTextStickerItem(
      position: const Offset(.5, .5).obs,
      rotation: 0.0.obs,
      scale: 1.0.obs,
      editMode: true,
      text: "".obs,
      stickerType: 'mention',
      decorationType: 1);
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black26,
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: onDone,
              child: const TextWidget(
                'Done',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        _MentionTextEditingWidget(
            stickerItem, textController, focusNode, onDone),
        Positioned(
            bottom: context.mediaQueryViewInsets.bottom + 10,
            child: MentionUserWidget(
              stickerItem,
              ontap: (user) {
                textController.value =
                    TextEditingValue(text: user.name.toUpperCase());
                stickerItem.text(user.name);
                StoryEditingController.to.stickerElements.add(stickerItem);
                StoryEditingController.to.update();
                Get.back();
              },
            ))
      ],
    );
  }

  onDone() {
    if (stickerItem.text.isNotEmpty) {
      StoryEditingController.to.stickerElements.add(stickerItem);
      StoryEditingController.to.update();
    }
    Get.back();
  }
}

class _MentionTextEditingWidget extends StatefulWidget {
  const _MentionTextEditingWidget(
      this.stickerItem, this.textController, this.focusNode, this.onDone);
  final ColoredTextStickerItem stickerItem;
  final TextEditingController textController;
  final FocusNode focusNode;
  final Function() onDone;
  @override
  State<_MentionTextEditingWidget> createState() =>
      _MentionTextEditingWidgetState();
}

class _MentionTextEditingWidgetState extends State<_MentionTextEditingWidget> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 2,
      width: context.width,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    '@',
                    color: widget.stickerItem.text.isEmpty
                        ? Colors.orange
                        : Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 10),
                      child: IntrinsicWidth(
                        child: TextField(
                          textCapitalization: TextCapitalization.characters,
                          focusNode: widget.focusNode,
                          controller: widget.textController,
                          onChanged: (value) {
                            widget.textController.value = TextEditingValue(
                                text: widget.textController.text.toUpperCase(),
                                selection: TextSelection.collapsed(
                                    offset: widget.textController.text.length));
                            widget.stickerItem.text(value);
                            StoryEditingController.to.debouncer.run(() {
                              StoryEditingController.to
                                  .getMentionUsers(value.toLowerCase());
                            });
                          },
                          maxLines: 1,
                          cursorColor: Colors.transparent,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.deepOrange,
                            backgroundColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            decorationThickness: 0,
                          ),
                          // keyboardType: TextInputType.text,
                          onEditingComplete: widget.onDone,
                          decoration: InputDecoration(
                              hintText: widget.stickerItem.text.isNotEmpty
                                  ? ""
                                  : 'MENTION',
                              focusColor: Colors.transparent,
                              fillColor: Colors.white,
                              isDense: true,
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                fontSize: 25,
                                color: Colors.orange,
                                backgroundColor: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                              ),
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: InputBorder.none),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
