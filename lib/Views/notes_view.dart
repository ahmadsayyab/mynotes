import 'package:flutter/material.dart';
import 'package:mynotes/Services/auth/auth_service.dart';
import 'package:mynotes/constants/routes.dart';

import '../enum/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDailog(context);
                  //devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
              //devtools.log(value.toString());
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogoutDailog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure want to sign out?'),
          actions: [
            TextButton(
                onPressed: (() {
                  Navigator.of(context).pop(false);
                }),
                child: const Text('Cancel')),
            TextButton(
                onPressed: (() {
                  Navigator.of(context).pop(true);
                }),
                child: const Text('Sign out')),
          ],
        );
      }).then((value) => value ?? false);
  //the above "then" is for if a user tap outside the dialog box, so then will be executed.
}
