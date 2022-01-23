import 'dart:convert';

import 'package:app/model/note.dart';
import 'package:app/new_note.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  _AllNotesState createState() => _AllNotesState();
}

Future<List<Note>> fetchNotes() async {
  final response = await http.get(Uri.parse('http://localhost:3000/'),
      headers: {
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
    throw Exception('Failed to load all notes');
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
        icon: Icon(Icons.add),
        label: Text('New Note'.toUpperCase()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: noteWidgetsList,
      ),
    );
  }
}
