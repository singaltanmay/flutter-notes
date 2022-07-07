// "_id": commentObj._id.toString(),
// "body": commentObj.body,
// "created": commentObj.created,
// "creator": commentObj.creator.toString(),
// "creatorUsername": creatorObj.username,
// "numberOfUpvotes": commentObj.upvoters.length,
// "numberOfDownvotes": commentObj.downvoters.length,
// "requesterVoted": requesterVoted,
// "parentNote": commentObj.parentNote.toString(),
// "parentComment": commentObj.parentComment.toString(),
// "numberOfNestedComments": commentObj.comments.length

import 'package:app/model/voting-status.dart';

class Comment {
  final String? id;
  String body;
  String? created = DateTime.now().toString();
  final String? creator;
  final String? creatorUsername;
  int numberOfUpvotes = 0;
  int numberOfDownvotes = 0;
  int requesterVoted = VotingStatus.none;
  final String parentNoteId;
  final String? parentCommentId;
  int numberOfNestedComments = 0;

  Comment({
    this.id,
    required this.body,
    this.creator,
    this.creatorUsername,
    created,
    numberOfUpvotes,
    numberOfDownvotes,
    numberOfNestedComments,
    required int requesterVoted,
    required this.parentNoteId,
    required this.parentCommentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['_id'],
        body: json['body'],
        created: json['created'],
        creator: json['creator'],
        creatorUsername: json['creatorUsername'],
        numberOfUpvotes: json['numberOfUpvotes'] ?? 0,
        numberOfDownvotes: json['numberOfDownvotes'] ?? 0,
        numberOfNestedComments: json['numberOfNestedComments'] ?? 0,
        requesterVoted: json['requesterVoted'],
        parentNoteId: json['parentNote'],
        parentCommentId: json['parentCommentId']);
  }

  Map toMap() {
    Map<String, dynamic> map = {};
    map["body"] = body;
    map["created"] = created ?? DateTime.now().toString();
    map["parentNote"] = parentNoteId;
    if (parentCommentId != null && parentCommentId!.isNotEmpty) {
      map["parentComment"] = parentCommentId;
    }
    return map;
  }
}
