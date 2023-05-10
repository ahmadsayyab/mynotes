import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final String id;
  final String email;

  final bool isEmailVErified;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVErified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVErified: user.emailVerified,
      );
}
