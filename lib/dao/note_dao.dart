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
        requestPath +
        '\nResponse - HTTP ' +
        statusCode +
        "\t" +
        reasonPhrase);
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
      printRequestError('Vote on Note failed. Path: ' + requestUrl.path, response.statusCode,
          response.reasonPhrase);
      return false;
    }
  }
}
