import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/Services/cloud/cloud_note.dart';
import 'package:mynotes/Services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/Services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes/Services/crud/crud_exceptions.dart';

class FirebasseCloudStorage {
  //now to talk with firestore, to read all the notes
  final notes = FirebaseFirestore.instance.collection('notes');

  //delete a specific notes
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete(); //(documentId) is the pathe which we
      //provide to delete a specific note
    } catch (e) {
      throw CloudNotDeleteNoteException();
    }
  }

  //updating notes
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CloudNotUpdateNoteException();
    }
  }

  //create a function to read notes for a specific user
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId)); //the last line
  //shows notes to a specific user

  //create a function to read all notes
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CloudNotGetAllNoteException();
    }
  }

  //creat a function to create notes
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  //way to make a class singleton
  static final FirebasseCloudStorage _shared =
      FirebasseCloudStorage._sharedInstance();

  //First create a private constructor
  FirebasseCloudStorage._sharedInstance();

  //then create a factory constructor, then inreturn talk to the
  //above static final , which in return talks to the private
  //constructor.
  factory FirebasseCloudStorage() => _shared;
}
