import 'dart:io';

import 'package:app/model/note.dart';
import 'package:app/model/resourceUri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NoteListTile extends StatefulWidget {
  final Note note;
  final onDelete;

  const NoteListTile({Key? key, required this.note, this.onDelete}) : super(key: key);

  @override
  _NoteListTileState createState() => _NoteListTileState();

  void printServerCommFailedError() {
    stderr.writeln('Failed to communicate with server');
  }

  Future<bool> delete() async {
    try {
      final response = await http.delete(ResourceUri.getNoteUri(note.id!),
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
}

class _NoteListTileState extends State<NoteListTile> {
  @override
  Widget build(BuildContext context) {
    String title = widget.note.title;
    String body = widget.note.body;
    return Column(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.arrow_drop_down_circle),
                title: Text(title),
                subtitle: Text(
                  widget.note.created ?? "",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  body,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  FlatButton(
                    textColor: const Color(0xFF6200EE),
                    onPressed: () {
                      widget.delete();
                      widget.onDelete();
                    },
                    child: Text('Delete'.toUpperCase()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
