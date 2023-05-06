import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final bool isEmailVErified;

  const AuthUser({required this.isEmailVErified});

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVErified: user.emailVerified,
      );
}
