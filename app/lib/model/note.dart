class Note {
  final String? id;
  final String title;
  final String body;
  String? created = DateTime.now().toString();

  Note({this.id, required this.title, required this.body, this.created});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      title: json['title'],
      body: json['body'],
      created: json['created'],
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, body: $body, created: $created}';
  }

  Map toMap() {
    var map = new Map();
    if (id != null) {
      map["_id"] = id;
    }
    map["title"] = title;
    map["body"] = body;
    map["created"] = created ?? DateTime.now().toString();
    return map;
  }
}
