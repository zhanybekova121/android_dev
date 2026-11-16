import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';

const demoPosts = <PostModel>[
  PostModel(
    id: 'post-1', authorId: 'me', authorName: 'alimhan',
    imageUrl: 'https://www.thedesignwork.com/wp-content/uploads/2011/10/Random-Pictures-of-Conceptual-and-Creative-Ideas-01.jpg',
    description: 'A little inspiration for today.', likeCount: 12,
  ),
  PostModel(
    id: 'post-2', authorId: 'me', authorName: 'alimhan',
    imageUrl: 'https://www.thedesignwork.com/wp-content/uploads/2011/10/Random-Pictures-of-Conceptual-and-Creative-Ideas-01.jpg',
    description: 'Finding beauty in the details.', likeCount: 8,
  ),
];

class FeedController extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() => demoPosts;

  void toggleLike(String id) {
    state = [
      for (final post in state)
        if (post.id == id)
          post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.likeCount + (post.isLiked ? -1 : 1),
          )
        else
          post,
    ];
  }
}

final feedControllerProvider =
    NotifierProvider<FeedController, List<PostModel>>(FeedController.new);
