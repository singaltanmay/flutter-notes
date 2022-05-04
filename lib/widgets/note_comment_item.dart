import 'package:app/dao/comment_dao.dart';
import 'package:app/model/comment.dart';
import 'package:app/model/voting-status.dart';
import 'package:app/widgets/button_bar_text_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';

final numDisplay = createDisplay();

class NoteCommentItem extends StatefulWidget {
  final Comment comment;

  const NoteCommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  State<NoteCommentItem> createState() => _NoteCommentItemState();
}

class _NoteCommentItemState extends State<NoteCommentItem> {
  final CommentDao _commentDao = CommentDao();
  final isSelected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    var themePrimaryColor = Theme.of(context).primaryColor;
    var totalVotes = widget.comment.numberOfUpvotes -
        widget.comment.numberOfDownvotes +
        widget.comment.requesterVoted;
    return Column(
      children: [
        ListTile(
          title: Text("@" + widget.comment.creatorUsername!,
              style: Theme.of(context).textTheme.bodyText1),
          subtitle: Text(
            DateFormat.jm().add_yMMMMd().format(DateTime.parse(
                widget.comment.created ?? DateTime.now().toString())),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  widget.comment.body,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleButtons(
              color: themePrimaryColor,
              borderColor: themePrimaryColor,
              selectedColor: themePrimaryColor,
              selectedBorderColor: themePrimaryColor,
              fillColor: themePrimaryColor.withOpacity(0.08),
              splashColor: themePrimaryColor.withOpacity(0.12),
              hoverColor: themePrimaryColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(4.0),
              isSelected: isSelected,
              onPressed: (index) {
                switch (index) {
                  case 0:
                    {
                      if (widget.comment.requesterVoted ==
                          VotingStatus.upvoted) {
                        setState(() {
                          widget.comment.requesterVoted = VotingStatus.none;
                          isSelected[0] = false;
                          isSelected[2] = false;
                        });
                      } else {
                        setState(() {
                          widget.comment.requesterVoted = VotingStatus.upvoted;
                          isSelected[0] = true;
                          isSelected[2] = false;
                        });
                      }
                      break;
                    }
                  case 2:
                    {
                      if (widget.comment.requesterVoted ==
                          VotingStatus.downvoted) {
                        setState(() {
                          widget.comment.requesterVoted = VotingStatus.none;
                          isSelected[0] = false;
                          isSelected[2] = false;
                        });
                      } else {
                        setState(() {
                          widget.comment.requesterVoted =
                              VotingStatus.downvoted;
                          isSelected[0] = false;
                          isSelected[2] = true;
                        });
                      }
                      break;
                    }
                  default:
                    break;
                }
              },
              children: [
                const Icon(Icons.arrow_upward_rounded),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(numDisplay(totalVotes)),
                ),
                const Icon(Icons.arrow_downward_rounded),
              ],
            ),
            ButtonBarTextButton(
              icon: Icons.comment_outlined,
              label: numDisplay(widget.comment.numberOfNestedComments),
              onPressed: () => {},
            ),
            PopupMenuButton<int>(
              icon: Icon(
                Icons.more_vert,
                color: themePrimaryColor,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                const PopupMenuItem<int>(value: 0, child: Text('Edit')),
                const PopupMenuItem<int>(value: 1, child: Text('Delete'))
              ],
              onSelected: (int value) {
                if (value == 0) {
                  // TODO
                  // Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //       pageBuilder: (_, __, ___) =>
                  //           CommentEditor(Comment: widget.comment)),
                  // ).then((value) => widget.onCommentEdited());
                }
                if (value == 1) {
                  // TODO
                  // _commentDao
                  //     .deleteComment(widget.comment)
                  //     .then((deleted) => {
                  //           if (!deleted)
                  //             {
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                 const SnackBar(
                  //                   content:
                  //                       Text('Could not delete all Comments'),
                  //                 ),
                  //               ),
                  //             }
                  //           else
                  //             widget.onDelete()
                  //         });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
