import 'package:app/model/comment.dart';

class Note {
  final String? id;
  final String title;
  final String body;
  final bool starred;
  String? created = DateTime.now().toString();
  final String creator;
  List<String>? upvoters;
  List<String>? downvoters;
  List<Comment>? comments;

  Note(
      {this.id,
      required this.title,
      required this.body,
      this.created,
      required this.creator,
      required this.starred,
      this.upvoters,
      this.downvoters,
      this.comments});

  factory Note.fromJson(Map<String, dynamic> json) {
    List<String> upvotersList = [];
    List<String> downvotersList = [];

    json['upvoters'].forEach((item) {
      upvotersList.add(item as String);
    });

    json['downvoters'].forEach((item) {
      downvotersList.add(item as String);
    });

    List<Comment> commentsList = [];

    json['comments'].forEach((item) {
      commentsList.add(Comment.fromJson(item));
    });

    return Note(
        id: json['_id'],
        title: json['title'],
        body: json['body'],
        created: json['created'],
        creator: json['creator'],
        starred: json['starred'],
        upvoters: upvotersList,
        downvoters: downvotersList,
        comments: commentsList);
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, body: $body, created: $created, creator: $creator, starred: $starred}';
  }

  Map toMap() {
    Map<String, dynamic> map = {};
    if (id != null) {
      map["_id"] = id;
    }
    map["title"] = title;
    map["body"] = body;
    map["created"] = created ?? DateTime.now().toString();
    map["creator"] = creator;
    map["starred"] = starred.toString();
    return map;
  }
}
