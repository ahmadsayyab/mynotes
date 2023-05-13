import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mynotes/Services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/Services/auth/bloc/auth_events.dart';
import 'package:mynotes/Services/auth/bloc/auth_state.dart';
import 'package:mynotes/Services/auth/firebase_auth_provider.dart';
import 'package:mynotes/Views/forgot_password_view.dart';
import 'package:mynotes/Views/login_views.dart';
import 'package:mynotes/Views/notes/create_update_note_view.dart';
import 'package:mynotes/Views/notes/notes_view.dart';
import 'package:mynotes/Views/register_view.dart';
import 'package:mynotes/Views/verify_email_view.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';

//import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // notesRoute: (context) => const NotesView(),
        // verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //we are making use of this "context" because it has the
    //context of AuthBloc hidden in it, due to use in above
    context.read<AuthBloc>().add(const AuthEventInitialze());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: ((context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordViewState();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    }));
  }
}
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVErified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           //return const Text('Done');

//           // if (user?.emailVerified ?? false) {
//           //   print('You are a verified user');
//           // } else {
//           //   //print('You need to verify your email first');
//           //   // Navigator.of(context).push(
//           //   //   MaterialPageRoute(
//           //   //     builder: (context) => const VerifyEmailView(),
//           //   //   ),
//           //   // );
//           //   return VerifyEmailView();
//           // }
//           //return const LoginView();
//           //return const Text('Done');
//           default:
//             //return const Text('loading...');
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

//the reason we are going to create a Homepage as statefull widget is because
//we will use textediting controller and we will deal with some data

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => CounterBloc(),
//         child: Scaffold(
//             appBar: AppBar(title: const Text('Testing bloc')),
//             body: BlocConsumer<CounterBloc, CounterState>(
//               listener: (context, state) {
//                 //clear the text in the text field
//                 _controller.clear();
//               },
//               builder: (context, state) {
//                 final invalidValue = (state is CounterStateInvalidNumber)
//                     ? state.invalidValue
//                     : '';
//                 return Column(
//                   children: [
//                     Text('Current Value => ${state.value}'),
//                     Visibility(
//                       child: Text('Invalid inpute $invalidValue'),
//                       visible: state is CounterStateInvalidNumber,
//                     ),
//                     TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                         hintText: 'Enter a number here',
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     Row(
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(DecreamentEvent(_controller.text));
//                           },
//                           child: const Text('-'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(IncreamentEvent(_controller.text));
//                           },
//                           child: const Text('+'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             )));
//   }
// }

// //now we have to create a counterState
// @immutable
// abstract class CounterState {
//   final int value;

//   const CounterState(this.value);
// }

// //now we have to create 2-states of counterState invalid & valid

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int
//         previousValue, //we use the previous value to show it to the user just
//     // that it was your previous value
//   }) : super(previousValue);
// }

// //now to create events as well
// @immutable
// abstract class CounterEvent {
//   final String value;

//   const CounterEvent(this.value);
// }

// class IncreamentEvent extends CounterEvent {
//   const IncreamentEvent(String value) : super(value);
// }

// class DecreamentEvent extends CounterEvent {
//   const DecreamentEvent(String value) : super(value);
// }

// //now to create the main class that Bloc

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncreamentEvent>(((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     }));
//     on<DecreamentEvent>(((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     }));
//   }
// }
