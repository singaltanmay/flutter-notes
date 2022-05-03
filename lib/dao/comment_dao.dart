import 'dart:convert';

import 'package:app/dao/base_dao.dart';
import 'package:app/model/comment.dart';
import 'package:app/model/url_builder.dart';
import 'package:http/http.dart' as http;

class CommentDao extends BaseDao {
  Future<List<Comment>> getCommentsForNote(noteId) async {
    Uri requestUrl;
    requestUrl =
        await UrlBuilder().path("note").path(noteId).path("comments").build();
    final response = await http.get(requestUrl, headers: BaseDao.headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List responseList = jsonDecode(response.body);
      List<Comment> commentObjectsList = [];
      for (var element in responseList) {
        commentObjectsList.add(Comment.fromJson(element));
      }
      return commentObjectsList;
    } else {
      printRequestError(
          'Get all Comments for Note failed. Path: ' + requestUrl.path,
          response.statusCode,
          response.reasonPhrase);
      return [];
    }
  }
}
