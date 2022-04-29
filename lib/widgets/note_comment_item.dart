import 'package:flutter/material.dart';

class NoteCommentItem extends StatefulWidget {
  const NoteCommentItem({Key? key}) : super(key: key);

  @override
  State<NoteCommentItem> createState() => _NoteCommentItemState();
}

class _NoteCommentItemState extends State<NoteCommentItem> {
  @override
  Widget build(BuildContext context) {
    return const Text("This is a comment");
  }
}
