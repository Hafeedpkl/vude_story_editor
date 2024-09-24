import 'package:flutter/material.dart';
import 'package:vude_story_editor/src/model/stickers/audio_sticker_item.dart';
import 'package:vude_story_editor/src/widgets/stickers/base_sticker_widget.dart';

class AudioStickerWidget extends BaseStickerWidget {
  const AudioStickerWidget(this.stickerItem, super.constrains, super.config,
      {super.key});

  @override
  final AudioStickerItem stickerItem;

  @override
  Widget buildWidget(BuildContext context) {
    return const _AudioStickerBuildWidget();
  }

  @override
  void onTap(context) {}
}

class _AudioStickerBuildWidget extends StatelessWidget {
  const _AudioStickerBuildWidget();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      // child: const Center(
      //   child: CircleAvatar(
      //     child: Icon(Icons.music_note_outlined),
      //   ),
      // )
    );
  }
}
