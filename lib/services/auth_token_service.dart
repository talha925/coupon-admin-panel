import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:coupon_admin_panel/res/app_url.dart';

/// Service for managing authentication tokens
class AuthTokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  final Dio _dio = Dio();

  // Singleton instance
  static final AuthTokenService _instance = AuthTokenService._internal();

  // Factory constructor
  factory AuthTokenService() => _instance;

  // Private constructor
  AuthTokenService._internal();

  /// Save authentication tokens to secure storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiryDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setInt(_tokenExpiryKey, expiryDate.millisecondsSinceEpoch);
  }

  /// Get the stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get the stored refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Check if the access token is expired
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimestamp = prefs.getInt(_tokenExpiryKey);

    if (expiryTimestamp == null) {
      return true;
    }

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    // Add a buffer of 5 minutes to account for clock differences
    return DateTime.now()
        .isAfter(expiryDate.subtract(const Duration(minutes: 5)));
  }

  /// Clear all stored tokens (logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenExpiryKey);
  }

  /// Refresh the access token using the refresh token
  Future<bool> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();

      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        AppUrl.refreshTokenUrl,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data['accessToken'] != null &&
            data['refreshToken'] != null &&
            data['expiresIn'] != null) {
          final accessToken = data['accessToken'];
          final newRefreshToken = data['refreshToken'];
          final expiresIn = data['expiresIn']; // seconds

          final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));

          await saveTokens(
            accessToken: accessToken,
            refreshToken: newRefreshToken,
            expiryDate: expiryDate,
          );

          return true;
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing token: $e');
      }
      return false;
    }
  }

  /// Get a valid access token, refreshing if necessary
  Future<String?> getValidAccessToken() async {
    final isExpired = await isTokenExpired();

    if (isExpired) {
      final refreshed = await refreshTokens();
      if (!refreshed) {
        return null;
      }
    }

    return getAccessToken();
  }
}
