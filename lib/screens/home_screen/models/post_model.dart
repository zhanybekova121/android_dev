import 'package:android_dev/screens/home_screen/models/comment_model.dart';

class PostModel {
  final String id;
  final String imageUrl;
  final int likeCount;
  final List<CommentModel> comments;
  final String description;
  final String authorId;
  final String authorName;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.authorId,
    required this.authorName,
    this.likeCount = 0,
    this.comments = const [],
    this.isLiked = false,
  });

  int get commentCount => comments.length;

  PostModel copyWith({int? likeCount, bool? isLiked, List<CommentModel>? comments}) => PostModel(
        id: id,
        imageUrl: imageUrl,
        description: description,
        authorId: authorId,
        authorName: authorName,
        likeCount: likeCount ?? this.likeCount,
        comments: comments ?? this.comments,
        isLiked: isLiked ?? this.isLiked,
      );
}
