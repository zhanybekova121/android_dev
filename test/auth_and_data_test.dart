import 'package:android_dev/core/auth/auth_service.dart';
import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/screens/home_screen/services/local_data_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AuthService auth;
  late LocalDataService data;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    auth = AuthService(db);
    data = LocalDataService(db);
  });
  tearDown(() => db.close());

  group('auth', () {
    test('register logs in, stores a salted hash, not the password', () async {
      final user = await auth.register(username: 'anna', email: 'Anna@Mail.com', password: 'secret1');
      expect(user.email, 'anna@mail.com');
      expect(user.passwordHash, isNot('secret1'));
      expect(user.salt, isNotEmpty);
      expect((await auth.watchCurrentUser().first)?.id, user.id);
    });

    test('rejects duplicate email and username', () async {
      await auth.register(username: 'anna', email: 'a@mail.com', password: 'secret1');
      expect(
        () => auth.register(username: 'other', email: 'A@mail.com', password: 'secret1'),
        throwsA(isA<AuthException>()),
      );
      expect(
        () => auth.register(username: 'anna', email: 'b@mail.com', password: 'secret1'),
        throwsA(isA<AuthException>()),
      );
    });

    test('rejects invalid input', () {
      expect(() => auth.register(username: 'an', email: 'a@mail.com', password: 'secret1'), throwsA(isA<AuthException>()));
      expect(() => auth.register(username: 'anna', email: 'nope', password: 'secret1'), throwsA(isA<AuthException>()));
      expect(() => auth.register(username: 'anna', email: 'a@mail.com', password: '123'), throwsA(isA<AuthException>()));
    });

    test('logout clears session, login restores it, wrong password fails', () async {
      await auth.register(username: 'anna', email: 'a@mail.com', password: 'secret1');
      await auth.logout();
      expect(await auth.watchCurrentUser().first, isNull);
      expect(() => auth.login(email: 'a@mail.com', password: 'wrong!!'), throwsA(isA<AuthException>()));
      expect(() => auth.login(email: 'x@mail.com', password: 'secret1'), throwsA(isA<AuthException>()));
      await auth.login(email: 'a@mail.com', password: 'secret1');
      expect((await auth.watchCurrentUser().first)?.username, 'anna');
    });
  });

  group('likes and comments in the database', () {
    late AppUser anna;
    late AppUser bob;

    setUp(() async {
      anna = await auth.register(username: 'anna', email: 'a@mail.com', password: 'secret1');
      bob = await auth.register(username: 'bobby', email: 'b@mail.com', password: 'secret1');
      await data.createPost(authorId: anna.id, imageUrl: 'https://x/y.png', caption: 'hello');
    });

    Future<String> postId() async => (await data.watchFeed(anna.id).first).single.id;

    test('likes are per user and toggle off', () async {
      final id = await postId();
      await data.toggleLike(postId: id, userId: anna.id);
      await data.toggleLike(postId: id, userId: bob.id);

      var asAnna = (await data.watchFeed(anna.id).first).single;
      expect(asAnna.likeCount, 2);
      expect(asAnna.isLiked, isTrue);

      await data.toggleLike(postId: id, userId: anna.id);
      asAnna = (await data.watchFeed(anna.id).first).single;
      expect(asAnna.likeCount, 1);
      expect(asAnna.isLiked, isFalse);
      expect((await data.watchFeed(bob.id).first).single.isLiked, isTrue);
    });

    test('comments store author and count', () async {
      final id = await postId();
      await data.addComment(postId: id, userId: bob.id, body: 'nice');
      await data.addComment(postId: id, userId: anna.id, body: 'thanks');

      final comments = await data.watchComments(id).first;
      expect(comments.map((c) => '${c.authorName}: ${c.body}'), ['bobby: nice', 'anna: thanks']);
      expect((await data.watchFeed(anna.id).first).single.commentCount, 2);
    });

    test('deleting a post removes its likes and comments', () async {
      final id = await postId();
      await data.toggleLike(postId: id, userId: bob.id);
      await data.addComment(postId: id, userId: bob.id, body: 'nice');
      await data.deletePost(id);
      expect(await db.select(db.likes).get(), isEmpty);
      expect(await db.select(db.comments).get(), isEmpty);
    });

    test('a like for a missing post is rejected by the foreign key', () {
      expect(() => data.toggleLike(postId: 'nope', userId: anna.id), throwsA(anything));
    });
  });
}
