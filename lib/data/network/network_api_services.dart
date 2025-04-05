import 'dart:convert';
import 'dart:io';

import 'package:coupon_admin_panel/data/app_exception.dart';
import 'package:coupon_admin_panel/data/network/auth_interceptor.dart';
import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:coupon_admin_panel/res/app_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkApiServices extends BaseAPiServices {
  late final Dio _dio;

  // Default timeout that can be overridden
  final Duration defaultTimeout = const Duration(seconds: 15);

  NetworkApiServices() {
    _dio = Dio(BaseOptions(
      baseUrl: AppUrl.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // Web-specific configuration
      sendTimeout: kIsWeb ? null : const Duration(seconds: 30),
    ));
    // Add auth interceptor
    _dio.interceptors.add(AuthInterceptor(_dio));

    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      requestHeader: false,
      responseHeader: false,
      error: true,
      logPrint: (_) {}, // ✅ completely silenced
    ));
  }

  // Method to handle POST requests
  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data,
      {Duration? timeout}) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          sendTimeout: timeout ?? defaultTimeout,
          receiveTimeout: timeout ?? defaultTimeout,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  // Method to handle GET requests
  @override
  Future<dynamic> getGetApiResponse(String url, {Duration? timeout}) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          sendTimeout: timeout ?? defaultTimeout,
          receiveTimeout: timeout ?? defaultTimeout,
          responseType: ResponseType.json, // Ensure JSON response type
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  // Method to handle DELETE requests
  @override
  Future<dynamic> getDeleteApiResponse(String url, {Duration? timeout}) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(
          sendTimeout: timeout ?? defaultTimeout,
          receiveTimeout: timeout ?? defaultTimeout,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  // Method to handle PUT requests
  @override
  Future<dynamic> getPutApiResponse(String url, dynamic data,
      {Duration? timeout}) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        options: Options(
          sendTimeout: timeout ?? defaultTimeout,
          receiveTimeout: timeout ?? defaultTimeout,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  dynamic _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw FetchDataException("Connection Timeout");
      case DioExceptionType.badResponse:
        return _handleErrorResponse(e.response!);
      case DioExceptionType.cancel:
        throw FetchDataException("Request was cancelled");
      case DioExceptionType.connectionError:
        throw FetchDataException("No Internet Connection");
      default:
        throw FetchDataException("Unexpected error: ${e.message}");
    }
  }

  dynamic _handleErrorResponse(Response response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorizedException("Authentication failed");
      case 404:
        throw NotFoundException("Resource not found");
      case 500:
        throw FetchDataException("Server error: ${response.data}");
      default:
        throw FetchDataException(
            "Error occurred with status code ${response.statusCode}");
    }
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        // Ensure we have valid JSON data
        try {
          // If the response is already a Map, return it directly
          if (response.data is Map) {
            return response.data;
          }

          // If it's a string, try to parse it as JSON
          if (response.data is String) {
            return jsonDecode(response.data);
          }

          // For all other cases, return the data as is
          return response.data;
        } catch (e) {
          throw FetchDataException("Invalid response format");
        }
      default:
        return _handleErrorResponse(response);
    }
  }
}
