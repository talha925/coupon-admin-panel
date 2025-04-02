import 'package:dio/dio.dart';
import 'package:coupon_admin_panel/services/auth_token_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// An interceptor that adds auth tokens to requests and handles token refresh
class AuthInterceptor extends Interceptor {
  final AuthTokenService _authTokenService = AuthTokenService();
  final Dio _dio;

  // Flag to prevent infinite refresh loops
  bool _isRefreshing = false;

  // Queue of requests that are waiting for token refresh
  final List<_RequestQueueItem> _pendingRequests = [];

  AuthInterceptor(this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip token for authentication endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get a valid token
    try {
      final token = await _authTokenService.getValidAccessToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    } catch (e) {
      if (kDebugMode) {
        print('Error in auth interceptor: $e');
      }
      return handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_isAuthEndpoint(err.requestOptions.path) || _isRefreshing) {
        // If we're already refreshing or if the error is from an auth endpoint,
        // we don't want to retry
        return handler.next(err);
      }

      // Queue this request to retry after token refresh
      final completer = _enqueueRequest(err.requestOptions);

      // Only refresh token once for multiple concurrent requests
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshed = await _authTokenService.refreshTokens();
          if (refreshed) {
            // Process queued requests with new token
            _processQueue();
          } else {
            // Refresh failed, reject all requests
            _rejectQueue(err);
          }
        } finally {
          _isRefreshing = false;
        }
      }

      // Wait for the request to be retried
      try {
        final response = await completer;
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    // For other errors, just pass them through
    return handler.next(err);
  }

  // Add a request to the queue and return a completer to wait on
  Future<Response> _enqueueRequest(RequestOptions requestOptions) {
    final completer = Completer<Response>();
    _pendingRequests.add(_RequestQueueItem(requestOptions, completer));
    return completer.future;
  }

  // Process all queued requests with a new token
  Future<void> _processQueue() async {
    final token = await _authTokenService.getAccessToken();

    if (token != null) {
      // Copy the queue and clear it
      final requests = List<_RequestQueueItem>.from(_pendingRequests);
      _pendingRequests.clear();

      // Process each request
      for (final request in requests) {
        try {
          // Clone the original request with the new token
          final options = Options(
            method: request.options.method,
            headers: {
              ...request.options.headers,
              'Authorization': 'Bearer $token',
            },
          );

          // Execute the request
          final response = await _dio.request(
            request.options.path,
            data: request.options.data,
            queryParameters: request.options.queryParameters,
            options: options,
          );

          // Complete the original request with the new response
          request.completer.complete(response);
        } catch (e) {
          request.completer.completeError(e);
        }
      }
    }
  }

  // Reject all queued requests with the given error
  void _rejectQueue(DioException error) {
    // Copy the queue and clear it
    final requests = List<_RequestQueueItem>.from(_pendingRequests);
    _pendingRequests.clear();

    // Reject each request
    for (final request in requests) {
      request.completer.completeError(error);
    }
  }

  // Check if a path is an authentication endpoint
  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }
}

/// Class to hold a request in the queue
class _RequestQueueItem {
  final RequestOptions options;
  final Completer<Response> completer;

  _RequestQueueItem(this.options, this.completer);
}
