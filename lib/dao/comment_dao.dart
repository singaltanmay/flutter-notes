import 'dart:convert';

import 'package:app/dao/base_dao.dart';
import 'package:app/model/comment.dart';
import 'package:app/model/url_builder.dart';
import 'package:http/http.dart' as http;

class CommentDao extends BaseDao {
  Future<List<Comment>> getCommentsForNote(noteId) async {
    Uri requestUrl =
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

  Future<bool> postCommentToNote(Comment comment) async {
    Uri requestUrl = await UrlBuilder()
        .path("note")
        .path(comment.parentNoteId)
        .path("comment")
        .build();
    final response = await http.post(requestUrl,
        body: comment.toMap(), headers: BaseDao.headers);
    if (response.statusCode != 200) {
      printRequestError(
          'Post new comment for Note failed. Path: ' + requestUrl.path,
          response.statusCode,
          response.reasonPhrase);
      return false;
    }
    return true;
  }

  Future<bool> updateComment(Comment comment) async {
    Uri requestUrl =
        await UrlBuilder().path("comment").query("id", comment.id!).build();
    final response = await http.put(requestUrl,
        body: comment.toMap(), headers: BaseDao.headers);
    if (response.statusCode != 200) {
      printRequestError('Updating comment failed. Path: ' + requestUrl.path,
          response.statusCode, response.reasonPhrase);
      return false;
    }
    return true;
  }
}
