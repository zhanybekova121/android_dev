import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/services/post_services.dart';
import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:android_dev/screens/home_screen/state/services_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePostServices extends PostServices {
  const _FakePostServices();

  @override
  List<PostModel> fetchPosts() => const [
        PostModel(id: 'a', imageUrl: 'x', description: 'd', authorId: 'u', authorName: 'u'),
      ];
}

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [postServicesProvider.overrideWithValue(const _FakePostServices())],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('feed is loaded from the injected service', () {
    expect(makeContainer().read(feedControllerProvider).single.id, 'a');
  });

  test('toggleLike updates like state and count', () {
    final container = makeContainer();
    container.read(feedControllerProvider.notifier).toggleLike('a');
    final post = container.read(feedControllerProvider).single;
    expect(post.isLiked, isTrue);
    expect(post.likeCount, 1);
  });

  test('addComment appends a comment', () {
    final container = makeContainer();
    container.read(feedControllerProvider.notifier).addComment('a', CommentModel(username: 'me', text: 'hi'));
    expect(container.read(postProvider('a')).commentCount, 1);
  });
}
