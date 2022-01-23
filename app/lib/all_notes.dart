import 'dart:convert';

import 'package:app/model/note.dart';
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
    var notesList = jsonDecode(response.body);
    print(notesList);
    return [];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _AllNotesState extends State<AllNotes> {
  List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
   fetchNotes();
    print("What is this?");
    return ListView(padding: const EdgeInsets.all(8), children: []);
  }
}
