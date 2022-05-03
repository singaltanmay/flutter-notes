import 'package:app/dao/comment_dao.dart';
import 'package:app/dao/note_dao.dart';
import 'package:app/model/comment.dart';
import 'package:app/model/note.dart';
import 'package:app/widgets/button_bar_text_button.dart';
import 'package:app/widgets/note_comment_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';

import 'note_editor.dart';

final numDisplay = createDisplay();

class NoteDetails extends StatefulWidget {
  Note note;
  List<Comment> commentsList = [];

  NoteDetails({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState();

  // TODO
  onNoteEdited() {}
}

class _NoteDetailsState extends State<NoteDetails> {
  final NoteDao noteDao = NoteDao();
  final CommentDao commentDao = CommentDao();

  void fetchCommentsList() {
    commentDao
        .getCommentsForNote(widget.note.id)
        .then((_commentsList) => setState(() {
              widget.commentsList = _commentsList;
            }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => {fetchCommentsList()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Text("@" + widget.note.creatorUsername! + "'s note"),
            backgroundColor: Theme.of(context).backgroundColor,
            foregroundColor: Colors.black87,
          ),
          Material(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.ac_unit_rounded,
                        size: 32.0,
                      )),
                  title: Text(widget.note.title),
                  subtitle: Text(
                    DateFormat.jm().add_yMMMMd().format(DateTime.parse(
                        widget.note.created ?? DateTime.now().toString())),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.note.body,
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  ],
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonBarTextButton(
                      icon: Icons.arrow_upward_rounded,
                      label: numDisplay(widget.note.numberOfUpvotes),
                      pressed:
                          widget.note.requesterVoted == VotingStatus.upvoted,
                      onPressed: () => {
                        setState(() {
                          widget.note.setRequesterVoted(VotingStatus.upvoted);
                          noteDao.voteOnNote(widget.note);
                        })
                      },
                    ),
                    ButtonBarTextButton(
                      icon: Icons.arrow_downward_rounded,
                      label: numDisplay(widget.note.numberOfDownvotes),
                      pressed:
                          widget.note.requesterVoted == VotingStatus.downvoted,
                      onPressed: () => {
                        {
                          setState(() {
                            widget.note
                                .setRequesterVoted(VotingStatus.downvoted);
                            noteDao.voteOnNote(widget.note);
                          })
                        },
                      },
                    ),
                    ButtonBarTextButton(
                      icon: Icons.comment_outlined,
                      label: numDisplay(widget.note.numberOfComments),
                      onPressed: () => {},
                    ),
                    PopupMenuButton<int>(
                      icon: Icon(
                        Icons.ios_share,
                        color: Theme.of(context).primaryColor,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<int>>[
                        const PopupMenuItem<int>(value: 0, child: Text('Edit')),
                        const PopupMenuItem<int>(
                            value: 1, child: Text('Delete'))
                      ],
                      onSelected: (int value) {
                        if (value == 0) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    NoteEditor(note: widget.note)),
                          ).then((value) => widget.onNoteEdited());
                        }
                        if (value == 1) {
                          noteDao.deleteNote(widget.note).then((deleted) => {
                                if (!deleted)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Could not delete all notes'),
                                      ),
                                    ),
                                  }
                                else
                                  Navigator.pop(context)
                              });
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(16),
                          color:
                              Theme.of(context).backgroundColor.withAlpha(169),
                          child: Text(
                            "Comments",
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                fetchCommentsList();
              },
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: widget.commentsList.length,
                itemBuilder: (context, index) {
                  return NoteCommentItem(comment: widget.commentsList[index]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
