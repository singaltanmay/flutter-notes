import 'package:flutter/material.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {

  void postNewNote() {
    // TODO implement posting note to the server
    print('New Note Saved!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded), onPressed: postNewNote,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: TextFormField(
                maxLines: 1000,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Body',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
