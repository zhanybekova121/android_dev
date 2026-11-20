import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/db/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

/// Posts, likes and comments, all stored in the local database.
class LocalDataService {
  LocalDataService(this._db);

  final AppDatabase _db;

  /// Feed, newest first. Like and comment counts are computed from the `likes`
  /// and `comments` tables; [viewerId] decides which posts are marked as liked.
  Stream<List<PostModel>> watchFeed(String? viewerId) {
    return _db
        .customSelect(
          '''
          SELECT p.id, p.image_url, p.caption, p.author_id,
                 u.username AS author_name, u.avatar_url AS author_avatar,
                 (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.id) AS like_count,
                 (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.id) AS comment_count,
                 EXISTS (SELECT 1 FROM likes l WHERE l.post_id = p.id AND l.user_id = ?1) AS is_liked
          FROM posts p
          JOIN users u ON u.id = p.author_id
          ORDER BY p.created_at DESC, p.id DESC
          ''',
          variables: [Variable<String>(viewerId)],
          readsFrom: {_db.posts, _db.users, _db.likes, _db.comments},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              PostModel(
                id: row.read<String>('id'),
                imageUrl: row.read<String>('image_url'),
                description: row.read<String>('caption'),
                authorId: row.read<String>('author_id'),
                authorName: row.read<String>('author_name'),
                authorAvatarUrl: row.readNullable<String>('author_avatar'),
                likeCount: row.read<int>('like_count'),
                commentCount: row.read<int>('comment_count'),
                isLiked: row.read<int>('is_liked') == 1,
              ),
          ],
        );
  }

  Future<void> createPost({
    required String authorId,
    required String imageUrl,
    required String caption,
  }) =>
      _db.into(_db.posts).insert(
            PostsCompanion.insert(
              id: 'post-${DateTime.now().microsecondsSinceEpoch}',
              authorId: authorId,
              imageUrl: imageUrl,
              caption: caption,
            ),
          );

  Future<void> deletePost(String id) => (_db.delete(_db.posts)..where((p) => p.id.equals(id))).go();

  /// Adds the like if the user has not liked the post yet, removes it otherwise.
  Future<void> toggleLike({required String postId, required String userId}) {
    return _db.transaction(() async {
      final removed = await (_db.delete(_db.likes)
            ..where((l) => l.postId.equals(postId) & l.userId.equals(userId)))
          .go();
      if (removed == 0) {
        await _db.into(_db.likes).insert(LikesCompanion.insert(userId: userId, postId: postId));
      }
    });
  }

  Stream<List<CommentModel>> watchComments(String postId) {
    final query = _db.select(_db.comments).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.comments.userId)),
    ])
      ..where(_db.comments.postId.equals(postId))
      ..orderBy([OrderingTerm.asc(_db.comments.createdAt)]);
    return query.watch().map(
          (rows) => [
            for (final row in rows)
              CommentModel(
                id: row.readTable(_db.comments).id,
                authorId: row.readTable(_db.users).id,
                authorName: row.readTable(_db.users).username,
                body: row.readTable(_db.comments).body,
                createdAt: row.readTable(_db.comments).createdAt,
              ),
          ],
        );
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String body,
  }) =>
      _db.into(_db.comments).insert(
            CommentsCompanion.insert(
              id: 'comment-${DateTime.now().microsecondsSinceEpoch}',
              postId: postId,
              userId: userId,
              body: body,
            ),
          );

  Future<void> deleteComment(String id) =>
      (_db.delete(_db.comments)..where((c) => c.id.equals(id))).go();
}

final localDataServiceProvider = Provider<LocalDataService>(
  (ref) => LocalDataService(ref.watch(databaseProvider)),
);
