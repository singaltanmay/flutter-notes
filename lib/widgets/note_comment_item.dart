import 'package:app/model/comment.dart';
import 'package:flutter/material.dart';

class NoteCommentItem extends StatefulWidget {
  final Comment comment;

  const NoteCommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  State<NoteCommentItem> createState() => _NoteCommentItemState();
}

class _NoteCommentItemState extends State<NoteCommentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(widget.comment.body),
    );
  }
}
