class Note {
  final String id;
  final String title;
  final String body;
  final String created;

  const Note(
      {required this.id,
      required this.title,
      required this.body,
      required this.created});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      created: json['created'],
    );
  }

  @override
  String toString() {
    return 'Note{title: $title, body: $body, created: $created}';
  }
}
