import 'package:flutter/material.dart';
import 'package:mynotes/Services/auth/auth_service.dart';
import 'package:mynotes/Views/login_views.dart';
import 'package:mynotes/Views/notes_view.dart';
import 'package:mynotes/Views/register_view.dart';
import 'package:mynotes/Views/verify_email_view.dart';
import 'package:mynotes/constants/routes.dart';

//import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVErified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          //return const Text('Done');

          // if (user?.emailVerified ?? false) {
          //   print('You are a verified user');
          // } else {
          //   //print('You need to verify your email first');
          //   // Navigator.of(context).push(
          //   //   MaterialPageRoute(
          //   //     builder: (context) => const VerifyEmailView(),
          //   //   ),
          //   // );
          //   return VerifyEmailView();
          // }
          //return const LoginView();
          //return const Text('Done');
          default:
            //return const Text('loading...');
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
