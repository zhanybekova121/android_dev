import 'dart:convert';
import 'dart:math';

import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/db/database_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Registration, login and logout backed by the local database.
class AuthService {
  AuthService(this._db);

  final AppDatabase _db;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Emits the logged-in user, or null when nobody is logged in.
  Stream<AppUser?> watchCurrentUser() {
    final query = _db.select(_db.appSessions).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.appSessions.userId)),
    ])
      ..where(_db.appSessions.id.equals(1));
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.users));
  }

  Future<AppUser> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final name = username.trim();
    final mail = email.trim().toLowerCase();
    if (name.length < 3 || name.length > 30) {
      throw const AuthException('Username must be 3-30 characters.');
    }
    if (!_emailPattern.hasMatch(mail)) throw const AuthException('Enter a valid email.');
    if (password.length < 6) throw const AuthException('Password must be at least 6 characters.');

    final taken = await (_db.select(_db.users)
          ..where((u) => u.email.equals(mail) | u.username.equals(name)))
        .get();
    if (taken.any((u) => u.email == mail)) {
      throw const AuthException('An account with this email already exists.');
    }
    if (taken.isNotEmpty) throw const AuthException('This username is already taken.');

    final salt = _newSalt();
    final user = AppUser(
      id: 'user-${DateTime.now().microsecondsSinceEpoch}',
      username: name,
      email: mail,
      passwordHash: _hash(password, salt),
      salt: salt,
      createdAt: DateTime.now(),
    );
    await _db.into(_db.users).insert(user);
    await _startSession(user.id);
    return user;
  }

  Future<AppUser> login({required String email, required String password}) async {
    final user = await (_db.select(_db.users)
          ..where((u) => u.email.equals(email.trim().toLowerCase())))
        .getSingleOrNull();
    // Same message for unknown email and wrong password so accounts cannot be probed.
    if (user == null || user.passwordHash != _hash(password, user.salt)) {
      throw const AuthException('Incorrect email or password.');
    }
    await _startSession(user.id);
    return user;
  }

  Future<void> logout() => (_db.delete(_db.appSessions)..where((s) => s.id.equals(1))).go();

  Future<void> updateProfile({
    required String userId,
    required String username,
    String? avatarUrl,
    String? bio,
  }) async {
    final name = username.trim();
    if (name.length < 3 || name.length > 30) {
      throw const AuthException('Username must be 3-30 characters.');
    }
    final clash = await (_db.select(_db.users)
          ..where((u) => u.username.equals(name) & u.id.equals(userId).not()))
        .getSingleOrNull();
    if (clash != null) throw const AuthException('This username is already taken.');
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        username: Value(name),
        avatarUrl: Value(avatarUrl == null || avatarUrl.isEmpty ? null : avatarUrl),
        bio: Value(bio == null || bio.isEmpty ? null : bio),
      ),
    );
  }

  Future<void> _startSession(String userId) => _db
      .into(_db.appSessions)
      .insertOnConflictUpdate(AppSessionsCompanion.insert(id: const Value(1), userId: Value(userId)));

  static String _newSalt() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  static String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(databaseProvider)));

final currentUserProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authServiceProvider).watchCurrentUser(),
);
