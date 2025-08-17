import 'package:flutter/material.dart';
import 'package:flutter_base/notes.dart';
import 'package:flutter_base/notes_databse.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notesDatabase = NotesDatabase();
  final noteController = TextEditingController();

  //create
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add new note'),
          content: TextField(controller: noteController),
          actions: [
            FilledButton(
              onPressed: () {
                final newNote = Note(content: noteController.text);
                notesDatabase.createNote(newNote);
                Navigator.pop(context);
                noteController.clear();
              },
              child: Text('Add note'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                noteController.clear();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  //update
  void updateNote(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        noteController.text = note.content;
        return AlertDialog(
          title: Text('Update note'),
          content: TextField(controller: noteController),
          actions: [
            FilledButton(
              onPressed: () {
                notesDatabase.updateNote(note, noteController.text);
                Navigator.pop(context);
                noteController.clear();
              },
              child: Text('Update'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                noteController.clear();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  //delete
  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            FilledButton(
              onPressed: () {
                notesDatabase.deleteNote(note);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: StreamBuilder(stream: notesDatabase.notesStream,
       builder: (context, snapshot) {
         if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator.adaptive());
         }

         final notes = snapshot.data!;
         return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
           final note = notes[index];
           return ListTile(
            title: Text(note.content),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: () => updateNote(note), icon: Icon(Icons.edit)),
                  IconButton(onPressed: () => deleteNote(note), icon: Icon(Icons.delete)),
                ],
              ),
            ),
           );
         });
       },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
    );
  }
}

