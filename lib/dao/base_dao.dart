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
}
