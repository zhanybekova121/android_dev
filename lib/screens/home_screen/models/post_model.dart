class PostModel {
  const PostModel({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
  });

  final String id;
  final String imageUrl;
  final String description;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final int likeCount;
  final int commentCount;

  /// Whether the currently logged-in user liked this post.
  final bool isLiked;
}
