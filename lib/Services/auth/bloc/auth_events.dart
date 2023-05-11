import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

//for initialization of firebase
class AuthEventInitialze extends AuthEvent {
  const AuthEventInitialze();
}

//login
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

//logout
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
