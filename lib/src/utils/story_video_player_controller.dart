import '../widgets/video_player_widget.dart';

class StoryVideoPlayerController {
  StoryVideoPlayerController._();
  static void play() {
    VideoPlayerWidget.currPlayerController?.play();
  }

  static void pause() {
    VideoPlayerWidget.currPlayerController?.pause();
  }
}
