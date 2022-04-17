import 'dart:convert';

import 'package:app/model/note.dart';
import 'package:app/model/url_builder.dart';
import 'package:http/http.dart' as http;

class NoteDao {
  static const headers = {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  };

  void printRequestError(requestPath, statusCode, reasonPhrase) {
    print('Failed to complete request ' +
        requestPath.toString() +
        '\nResponse - HTTP ' +
        statusCode.toString() +
        "\t" +
        reasonPhrase.toString());
  }

  Future<List<Note>> fetchNotes(bool starredFragment) async {
    Uri requestUrl;
    if (starredFragment) {
      requestUrl = await UrlBuilder().path("note/starred").build();
    } else {
      requestUrl = await UrlBuilder().path("note").build();
    }
    final response = await http.get(requestUrl, headers: headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List responseList = jsonDecode(response.body);
      List<Note> noteObjectsList = [];
      for (var element in responseList) {
        noteObjectsList.add(Note.fromJson(element));
      }
      return noteObjectsList;
    } else {
      printRequestError('Get all Notes failed. Path: ' + requestUrl.path,
          response.statusCode, response.reasonPhrase);
      return [];
    }
  }

  Future<bool> voteOnNote(Note note) async {
    String votingStatusIntString = note.getVotingStatusInt().toString();
    // Path URL /note/:noteId/vote?vote={$voteValue}
    var requestUrl = await UrlBuilder()
        .path("note")
        .path(note.id!)
        .path("vote")
        .query("vote", votingStatusIntString)
        .build();
    final response = await http.post(requestUrl, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      printRequestError('Vote on Note failed. Path: ' + requestUrl.path,
          response.statusCode, response.reasonPhrase);
      return false;
    }
  }

  Future<bool> deleteNote(Note note) async {
    var requestUrl =
        await UrlBuilder().path("note").query('noteid', note.id!).build();
    final response = await http.delete(requestUrl, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      printRequestError('Delete Note failed. Path: ' + requestUrl.path,
          response.statusCode, response.reasonPhrase);
      return false;
    }
  }

  Future<bool> deleteAllNotes() async {
    var requestUrl = await UrlBuilder().path("note").build();
    final response = await http.delete(requestUrl, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      printRequestError('Delete Note failed. Path: ' + requestUrl.path,
          response.statusCode, response.reasonPhrase);
      return false;
    }
  }
}
