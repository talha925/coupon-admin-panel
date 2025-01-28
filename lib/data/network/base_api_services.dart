abstract class BaseAPiServices {
  /// Handles GET requests.
  Future<dynamic> getGetApiResponse(String url);

  /// Handles POST requests.
  Future<dynamic> getPostApiResponse(String url, dynamic data);

  /// Handles PUT requests for updating data.
  Future<dynamic> getPutApiResponse(String url, dynamic data);

  /// Handles DELETE requests for deleting data.
  Future<dynamic> getDeleteApiResponse(String url);
}
