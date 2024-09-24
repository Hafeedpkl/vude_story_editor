import 'dart:ui';

class MediaEventHandler {
  MediaEventHandler({
    this.onMediaLoaded,
    this.onMediaLoading,
    this.onMediaError,
  });

  final VoidCallback? onMediaLoading;
  final VoidCallback? onMediaLoaded;
  final VoidCallback? onMediaError;
}
