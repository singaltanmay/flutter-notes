import 'package:app/model/resource_uri.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class UrlBuilder {

  var currentQueryChar = "?";
  Map<String, dynamic> currentQuery = {};
  var currentAppend = "";


  UrlBuilder append(String append) {
    currentAppend = currentAppend + append + "/";
    return this;
  }

  UrlBuilder query(String query, String value) {
    currentQuery[query] = value;
    return this;
  }

  Future<Uri> build({bool withToken = true}) async {
    if (withToken) {
      var prefs = await SharedPreferences.getInstance();
      currentQuery["token"] = prefs.getString(Constants.userTokenKey)!;
    }

    return Uri(
        scheme: 'http',
        host: await ResourceUri.getBase(),
        path: currentAppend,
        queryParameters: currentQuery);
  }

}