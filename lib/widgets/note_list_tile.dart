import 'dart:io';

import 'package:app/dao/note_dao.dart';
import 'package:app/model/note.dart';
import 'package:app/ui/note_details.dart';
import 'package:app/ui/note_editor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';

import 'button_bar_text_button.dart';

final numDisplay = createDisplay();

class NoteListTile extends StatefulWidget {
  final Note note;
  final Function onDelete;
  final Function onNoteEdited;

  NoteListTile(
      {Key? key,
      required this.note,
      required this.onDelete,
      required this.onNoteEdited})
      : super(key: key);

  @override
  _NoteListTileState createState() => _NoteListTileState();

  void printServerCommFailedError() {
    stderr.writeln('Failed to communicate with server');
  }
}

class _NoteListTileState extends State<NoteListTile> {
  final NoteDao noteDao = NoteDao();

  @override
  Widget build(BuildContext context) {
    String title = widget.note.title;
    String body = widget.note.body;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => {
            Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => NoteDetails(note: widget.note)),
            )
          },
          child: Column(
            children: [
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.ac_unit_rounded,
                      size: 32.0,
                    )),
                title: Text(title),
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
                        widget.note.creatorUsername != null
                            ? body + " -- @" + widget.note.creatorUsername!
                            : body,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
                    pressed: widget.note.requesterVoted == VotingStatus.upvoted,
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
                          widget.note.setRequesterVoted(VotingStatus.downvoted);
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
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(value: 0, child: Text('Edit')),
                      const PopupMenuItem<int>(value: 1, child: Text('Delete'))
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
                                widget.onDelete()
                            });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
