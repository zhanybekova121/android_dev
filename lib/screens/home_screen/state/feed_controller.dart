import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:android_dev/screens/home_screen/state/services_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedController extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() => ref.watch(postServicesProvider).fetchPosts();

  void toggleLike(String id) => _update(
        id,
        (post) => post.copyWith(
          isLiked: !post.isLiked,
          likeCount: post.likeCount + (post.isLiked ? -1 : 1),
        ),
      );

  void addComment(String postId, CommentModel comment) =>
      _update(postId, (post) => post.copyWith(comments: [...post.comments, comment]));

  void _update(String id, PostModel Function(PostModel) change) {
    state = [for (final post in state) post.id == id ? change(post) : post];
  }
}

final feedControllerProvider =
    NotifierProvider<FeedController, List<PostModel>>(FeedController.new);

final storiesProvider = Provider<List<StoryModel>>(
  (ref) => ref.watch(postServicesProvider).fetchStories(),
);

final postProvider = Provider.family<PostModel, String>(
  (ref, id) => ref.watch(feedControllerProvider.select((posts) => posts.firstWhere((p) => p.id == id))),
);
