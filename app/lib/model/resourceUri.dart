class ResourceUri {
  static const String _baseUri = String.fromEnvironment('DB_BASE_URL',
      defaultValue: 'http://localhost:3000/');

  static String getBaseUriString() {
    return _baseUri;
  }

  static Uri getBaseUri() {
    return Uri.parse(_baseUri);
  }

  static Uri getAppendedUri(String append) {
    return Uri.parse(_baseUri + append);
  }
}
