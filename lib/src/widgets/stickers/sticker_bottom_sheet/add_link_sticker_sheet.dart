part of '../../story_options.dart';

_addLinkStickerSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.black87,
    barrierColor: Colors.transparent,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    context: context,
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: context.height / 1.5,
          maxHeight: context.height / 1.2,
          maxWidth: context.width),
      child: const _AddLinkContentWidget(),
    ),
  );
}

class _AddLinkContentWidget extends StatefulWidget {
  const _AddLinkContentWidget();

  @override
  State<_AddLinkContentWidget> createState() => _AddLinkContentWidgetState();
}

class _AddLinkContentWidgetState extends State<_AddLinkContentWidget> {
  RxBool enableText = false.obs;
  final TextEditingController textUrlController = TextEditingController();
  final TextEditingController textNameController = TextEditingController();
  @override
  initState() {
    super.initState();
    textUrlController.addListener(() {
      if (!textUrlController.text.isURL) {
        enableText(false);
      }
    });
  }

  onDone() {
    if (!textUrlController.text.isURL) return;
    Get.back();
    StoryEditingController.to.stickerElements.add(
      ColoredTextStickerItem(
          position: const Offset(.5, .5).obs,
          rotation: 0.0.obs,
          scale: 1.0.obs,
          editMode: true,
          secondaryText: enableText.value && textNameController.text.isNotEmpty
              ? textNameController.text
              : null,
          text: textUrlController.text.obs,
          stickerType: 'link',
          decorationType: 1),
    );
    StoryEditingController.to.update();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpace(10),
            _headingWidget(onDone, context),
            vSpace(10),
            InputField(
              controller: textUrlController,
              borderType: InputFieldBorderType.external,
              inputType: TextInputType.url,
              alignLabelWithHint: true,
              capitalizeFirst: false,
              hintText: 'https://example.com',
              label: 'URL',
              labelStyle: const TextStyle(fontSize: 12, color: themeColor),
              sValidator: (value) {
                if (!value.isURL) {
                  return (ValidateStatus.error, 'Invalid Url');
                }
                return null;
              },
              // isDense: false,
            ),
            vSpace(30),
            Obx(
              () => Visibility(
                visible: enableText.value,
                replacement: GestureDetector(
                  onTap: () {
                    enableText(textUrlController.text.isURL);
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add,
                        size: 15,
                      ),
                      TextWidget(
                        ' Customize sticker text',
                      )
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      controller: textNameController,
                      borderType: InputFieldBorderType.external,
                      alignLabelWithHint: true,
                      label: 'Sticker text',
                      maxLength: 100,
                      labelStyle:
                          const TextStyle(fontSize: 12, color: themeColor),
                    ),
                    vSpace(10),
                    const TextWidget(
                      'This text will show on the sticker instead of the URL',
                      fontSize: 11,
                    ),
                    vSpace(MediaQuery.of(context).viewInsets.bottom)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

Row _headingWidget(Function() onDone, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Get.back();
          _stickerBottomSheet(context);
        },
      ),
      const TextWidget(
        'Add link',
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      TextButton(onPressed: onDone, child: const TextWidget('Done'))
    ],
  );
}
