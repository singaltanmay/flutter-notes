import 'dart:io';
import 'dart:math';

import 'package:app/dao/note_dao.dart';
import 'package:app/model/constants.dart';
import 'package:app/model/db_connected_state.dart';
import 'package:app/model/note.dart';
import 'package:app/ui/note_editor.dart';
import 'package:app/ui/signin.dart';
import 'package:app/widgets/app_bottom_navigation_bar.dart';
import 'package:app/widgets/note_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllNotes extends StatefulWidget {
  final bool starredFragment;

  const AllNotes({Key? key, required this.starredFragment}) : super(key: key);

  @override
  _AllNotesState createState() => _AllNotesState();
}

void printServerCommFailedError() {
  stderr.writeln('Failed to communicate with server');
}

class _AllNotesState extends DbConnectedState<AllNotes> {
  List<Note> _notes = [];
  bool _loadNotes = true;
  NoteDao noteDao = NoteDao();

  void refreshNotesOnBuild() {
    setState(() {
      _loadNotes = true;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      String? userTokenKey = prefs.getString(Constants.userTokenKey);
      if (userTokenKey == null || userTokenKey.isEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SignIn()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadNotes) {
      noteDao.fetchNotes(widget.starredFragment).then((value) => {
            if (mounted)
              {
                setState(() {
                  _loadNotes = false;
                  _notes = value;
                })
              }
          });
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
        title: const Text("Flutter Notes"),
        actions: [
          IconButton(
              onPressed: refreshNotesOnBuild, icon: const Icon(Icons.refresh)),
          RotatedBox(
            quarterTurns: 1,
            child: PopupMenuButton<int>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(
                          value: 0, child: Text('Delete All')),
                      const PopupMenuItem<int>(
                          value: 1, child: Text('Sign Out'))
                    ],
                onSelected: (int value) {
                  if (value == 0) {
                    noteDao.deleteAllNotes().then((deleted) => {
                          if (!deleted)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not delete all notes'),
                                ),
                              ),
                            }
                          else
                            setState(() {
                              _notes.clear();
                            })
                        });
                  }
                  if (value == 1) {
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.remove(Constants.userTokenKey);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    });
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditor()),
          ).then((value) => setState(() {
                _loadNotes = true;
              }));
          // Respond to button press
        },
        icon: const Icon(Icons.add),
        label: Text('New Note'.toUpperCase()),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          refreshNotesOnBuild();
        },
        child: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            var note = _notes[index];
            var noteListTile = NoteListTile(
                note: note,
                onNoteEdited: refreshNotesOnBuild,
                onDelete: () => setState(() {
                      _notes.removeAt(index);
                    }));
            return noteListTile;
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        initialPosition: ((widget.starredFragment)
            ? Constants.appBarStarredPosition
            : Constants.appBarHomePosition),
      ),
    );
  }
}
