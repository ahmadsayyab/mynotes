import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/Services/auth/Auth_exception.dart';

import 'package:mynotes/Services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/Services/auth/bloc/auth_events.dart';
import 'package:mynotes/Services/auth/bloc/auth_state.dart';

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your email and password to see your notes!'),
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
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter you Password here',
                ),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        context.read<AuthBloc>().add(
                              AuthEventRegister(email, password),
                            );

                        // try {
                        //   await AuthService.firebase()
                        //       .createUser(email: email, password: password);

                        //   //final user = AuthService.firebase().currentUser;
                        //   //await user?.sendEmailVerification();
                        //   AuthService.firebase().sendEmailVerification();
                        //   // ignore: use_build_context_synchronously
                        //   Navigator.of(context).pushNamed(verifyEmailRoute);
                        //   //devtools.log(UserCredential.toString());
                        // } on WeakPasswordAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Weak Password',
                        //   );
                        // } on EmailAlreadyInUseAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Email already in use',
                        //   );
                        // } on InvalidEmailAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Invalid Email',
                        //   );
                        // } on GenericAuthException {
                        //   await showErrorDialog(context, 'Authentication error');
                        // }

                        // on FirebaseAuthException catch (e) {
                        //   if (e.code == 'weak-password') {
                        //     //devtools.log('Weak Password');
                        //     await showErrorDialog(
                        //       context,
                        //       'Weak Password',
                        //     );
                        //   } else if (e.code == 'email-already-in-use') {
                        //     // devtools.log("Email already in use");
                        //     await showErrorDialog(
                        //       context,
                        //       'Email already in use',
                        //     );
                        //   } else if (e.code == 'invalid-email') {
                        //     //devtools.log('Invalid Email');
                        //     await showErrorDialog(
                        //       context,
                        //       'Invalid Email',
                        //     );
                        //   } else {
                        //     await showErrorDialog(
                        //       context,
                        //       'Error: ${e.code}',
                        //     );
                        //   }
                        // } catch (e) {
                        //   await showErrorDialog(
                        //     context,
                        //     e.toString(),
                        //   );
                        // }

                        //print(UserCredential);
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: const Text('Already registered? Login here'),
                  ),
                ],
              ),
              // TextButton(
              //     onPressed: (() {
              //       Navigator.of(context)
              //           .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              //     }),
              //     child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
