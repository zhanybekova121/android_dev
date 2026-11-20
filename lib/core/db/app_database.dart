import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Registered accounts. Passwords are never stored: only a salted SHA-256 hash.
@DataClassName('AppUser')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().withLength(min: 3, max: 30).unique()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get salt => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get bio => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A post always belongs to a user; deleting the user deletes their posts.
@TableIndex(name: 'posts_author_idx', columns: {#authorId})
@TableIndex(name: 'posts_created_idx', columns: {#createdAt})
class Posts extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get imageUrl => text()();
  TextColumn get caption => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per (user, post). The composite key guarantees a user can like a post only once.
@TableIndex(name: 'likes_post_idx', columns: {#postId})
class Likes extends Table {
  TextColumn get userId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get postId => text().references(Posts, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {userId, postId};
}

@TableIndex(name: 'comments_post_idx', columns: {#postId})
class Comments extends Table {
  TextColumn get id => text()();
  TextColumn get postId => text().references(Posts, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Single-row table (id is always 1) remembering who is logged in across app restarts.
@DataClassName('AppSession')
class AppSessions extends Table {
  IntColumn get id => integer()();
  TextColumn get userId => text().nullable().references(Users, #id, onDelete: KeyAction.setNull)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Users, Posts, Likes, Comments, AppSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'social_app'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 only held a local cache with no accounts, so it is replaced rather than converted.
            await customStatement('DROP TABLE IF EXISTS cached_posts');
            await customStatement('DROP TABLE IF EXISTS user_profiles');
            await customStatement('DROP TABLE IF EXISTS post_comments');
            await m.createAll();
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
