import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

//for initialization of firebase
class AuthEventInitialze extends AuthEvent {
  const AuthEventInitialze();
}

//email verification
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

//login
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

//Register
class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

//if user is not register
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

//forgot password
class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  const AuthEventForgotPassword({this.email});
}

//logout
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
