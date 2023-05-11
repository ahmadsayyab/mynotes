import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/Services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

//we are in a loading/initialization state when a user just open
//the application or click on login button to connect with firebase

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

// class AuthStateLoginFailure extends AuthState {
//   final Exception
//       exception; //we carry with ourself the exception that what cause the error
//   const AuthStateLoginFailure(this.exception);
// }

//if unverified user tries to login
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

//there could be some logout erroe like firebae API call fails etc
class AuthStateLogoutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogoutFailure(this.exception);
}
