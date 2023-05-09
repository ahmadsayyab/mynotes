import 'dart:async';
//import 'dart:math';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';

//this notes_service will talk with database

class NotesService {
  //this is for let say in the future NoteService open database so other
  //functions can read from it
  Database? _db;

  //now to work with streams
  List<DatabaseNote> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() =>
      _shared; //noteService cannot be initialzed elsewhere

  //create a streamController
  //final _notesStreamController =
  //  StreamController<List<DatabaseNote>>.broadcast();
  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotDFindUser {
      final createdUser = await creatUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  //Now we gonna fetch all the notes
  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes
        .toList(); //this means that the stream _notes will be now fill with
    //list of all notes

    _notesStreamController.add(_notes); //streamController us used for UI.
  }

  Future<DatabaseNote> upDateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure notes exists
    await getNote(id: note.id);

    //Update DataBase
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatesCount == 0) {
      throw CouldNotUpdateNotes();
    } else {
      final updateNotes = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updateNotes.id);
      _notes.add(updateNotes);
      _notesStreamController.add(_notes);
      return updateNotes;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNotes();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note); // to update our local cache
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    //make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotDFindUser();
    }

    const text = '';
    //create the note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCoud: true,
    );

    _notes.add(note);
    //we have to add this note to streamController as well to show it to the
    //outside world
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotDFindUser();
    } else {
      return DatabaseUser.fromRow(results
          .first); //meand the first row which it incounter will be 1 or no
    }
  }

  Future<DatabaseUser> creatUser({required String email}) async {
    await _ensureDBIsOpen();

    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserALreadyExixts();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDBIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    //lets get document directory path
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      //create user table
      await db.execute(createUserTable);

      //create note table
      await db.execute(createNoteTable);

      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID  = $id, email = $email';

//the below code is for to compare users of the same class.
//id == other.id means to look for the same user in the same class.
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCoud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCoud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCoud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID  = $id, userID = $userId, isSyncedWithCloud = $isSyncedWithCoud, text = $text';

//the below code is for to compare users of the same class.
//id == other.id means to look for the same user in the same class.
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//below are the constants that we use
// file name we will sotre it in document folder of
//our application
const dbName = 'Notes.db';

//create tabel
const noteTable = 'note';
const userTable = 'user';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const createUserTable = '''CREATE TABLE IF NOT EXISTS"user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const createNoteTable = '''
      CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
