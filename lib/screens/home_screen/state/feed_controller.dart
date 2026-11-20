import 'package:android_dev/core/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../services/local_data_service.dart';

final feedPostsProvider = StreamProvider<List<PostModel>>((ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user.asData?.value?.id));
  return ref.watch(localDataServiceProvider).watchFeed(userId);
});

/// Writes on behalf of the logged-in user. Does nothing when nobody is logged in.
class FeedController {
  FeedController(this._localData, this._currentUserId);

  final LocalDataService _localData;
  final String? Function() _currentUserId;

  Future<void> toggleLike(String postId) async {
    final userId = _currentUserId();
    if (userId != null) await _localData.toggleLike(postId: postId, userId: userId);
  }

  Future<void> createPost({required String imageUrl, required String caption}) async {
    final userId = _currentUserId();
    if (userId != null) {
      await _localData.createPost(authorId: userId, imageUrl: imageUrl, caption: caption);
    }
  }

  Future<void> addComment({required String postId, required String body}) async {
    final userId = _currentUserId();
    if (userId != null) await _localData.addComment(postId: postId, userId: userId, body: body);
  }
}

final feedControllerProvider = Provider<FeedController>(
  (ref) => FeedController(
    ref.watch(localDataServiceProvider),
    () => ref.read(currentUserProvider).asData?.value?.id,
  ),
);
