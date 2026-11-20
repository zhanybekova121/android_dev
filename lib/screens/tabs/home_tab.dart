import 'package:android_dev/screens/content/post_widget.dart';
import 'package:android_dev/screens/content/stories_bar.dart';
import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedControllerProvider);
    final stories = ref.watch(storiesProvider);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('Instagram')),
      body: ListView.builder(
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return StoriesBar(stories: stories);
          final post = posts[index - 1];
          return Padding(
            padding: const EdgeInsets.all(4),
            child: PostWidget(
              post: post,
              onLike: () => ref.read(feedControllerProvider.notifier).toggleLike(post.id),
            ),
          );
        },
      ),
    );
  }
}
