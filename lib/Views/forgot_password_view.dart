import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/Services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/Services/auth/bloc/auth_events.dart';
import 'package:mynotes/Services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordViewState extends StatefulWidget {
  const ForgotPasswordViewState({super.key});

  @override
  State<ForgotPasswordViewState> createState() =>
      _ForgotPasswordViewStateState();
}

class _ForgotPasswordViewStateState extends State<ForgotPasswordViewState> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'We could not process your request. Please make sure that you are a registered user, if not please go one step back',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text(
                'if you forgot your password, simply enter your email and we will send you a password reset link'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'your email address...',
              ),
            ),
            TextButton(
              onPressed: () {
                final email = _controller.text;
                context
                    .read<AuthBloc>()
                    .add(AuthEventForgotPassword(email: email));
              },
              child: const Text('Send me password reset link'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Back to login page'),
            ),
          ]),
        ),
      ),
    );
  }
}
