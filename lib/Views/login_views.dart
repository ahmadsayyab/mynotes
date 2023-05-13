import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/Services/auth/Auth_exception.dart';

import 'package:mynotes/Services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/Services/auth/bloc/auth_events.dart';
import 'package:mynotes/Services/auth/bloc/auth_state.dart';

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please log in to your account in order to interact with and create notes!'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter you Email here',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter you Password here',
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventLogIn(
                        email,
                        password,
                      ));

                  //   try {

                  //     //   // ignore: non_constant_identifier_names
                  //     //   final UserCredential = await AuthService.firebase()
                  //     //       .logIn(email: email, password: password);
                  //     //   final user = AuthService.firebase().currentUser;
                  //     //   if (user?.isEmailVErified ?? false) {
                  //     //     //email is verified
                  //     //     Navigator.of(context).pushNamedAndRemoveUntil(
                  //     //       notesRoute,
                  //     //       (route) => false,
                  //     //     );
                  //     //   } else {
                  //     //     //email is not verified
                  //     //     Navigator.of(context).pushNamedAndRemoveUntil(
                  //     //       verifyEmailRoute,
                  //     //       (route) => false,
                  //     //     );
                  //     //   }
                  //     //   //devtools.log(UserCredential.toString());
                  //     //   // ignore: use_build_context_synchronously

                  //   }
                  //   // catch (e) {
                  //   //   print(e);
                  //   // }
                  //   on UserNotFoundAuthException {
                  //     await showErrorDialog(
                  //       context,
                  //       'user not found',
                  //     );
                  //   } on WrongPasswordAuthException {
                  //     //print('testing');
                  //     await showErrorDialog(
                  //       context,
                  //       'Wrong Credentials',
                  //     );
                  //   } on GenericAuthException {
                  //     await showErrorDialog(context, 'Authentication error');
                  //   }
                  //   // on FirebaseAuthException catch (e) {
                  //   //   if (e.code == 'user-not-found') {
                  //   //     //devtools.log('User not found');
                  //   //     await showErrorDialog(
                  //   //       context,
                  //   //       'user not found',
                  //   //     );
                  //   //   } else if (e.code == 'wrong-password') {
                  //   //     //devtools.log("Wrong Password");
                  //   //     //print(e.code);
                  //   //     await showErrorDialog(
                  //   //       context,
                  //   //       'Wrong Credentials',
                  //   //     );
                  //   //   } else {
                  //   //     await showErrorDialog(
                  //   //       context,
                  //   //       'Error: ${e.code}',
                  //   //     );
                  //   //   }
                  //   // } catch (e) {
                  //   //   await showErrorDialog(
                  //   //     context,
                  //   //     e.toString(),
                  //   //   );
                  //   // }
                  //   //catch (e)
                  //   //   print(e.runtimeType);
                  //   //   print('Something bad happened');
                  //   //   print(e);
                  //   // }

                  //   //print(UserCredential);
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text('I forgot my password'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Not register yet? register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
