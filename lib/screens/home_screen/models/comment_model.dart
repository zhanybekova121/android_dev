class CommentModel {
  final String username;
  final String text;
  final String? avatarUrl;

  CommentModel({
    required this.username,
    required this.text,
    this.avatarUrl
  });
}