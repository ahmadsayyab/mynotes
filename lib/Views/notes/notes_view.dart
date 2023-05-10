import 'package:flutter/material.dart';
import 'package:mynotes/Services/auth/auth_service.dart';
import 'package:mynotes/Services/cloud/cloud_note.dart';
import 'package:mynotes/Services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/Services/crud/notes_service.dart';
import 'package:mynotes/Views/notes/notes_list_view.dart';
import 'package:mynotes/constants/routes.dart';

import '../../enum/menu_action.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebasseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebasseCloudStorage();
    //_notesService.open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDailog(context);

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
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );

                  //print(allNotes);
                  //return const Text("Got all the notes");
                  // return ListView.builder(
                  //   itemCount: allNotes.length,
                  //   itemBuilder: (context, index) {
                  //     final note = allNotes[index];
                  //     return ListTile(
                  //       title: Text(
                  //         note.text,
                  //         maxLines: 1,
                  //         softWrap: true,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     );
                  //   },
                  // );
                } else {
                  return CircularProgressIndicator();
                }
              //return const Text('Waiting for all notes');
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

// Future<bool> showLogoutDailog(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Sign out'),
//           content: const Text('Are you sure want to sign out?'),
//           actions: [
//             TextButton(
//                 onPressed: (() {
//                   Navigator.of(context).pop(false);
//                 }),
//                 child: const Text('Cancel')),
//             TextButton(
//                 onPressed: (() {
//                   Navigator.of(context).pop(true);
//                 }),
//                 child: const Text('Sign out')),
//           ],
//         );
//       }).then((value) => value ?? false);
//   //the above "then" is for if a user tap outside the dialog box, so then will be executed.
// }
