import 'package:flutter_base/notes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesDatabase {
  final database = Supabase.instance.client.from('notes');

  //create
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  //read
  final notesStream = Supabase.instance.client
      .from('notes')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  //update
  Future updateNote(Note oldNote, String newNote) async {
    await database.update({'content': newNote}).eq('id', oldNote.id!);
  }

  //delete
  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
