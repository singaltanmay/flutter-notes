import 'package:app/model/resource_uri.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class UrlBuilder {
  final Map<String, String> _queryMap = {};
  var _currentAppend = "";

  UrlBuilder path(String append) {
    if (_currentAppend.isNotEmpty && !_currentAppend.endsWith("/")) {
      _currentAppend += "/";
    }
    _currentAppend += append;
    return this;
  }

  UrlBuilder query(String key, String value) {
    _queryMap[key] = value;
    return this;
  }

  Future<Uri> build({bool withToken = true}) async {
    if (withToken) {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(Constants.userTokenKey);
      if (token != null) {
        query("token", token);
      }
    }
    var baseUrl = await ResourceUri.getBase();
    var s = baseUrl + _currentAppend;
    if (_queryMap.isNotEmpty) {
      s += "?";
      bool first = true;
      _queryMap.forEach((key, value) {
        if (!first) {
          s += "&";
        }
        s += key + "=" + value;
        first = false;
      });
    }
    return Uri.parse(s);
  }
}
