part of 'text_editing_widget.dart';

class _TextAlignButton extends StatelessWidget {
  const _TextAlignButton(this.textAlign);
  final Rx<TextAlign> textAlign;
  @override
  Widget build(BuildContext context) {
    return Obx(() => SvgButton(
        icon: _alignedIcon(), iconSize: 20, onPressed: () => _align()));
  }

  _align() => switch (textAlign.value) {
        TextAlign.center => textAlign(TextAlign.right),
        TextAlign.left => textAlign(TextAlign.center),
        TextAlign.right => textAlign(TextAlign.left),
        _ => textAlign(TextAlign.center)
      };
  String _alignedIcon() => switch (textAlign.value) {
        TextAlign.center =>
          'packages/vude_story_editor/assets/svg/middle_align_text.svg',
        TextAlign.left =>
          'packages/vude_story_editor/assets/svg/left_align_text.svg',
        TextAlign.right =>
          'packages/vude_story_editor/assets/svg/right_align_text.svg',
        _ => ''
      };
}

class _ColorWheelButton extends StatelessWidget {
  const _ColorWheelButton();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SvgButton(
          icon:
              'packages/vude_story_editor/assets/svg/${_controller.bottomOption.value == BottomOption.color ? 'text_mode_icon' : 'color_wheel'}.svg',
          iconSize: 26,
          onPressed: () => switch (_controller.bottomOption.value) {
                BottomOption.color =>
                  _controller.bottomOption(BottomOption.text),
                _ => _controller.bottomOption(BottomOption.color)
              }),
    );
  }
}
