import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/Services/auth/Auth_exception.dart';
import 'package:mynotes/Services/auth/auth_provider.dart';
import 'package:mynotes/Services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    //to create object/instance of MockAuthProvider
    final provider = MockAuthProvider();

    //lets write our first test
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized ', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialzation', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialzed in less 2 seconds', () async {
      await provider.initialize();
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Create user should delegate to logIn function", () async {
      final badEmailUser =
          provider.createUser(email: 'sayab@.com', password: 'anypassword');
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: 'someone@bar.com', password: 'abcde');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'sayab', password: 'abcd');
      expect(provider.currentUser, user);
      expect(user.isEmailVErified, false);
    });

    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVErified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'sayab@.com') throw UserNotFoundAuthException();
    if (password == 'abcde') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVErified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (_user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVErified: true);
    _user = newUser;
  }
}
