import 'package:android_dev/screens/content/comment_widget.dart';
import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;

  const PostWidget({super.key, required this.post, required this.onLike});

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CommentsSheet(postId: post.id),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(post.imageUrl, width: double.infinity, fit: BoxFit.cover),
            ),
            Row(children: [
              IconButton(
                icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border),
                color: post.isLiked ? Colors.red : null,
                onPressed: onLike,
              ),
              Text('${post.likeCount}'),
              IconButton(icon: const Icon(Icons.comment), onPressed: () => openBottomSheet(context)),
              Text('${post.commentCount}'),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              const Spacer(),
              IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
            ]),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(post.description)),
          ],
        ),
      );
}

class CommentsSheet extends ConsumerStatefulWidget {
  final String postId;
  const CommentsSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(feedControllerProvider.notifier).addComment(
          widget.postId,
          CommentModel(username: 'me', text: text),
        );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(postProvider(widget.postId)).comments;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 400,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: comments.isEmpty
                ? const Center(child: Text('No comments yet'))
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (_, i) => CommentWidget(comment: comments[i]),
                  ),
          ),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Add a comment...'),
                  onSubmitted: (_) => _send(),
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.send), onPressed: _send),
          ]),
        ]),
      ),
    );
  }
}
