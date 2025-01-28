// lib/data/response/api_response.dart

import 'package:coupon_admin_panel/data/response/status.dart';

class ApiResponse<T> {
  Status status;
  T? data;
  String? message;

  ApiResponse._(this.status, [this.data, this.message]);

  factory ApiResponse.loading() {
    return ApiResponse._(
      Status.loading,
    );
  }

  factory ApiResponse.completed(T data) {
    return ApiResponse._(Status.completed, data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse._(Status.error, null, message);
  }
}
