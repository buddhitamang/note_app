import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'notes.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  //Initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NotesSchema],
      directory: dir.path,
    );
  }



//list of nodes
  final List<Notes> currentNotes = [];

  //create a new node and save to db
  Future<void> addNote(String textFromUser) async {
    //create a new node object
    final newNote = Notes()..text = textFromUser;//or final newNote = Notes();    newNote.text = textFromUser;

    //save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //re-read from databse
    await fetchNotes();
  }

//read databse
  Future<void> fetchNotes() async {
    List<Notes> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }


//update database
  Future<void> updateNote(int id, String newText) async{
    final existingNote=await isar.notes.get(id);
    if(existingNote!=null){
      existingNote.text=newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

//delete database
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
