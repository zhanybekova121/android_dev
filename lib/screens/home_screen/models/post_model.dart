import 'package:android_dev/screens/home_screen/models/comment_model.dart';

class PostModel {
  final String? imageUrl;
  int? likeCount;
  int? commentCount;
  final String? description;
  final List<CommentModel> comments;

  PostModel({
    this.imageUrl,
    this.likeCount,
    this.description,
    List<CommentModel>? comments, 
  })    :comments = comments ?? [],
         commentCount = comments?.length ?? 0;

  void addLike(int newCount) {
    likeCount = newCount;
  }

  void addComment(CommentModel comment) {
    comments.add(comment);
    commentCount = comments.length;
  }

}