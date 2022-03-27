class Note {
  final String? id;
  final String title;
  final String body;
  final bool starred;
  String? created = DateTime.now().toString();
  final String creator;

  Note({this.id, required this.title, required this.body, this.created, required this.creator, required this.starred});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['_id'],
        title: json['title'],
        body: json['body'],
        created: json['created'],
        creator: json['creator'],
        starred: json['starred']);
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
