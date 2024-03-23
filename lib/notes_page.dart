import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/notes_database.dart';
import 'package:provider/provider.dart';

import 'models/notes.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  NoteDatabase db=new NoteDatabase();
  final textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //on app startup fetch existing notes
    readNotes();
  }

  //create note
  void createNote() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add notes'),
            content: TextField(
              decoration: InputDecoration(

              ),
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  //add to the database
                  context.read<NoteDatabase>().addNote(textController.text);
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text('create'),
              )
            ],
          );
        });
  }

  //read
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //updata
  void updateNote(Notes note) {
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("update note"),
              content: TextField(
                controller: textController,
              ),
              actions: [
                //update button
                MaterialButton(
                  onPressed: () {
                    //update note in db
                    context
                        .read<NoteDatabase>()
                        .updateNote(note.id, textController.text);
                    textController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('update'),
                )
              ],
            ));
  }

  //delete
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {


    const bool isCompleted=false;

    //note database
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Notes> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            final note = currentNotes[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blue,
                child: ListTile(
                  leading: Checkbox(
                    value: isCompleted, onChanged: (bool? value) {
                      setState(() {

                      });
                  },

                  ),
                  title: Text(note.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => updateNote(note),
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () => deleteNote(note.id),
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
