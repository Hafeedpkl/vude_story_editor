class StoryPost {
  int id;
  String? caption;
  final int selectedIndex;
  String? profilePicture;
  String? username;
  final List<MediaDetails> videoDetails;
  MediaDetails get currentMedia => videoDetails[selectedIndex];
  StoryPost(
      {required this.id,
      required this.caption,
      required this.profilePicture,
      required this.username,
      this.selectedIndex = 0,
      required this.videoDetails});
  factory StoryPost.fromJson(Map<String, dynamic> json) => StoryPost(
      id: json['post_id'],
      caption: json['caption'],
      profilePicture: json['profile_picture'],
      username: json['username'],
      selectedIndex: json['selected_index'],
      videoDetails: List.from(
          json['video_details'].map((e) => MediaDetails.fromJson(e))));
  Map<String, dynamic> toJson() => {
        'post_id': id,
        'caption': caption,
        'profile_picture': profilePicture,
        'username': username,
        'selected_index': selectedIndex,
        'video_details': videoDetails.map((e) => e.toJson()).toList()
      };
}

class MediaDetails {
  final int id;
  final String postType;
  final String? videoTime;

  MediaDetails(
      {required this.id,
      required this.videoTime,
      required this.postType});
  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
      id: json['id'],
      videoTime: json['video_time'],
      postType: json['post_type']);
  Map<String, dynamic> toJson() => {
        'id': id,
        'video_time': videoTime,
        'post_type': postType
      };
}
