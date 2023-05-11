import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/Services/auth/auth_provider.dart';
import 'package:mynotes/Services/auth/bloc/auth_events.dart';
import 'package:mynotes/Services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //so the first things is that Bloc initial state
  //AuthProvider where all our functions are defined
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialze>(((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVErified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    }));

    //log in
    on<AuthEventLogIn>(((event, emit) async {
      //show loading state at the start
      //emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    }));

    //log out
    on<AuthEventLogOut>(((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    }));
  }
}
