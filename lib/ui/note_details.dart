import 'package:app/dao/note_dao.dart';
import 'package:app/model/note.dart';
import 'package:app/widgets/button_bar_text_button.dart';
import 'package:app/widgets/note_comment_item.dart';
import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';

final numDisplay = createDisplay();

class NoteDetails extends StatefulWidget {
  Note note;

  NoteDetails({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final NoteDao noteDao = NoteDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Text(widget.note.title),
            backgroundColor: Theme.of(context).backgroundColor,
            foregroundColor: Colors.black87,
            elevation: 0,
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).canvasColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Text(widget.note.creatorUsername!),
                const SizedBox(
                  height: 32,
                ),
                Text(widget.note.body),
                const SizedBox(
                  height: 16,
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
                  ],
                ),
                const Divider(color: Colors.lightBlueAccent, height: 16,),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return const NoteCommentItem();
            },
          )
        ],
      ),
    );
  }
}
