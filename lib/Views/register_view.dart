import 'package:flutter/material.dart';
import 'package:mynotes/Services/auth/Auth_exception.dart';
import 'package:mynotes/Services/auth/auth_service.dart';

import 'package:mynotes/constants/routes.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
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

              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);

                //final user = AuthService.firebase().currentUser;
                //await user?.sendEmailVerification();
                AuthService.firebase().sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyEmailRoute);
                //devtools.log(UserCredential.toString());
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak Password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid Email',
                );
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication error');
              }

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
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }),
              child: const Text('Login')),
        ],
      ),
    );
  }
}
