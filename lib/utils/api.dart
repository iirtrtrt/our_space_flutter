class API {
  static const String host = "10.0.2.2";
  static const int port = 8000;
  static const String scheme = "http";
  static const String apiPath = "/";

  static Uri buildUri(String path) {
    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: apiPath + path,
    );
  }

  static Uri queryParametersBuildUri({
    required String path,
    required Map<String, dynamic> queryParameters,
  }) {
    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: apiPath + path,
      queryParameters: queryParameters,
    );
  }

  static Map<String, String> buildHeaders({String? accessToken}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}
