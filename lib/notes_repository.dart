import 'note.dart';
import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart';

///Во-вторых, нам нужно место для хранения записей

class NotesRepository {
  late final Store _store;
  late final Box<Note> _box;

  List<Note> get notes => _box.getAll(); //READ (get the actual data)

  Future initDB() async {
    _store = await openStore(); //initial access to DB
    _box = _store.box<Note>(); //get access to part of DB where Notes stored
  }

  Future addNote(Note note) async { //CREATE
    await _box.putAsync(note);
  }

  void deleteNote(Note note) { // DELETE
    _box.remove(note.id);
  }

  Future updateNote({required Note oldNote, required Note newNote}) async { // UPDATE
   _box.remove(oldNote.id);
   await _box.putAsync(newNote);
  }
}
