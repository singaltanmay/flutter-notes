import 'package:app/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseDao {
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

  static Future<String> getCurrentUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString(Constants.userTokenKey);
    if (currentUser == null) {
      throw Exception('User Token not found in Shared Preferences!');
    }
    return currentUser;
  }
}
