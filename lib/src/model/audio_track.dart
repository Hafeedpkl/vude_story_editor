class AudioTrack {
  final String id;
  final String title;
  final String? artistName;
  final String? mp3;
  final String? songThumbnail;
  AudioTrack(
      {required this.id,
      required this.title,
      this.artistName,
      this.mp3,
      this.songThumbnail});
  @override
  toString() =>
      '{id:$id,title:$title,artistName:$artistName,hasMp3:${mp3 != null},songThumbnail:${songThumbnail != null}}';
}
