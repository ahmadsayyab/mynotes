import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/Services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

//we are in a loading/initialization state when a user just open
//the application or click on login button to connect with firebase

// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

//forgot password
class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

// class AuthStateLoginFailure extends AuthState {
//   final Exception
//       exception; //we carry with ourself the exception that what cause the error
//   const AuthStateLoginFailure(this.exception);
// }

//if unverified user tries to login
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

//equatable is to differentiate between the exception and isLoading.
  @override
  List<Object?> get props => [exception, isLoading];
}

//there could be some logout erroe like firebae API call fails etc
// class AuthStateLogoutFailure extends AuthState {
//   final Exception exception;
//   const AuthStateLogoutFailure(this.exception);
// }
