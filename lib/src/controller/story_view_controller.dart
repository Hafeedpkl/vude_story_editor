import 'package:rxdart/rxdart.dart';
import 'package:vude_story_editor/src/core/enums.dart';

class StoryViewController {
  final playbackNotifier = BehaviorSubject<PlaybackState>();
  final loadStateNotifier = BehaviorSubject<LoadState>();
  bool forcePause = false;
  bool isLoading = false;
  bool isTyping = false;
  void pause({bool force = false}) {
    if (force) forcePause = true;
    playbackNotifier.add(PlaybackState.pause);
  }

  void play({bool force = false}) {
    if (force) forcePause = false;
    if (isLoading || isTyping) return;
    if (forcePause && !force) return;
    playbackNotifier.add(PlaybackState.play);
  }

  void next() {
    playbackNotifier.add(PlaybackState.next);
  }

  void previous() {
    playbackNotifier.add(PlaybackState.previous);
  }

  void setLoading() {
    isLoading = true;
    loadStateNotifier.add(LoadState.loading);
  }

  void setLoaded() {
    isLoading = false;
    loadStateNotifier.add(LoadState.success);
  }

  void setFailure() => loadStateNotifier.add(LoadState.failure);

  void setTyping() {
    pause();
    isTyping = true;
  }

  void unsetTyping() {
    isTyping = false;
    play();
  }

  void dispose() {
    playbackNotifier.close();
    loadStateNotifier.close();
  }
}
