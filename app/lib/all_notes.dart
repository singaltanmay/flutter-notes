import 'package:app/model/note.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  _AllNotesState createState() => _AllNotesState();
}

void getAllNotes() async {
  final _url = Uri.parse('http://localhost:3000/');
  final _res = await http.get(_url);
  print(_res);
}

class _AllNotesState extends State<AllNotes> {
  List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
    getAllNotes();
    return ListView(padding: const EdgeInsets.all(8), children: []);
  }
}
