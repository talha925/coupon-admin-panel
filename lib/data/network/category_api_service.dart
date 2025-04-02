import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:coupon_admin_panel/res/app_url.dart';
import 'package:coupon_admin_panel/data/app_exception.dart';

class CategoryApiService {
  final Dio _dio = Dio();

  CategoryApiService() {
    // Configure base options
    _dio.options = BaseOptions(
      baseUrl: AppUrl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) {
        return status! < 500; // Accept all non-server error status codes
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add special handling for web platform
    if (kIsWeb) {
      // Using a transform interceptor to properly format requests for web
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // Print request details in debug mode
          if (kDebugMode) {
            print("🚀 Request: ${options.method} ${options.path}");
            print("Headers: ${options.headers}");
            print("Data: ${options.data}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Print response in debug mode
          if (kDebugMode) {
            print(
                "✅ Response [${response.statusCode}]: ${response.requestOptions.path}");
            print("Response data: ${response.data}");
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          // Print error in debug mode
          if (kDebugMode) {
            print(
                "❌ Error [${error.response?.statusCode}]: ${error.requestOptions.path}");
            print("Error message: ${error.message}");
            print("Error response: ${error.response?.data}");
          }
          return handler.next(error);
        },
      ));
    }

    // Add logging interceptor for debugging (only in debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: true,
      ));
    }
  }

  // Fetch all categories
  Future<dynamic> fetchCategories() async {
    try {
      final response = await _dio.get(AppUrl.getCategoriesUrl);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  // Create a category
  Future<dynamic> createCategory(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print("Creating category with data: $data");
      }

      // For web platform, ensure proper content type
      final options = Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
        },
      );

      // Don't encode the data - let Dio handle it
      final response = await _dio.post(
        AppUrl.createCategoryUrl,
        data: data,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      throw FetchDataException("Unexpected error during category creation: $e");
    }
  }

  // Update a category
  Future<dynamic> updateCategory(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print("Updating category with data: $data");
      }

      final String categoryId = data['_id'];
      if (categoryId.isEmpty) {
        throw BadRequestException("Category ID is required for updating");
      }

      // For web platform, ensure proper content type
      final options = Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
        },
      );

      // Don't encode the data - let Dio handle it
      final response = await _dio.put(
        AppUrl.updateCategoryUrl(categoryId),
        data: data,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      throw FetchDataException("Unexpected error during category update: $e");
    }
  }

  // Delete a category
  Future<dynamic> deleteCategory(String categoryId) async {
    try {
      if (categoryId.isEmpty) {
        throw BadRequestException("Category ID is required for deletion");
      }

      // For web platform, ensure proper content type
      final options = Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
        },
      );

      final response = await _dio.delete(
        AppUrl.deleteCategoryUrl(categoryId),
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      throw FetchDataException("Unexpected error during category deletion: $e");
    }
  }

  // Handle Dio errors
  dynamic _handleDioError(DioException e) {
    if (kDebugMode) {
      print("DioError: ${e.message}");
      print("DioError Type: ${e.type}");
      if (e.response != null) {
        print("DioError Response: ${e.response?.data}");
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException("Connection timeout");
      case DioExceptionType.badResponse:
        return _handleErrorResponse(e.response!);
      case DioExceptionType.cancel:
        throw FetchDataException("Request was cancelled");
      case DioExceptionType.connectionError:
        throw FetchDataException("Connection error: ${e.message}");
      default:
        throw FetchDataException("Network error: ${e.message}");
    }
  }

  // Handle error responses
  dynamic _handleErrorResponse(Response response) {
    if (kDebugMode) {
      print("Error Response Status: ${response.statusCode}");
      print("Error Response Data: ${response.data}");
    }

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
            "Error with status code ${response.statusCode}");
    }
  }

  // Handle successful responses
  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      return _handleErrorResponse(response);
    }
  }
}
