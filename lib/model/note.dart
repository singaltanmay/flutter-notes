// {
// "_id": "625bbc62880893ddeaace5d5",
// "title": "This is a new note",
// "body": "Who cares about the body? 😅",
// "created": "2022-04-17T07:06:10.007Z",
// "starred": false,
// "creator": "62376f54a037a061978f0323",
// "creatorUsername": "mango",
// "numberOfUpvotes": 0,
// "numberOfDownvotes": 0,
// "numberOfComments": 0,
// "requesterVoted": 0
// }

enum VotingStatus { none, upvoted, downvoted }

class Note {
  final String? id;
  final String title;
  final String body;
  String? created = DateTime.now().toString();
  final bool starred;
  final String creator;
  final String? creatorUsername;
  final int numberOfUpvotes;
  final int numberOfDownvotes;
  final int numberOfComments;
  VotingStatus requesterVoted;

  Note({
    this.id,
    required this.title,
    required this.body,
    this.created,
    required this.creator,
    required this.starred,
    this.creatorUsername,
    this.numberOfUpvotes = 0,
    this.numberOfDownvotes = 0,
    this.numberOfComments = 0,
    this.requesterVoted = VotingStatus.none,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    VotingStatus requesterVoted = VotingStatus.none;
    switch (json['requesterVoted']) {
      case 1:
        {
          requesterVoted = VotingStatus.upvoted;
          break;
        }
      case -1:
        {
          requesterVoted = VotingStatus.downvoted;
          break;
        }
      default:
        {
          requesterVoted = VotingStatus.none;
          break;
        }
    }
    return Note(
        id: json['_id'],
        title: json['title'],
        body: json['body'],
        created: json['created'],
        creator: json['creator'],
        starred: json['starred'],
        creatorUsername: json['creatorUsername'],
        numberOfUpvotes: json['numberOfUpvotes'] ?? 0,
        numberOfDownvotes: json['numberOfDownvotes'] ?? 0,
        numberOfComments: json['numberOfComments'] ?? 0,
        requesterVoted: requesterVoted);
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
