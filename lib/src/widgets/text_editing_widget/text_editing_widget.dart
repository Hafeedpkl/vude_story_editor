import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vude_story_editor/src/controller/story_editng_controller.dart';
import 'package:vude_story_editor/src/core/constants.dart';
import 'package:vude_story_editor/src/model/stickers/colored_text_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';
import 'package:vude_story_editor/vude_story_editor.dart';
part 'bottom_options.dart';
part 'text_editing_options.dart';
part 'text_editing_buttons.dart';

StoryEditingController get _controller => StoryEditingController.to;

showTextEditingDialog(context) {
  return showDialog(
      context: context, builder: (c) => const TextEditingWidget());
}

class TextEditingWidget extends StatefulWidget {
  const TextEditingWidget({super.key});
  @override
  State<TextEditingWidget> createState() => _TextEditingWidgetState();
}

class _TextEditingWidgetState extends State<TextEditingWidget> {
  final FocusNode focusNode = FocusNode();
  late TextStickerItem stickerItem;

  @override
  initState() {
    super.initState();
    log('init');
    initSticker();
    focusNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.inAction(true);
    });
  }

  initSticker() {
    stickerItem = _controller.editTextItem ??
        TextStickerItem(
            position: const Offset(.5, .5).obs,
            fontName: fontFamilyList[0].obs,
            rotation: 0.0.obs,
            scale: 1.0.obs,
            text: "".obs,
            editMode: true,
            textAlign: TextAlign.center.obs,
            bgValue: 1);
    initTextController();
  }

  initTextController() {
    _controller.textEditingController.value = TextEditingValue(
        text: _controller.editTextItem?.text.value ?? "",
        selection: TextSelection.collapsed(
            offset: _controller.editTextItem?.text.value.length ?? 0));
    _controller.textEditingController.addListener(() {
      _controller.onMentionSearch(_controller.textEditingController.text);
    });
  }

  disposeEditing() {
    _controller.inAction(false);
    _controller.textEditingController.removeListener(() {});
    focusNode.removeListener(() {});
    focusNode.unfocus();
    _controller.editTextItem = null;
    _controller.update();
  }

  onDone() {
    if (_controller.textEditingController.text.isEmpty) {
      if (_controller.stickerElements.contains(stickerItem)) {
        _controller.stickerElements.remove(stickerItem);
      }
    }
    stickerItem.text(_controller.textEditingController.text);

    if (_controller.editTextItem != null) {
      _controller.editTextItem!.text(_controller.textEditingController.text);
    } else {
      _controller.addTextSticker(stickerItem);
    }
    _controller.editTextItem = null;
    disposeEditing();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      onDone();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: context.height / 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          color: stickerItem.bgDecoration.value ==
                                      BgDecoration.d1 ||
                                  stickerItem.text.isEmpty
                              ? null
                              : stickerItem.bgColor.value,
                          borderRadius: BorderRadius.circular(
                              stickerItem.fontSize.value > 15 ? 6 : 2)),
                      child: Padding(
                          padding:
                              EdgeInsets.all(stickerItem.fontSize.value / 2),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: context.width * .8,
                                maxHeight: context.height * .4),
                            child: IntrinsicWidth(
                              stepWidth: 50,
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                focusNode: focusNode,
                                controller: _controller.textEditingController,
                                onChanged: (value) => stickerItem.text(value),
                                maxLines: 40,
                                minLines: 1,
                                textAlign: stickerItem.textAlign.value,
                                style: TextStyle(
                                    fontSize: stickerItem.fontSize.value,
                                    color: stickerItem.fontColor.value,
                                    // backgroundColor: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                    decorationThickness: 0,
                                    fontFamily: stickerItem.fontName.value,
                                    package: 'vude_story_editor'),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: InputBorder.none),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            _TextEditingOptions(stickerItem: stickerItem),
            _BottomOptions(stickerItem),
            _FontSizeSlider(focusNode: focusNode, stickerItem: stickerItem)
          ],
        ),
      ),
    );
  }
}
