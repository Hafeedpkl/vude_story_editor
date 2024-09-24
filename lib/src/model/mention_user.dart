class MentionUser {
  const MentionUser(
      {required this.name, required this.profilePicture, required this.userId});
  final int userId;
  final String name;
  final String profilePicture;
  @override
  toString() => '{name:$name,profilePicture:$profilePicture}';
}
