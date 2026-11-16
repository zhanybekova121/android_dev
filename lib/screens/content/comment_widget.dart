import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            comment.avatarUrl != null ? NetworkImage(comment.avatarUrl!) : null,
        child: comment.avatarUrl == null
            ? Text(comment.username[0].toUpperCase())
            : null,
      ),
      title: Text(
        comment.username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(comment.text),
    );
  }
}
