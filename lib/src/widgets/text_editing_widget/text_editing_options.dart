part of 'text_editing_widget.dart';

class _TextEditingOptions extends StatelessWidget {
  const _TextEditingOptions({required this.stickerItem});

  final TextStickerItem stickerItem;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: context.width,
        // color: Colors.
        child: Row(
          children: [
            Expanded(flex: 1, child: hSpace(10)),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TextAlignButton(stickerItem.textAlign),
                  hSpace(20),
                  const _ColorWheelButton(),
                  hSpace(20),
                  Obx(
                    () => SvgButton(
                        icon: stickerItem.decorationIconFilled.value
                            ? 'packages/vude_story_editor/assets/svg/graphic_text_active.svg'
                            : 'packages/vude_story_editor/assets/svg/graphic_text_inactive.svg',
                        iconSize: 20,
                        onPressed: () {
                          stickerItem.onClickDecoration();
                        }),
                  ),
                  // hSpace(20),
                  // SvgButton(
                  //     icon:
                  //         'packages/vude_story_editor/assets/svg/text_motion _inactive.svg',
                  //     iconSize: 20,
                  //     onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const TextWidget(
                      'Done',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FontSizeSlider extends StatelessWidget {
  const _FontSizeSlider({
    required this.focusNode,
    required this.stickerItem,
  });

  final FocusNode focusNode;
  final TextStickerItem stickerItem;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: context.height * .1,
      child: RotatedBox(
          quarterTurns: 3,
          child: SizedBox(
            width: context.height * .3,
            height: context.width * .08,
            child: Obx(
              () => SliderTheme(
                data: const SliderThemeData(
                    trackHeight: 1,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
                child: Slider(
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(0.4),
                  focusNode: focusNode,
                  min: 10,
                  max: 60,
                  value: stickerItem.fontSize.value,
                  onChanged: (v) {
                    stickerItem.fontSize(v);
                  },
                ),
              ),
            ),
          )),
    );
  }
}
