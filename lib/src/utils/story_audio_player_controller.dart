import 'dart:developer';

import 'package:vude_story_editor/src/vude_story_viewer_screen.dart';

class StoryAudioPlayerController {
  StoryAudioPlayerController._();
  static void play() {
    VudeStoryViewer.currAudioPlayer?.play();
    log('story audio play');
  }

  static void pause() {
    VudeStoryViewer.currAudioPlayer?.pause();
    log('story audio pause');
  }
}
