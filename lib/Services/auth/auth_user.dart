import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final String? email;

  final bool isEmailVErified;

  const AuthUser({required this.email, required this.isEmailVErified});

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVErified: user.emailVerified,
      );
}
