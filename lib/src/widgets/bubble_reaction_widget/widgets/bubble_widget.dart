import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/widgets/common_widgets.dart';

class BubbleWidget extends StatelessWidget {
  const BubbleWidget({super.key, this.emoji, this.bubbleSize = 100});
  final String? emoji;
  final double bubbleSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgIcon(
          'packages/vude_story_editor/assets/svg/bubble_reaction_sticker.svg',
          size: bubbleSize,
        ),
        Positioned.fill(
            child: Center(
          child: TextWidget(
            emoji ?? '😍',
            fontSize: bubbleSize / 2 - 5,
            // fontFamily: 'noto-emoji',
            // package: 'vude_story_editor',
          ),
        ))
      ],
    );
  }
}
