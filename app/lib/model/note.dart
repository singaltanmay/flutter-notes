class Note {

  const String _title;
  const String _body;
  const String _date;

  Note(this._title, this._body, this._date);

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get body => _body;

  set body(String value) {
    _body = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}