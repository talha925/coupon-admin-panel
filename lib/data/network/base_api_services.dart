abstract class BaseAPiServices {
  /// Handles GET requests.
  /// [timeout] allows specifying a custom timeout for this specific request.
  Future<dynamic> getGetApiResponse(String url, {Duration? timeout});

  /// Handles POST requests.
  /// [timeout] allows specifying a custom timeout for this specific request.
  Future<dynamic> getPostApiResponse(String url, dynamic data,
      {Duration? timeout});

  /// Handles PUT requests for updating data.
  /// [timeout] allows specifying a custom timeout for this specific request.
  Future<dynamic> getPutApiResponse(String url, dynamic data,
      {Duration? timeout});

  /// Handles DELETE requests for deleting data.
  /// [timeout] allows specifying a custom timeout for this specific request.
  Future<dynamic> getDeleteApiResponse(String url, {Duration? timeout});
}
