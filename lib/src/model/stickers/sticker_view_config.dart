import 'package:vude_story_editor/vude_story_editor.dart';

class StickerViewConfig {
  StickerViewConfig(
      {this.onMentionTap,
      this.onUrlStickerTap,
      required this.viewController,
      this.onTapPost});
  final StoryViewController viewController;
  final Function(String url)? onUrlStickerTap;
  final Function(String userName)? onMentionTap;
  final Function(int postId)? onTapPost;
}
