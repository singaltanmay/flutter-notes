import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app/model/note.dart';
import 'package:app/model/resourceUri.dart';
import 'package:app/ui/newNote.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  _AllNotesState createState() => _AllNotesState();
}

void printServerCommFailedError() {
  stderr.writeln('Failed to communicate with server');
}

Future<List<Note>> fetchNotes() async {
  try {
    final response = await http.get(ResourceUri.getBaseUri(), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List responseList = jsonDecode(response.body);
      List<Note> noteObjectsList = [];
      for (var element in responseList) {
        noteObjectsList.add(Note.fromJson(element));
      }
      return noteObjectsList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      stderr.writeln('Failed to load all notes');
      return [];
    }
  } on Exception {
    printServerCommFailedError();
    return [];
  }
}

Future<bool> deleteAllNotes() async {
  try {
    final response = await http.delete(ResourceUri.getBaseUri(), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete all notes');
    }
  } on Exception {
    printServerCommFailedError();
    return false;
  }
}

Future<bool> deleteNote(String noteId) async {
  try {
    final response = await http.delete(ResourceUri.getNoteUri(noteId),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete the note');
    }
  } on Exception {
    printServerCommFailedError();
    return false;
  }
}

class _AllNotesState extends State<AllNotes> {
  List<Note> _notes = [];
  bool _loadNotes = true;

  @override
  Widget build(BuildContext context) {
    if (_loadNotes) {
      fetchNotes().then((value) => setState(() {
            _loadNotes = false;
            _notes = value;
          }));
    }

    List<Widget> noteWidgetsList = [];
    for (var note in _notes) {
      noteWidgetsList.add(ListTile(
        title: Text(note.title),
        subtitle: Text(note.body),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("All Notes"),
          actions: [
            RotatedBox(
              quarterTurns: 1,
              child: PopupMenuButton<int>(
                  itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                        const PopupMenuItem<int>(
                            value: 0, child: Text('Delete All'))
                      ],
                  onSelected: (int value) {
                    if (value == 0) {
                      deleteAllNotes().then((deleted) => {
                            if (!deleted)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not delete all notes'),
                                  ),
                                ),
                              }
                            else
                              setState(() {
                                _notes.clear();
                              })
                          });
                    }
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewNote()),
            ).then((value) => setState(() {
                  _loadNotes = true;
                }));
            // Respond to button press
          },
          icon: const Icon(Icons.add),
          label: Text('New Note'.toUpperCase()),
        ),
        body: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            var note = _notes[index];
            return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(note.id ?? note.title),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  if (note.id == null) {
                    // Then show a snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '"${note.title.substring(0, min(30, note.title.length))}..." cannot be deleted')));
                    return;
                  }
                  // Remove the item from the data source.
                  deleteNote(note.id!).then((value) => {
                        if (!value)
                          {stdout.writeln("Note could not be deleted $note")}
                      });
                  setState(() {
                    _notes.removeAt(index);
                  });
                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '"${note.title.substring(0, min(30, note.title.length))}..." deleted')));
                },
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.body),
                ));
          },
        ));
  }
}
