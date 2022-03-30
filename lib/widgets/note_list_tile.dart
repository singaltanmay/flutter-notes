import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app/model/note.dart';
import 'package:app/model/resource_uri.dart';
import 'package:app/ui/note_editor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/constants.dart';
import '../model/url_builder.dart';

enum _VotingStatus { upvoted, downvoted, none }

final numDisplay = createDisplay();

class NoteListTile extends StatefulWidget {
  final Note note;
  final Function onDelete;
  final Function onNoteEdited;
  String? noteCreatorUsername;
  _VotingStatus votingStatus = _VotingStatus.none;

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

  Future<bool> delete() async {
    try {
      var appendedUri = await UrlBuilder().append("note").build();
      final response = await http.delete(appendedUri, headers: {
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
  Future<String?> getNoteCreatorUsername(String creatorId) async {
    var appendedUri = await ResourceUri.getAppendedUri("user/" + creatorId);
    final response = await http.get(appendedUri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final Map responseBody = jsonDecode(response.body);
      return responseBody["username"];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.note.title;
    String body = widget.note.body;

    if (widget.noteCreatorUsername == null) {
      getNoteCreatorUsername(widget.note.creator).then((value) => {
            if (mounted)
              {
                setState(() {
                  widget.noteCreatorUsername = value;
                })
              }
          });
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => {
            Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => NoteEditor(note: widget.note)),
            ).then((value) => widget.onNoteEdited())
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
                        widget.noteCreatorUsername != null
                            ? body + " -- @" + widget.noteCreatorUsername!
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
                  _ButtonBarTextButton(
                    icon: Icons.arrow_upward_rounded,
                    label: numDisplay(Random().nextInt(10000)),
                    pressed: widget.votingStatus == _VotingStatus.upvoted,
                    onPressed: () => {
                      widget.votingStatus =
                          widget.votingStatus == _VotingStatus.upvoted
                              ? _VotingStatus.none
                              : _VotingStatus.upvoted
                    },
                  ),
                  _ButtonBarTextButton(
                    icon: Icons.arrow_downward_rounded,
                    label: numDisplay(Random().nextInt(1000)),
                    pressed: widget.votingStatus == _VotingStatus.downvoted,
                    onPressed: () => {
                      {
                        widget.votingStatus =
                            widget.votingStatus == _VotingStatus.downvoted
                                ? _VotingStatus.none
                                : _VotingStatus.downvoted
                      },
                    },
                  ),
                  _ButtonBarTextButton(
                    icon: Icons.comment_outlined,
                    label: numDisplay(Random().nextInt(100)),
                    onPressed: () => {},
                  ),
                  PopupMenuButton<int>(
                      icon: Icon(
                        Icons.ios_share,
                        color: Theme.of(context).primaryColor,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<int>>[
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Star')),
                            const PopupMenuItem<int>(
                                value: 1, child: Text('Delete'))
                          ],
                      onSelected: (int value) {
                        if (value == 0) {
                          // TODO star the note
                        }
                        if (value == 1) {
                          widget.delete().then((deleted) => {
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
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleOnPressed() {
    updateNote();
  }

  void updateNote() async {
    String currentUser = await getCurrentUserToken();
    var note = Note(
        id: widget.note.id,
        title: widget.note.title,
        body: widget.note.body,
        creator: currentUser,
        starred: !widget.note.starred);

    var baseUri = await UrlBuilder().append("note").build();
    final response = await http.put(baseUri, body: note.toMap());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      widget.onNoteEdited();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to PUT Note $note. Response code = ${response.statusCode}\n');
    }
  }

  Future<String> getCurrentUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString(Constants.userTokenKey);
    if (currentUser == null) {
      throw Exception('User Token not found in Shared Preferences!');
    }
    return currentUser;
  }
}

class _ButtonBarTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool pressed;

  const _ButtonBarTextButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.pressed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        icon,
        color: pressed ? Theme.of(context).primaryColorDark : null,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: pressed ? Theme.of(context).primaryColorDark : null,
          fontWeight: pressed ? FontWeight.bold : null,
        ),
      ),
      onPressed: onPressed ?? () => {},
      style: ButtonStyle(
        backgroundColor: pressed
            ? MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColorLight)
            : null,
        elevation: pressed ? MaterialStateProperty.all(2) : null,
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
