import 'dart:convert';
import 'dart:io';

import 'package:coupon_admin_panel/data/app_exception.dart';
import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkApiServices extends BaseAPiServices {
  // Method to handle POST requests
  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data) async {
    try {
      final response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Only Content-Type header
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 15));

      return returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  // Method to handle GET requests
  @override
  Future<dynamic> getGetApiResponse(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Only Content-Type header
        },
      ).timeout(const Duration(seconds: 15));

      return returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  @override
  // Method to handle DELETE requests
  Future<dynamic> getDeleteApiResponse(String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Only Content-Type header
        },
      ).timeout(const Duration(seconds: 15));

      return returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  @override

  // Method to handle PUT requests
  Future<dynamic> getPutApiResponse(String url, dynamic data) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json', // Only Content-Type header
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      return returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }

  dynamic returnResponse(http.Response response) {
    // if (kDebugMode) {
    //   print("Response Status Code: ${response.statusCode}");
    //   print("Response Body: ${response.body}");
    // }

    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw FormatException("Error decoding response: $e");
        }
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnathorisedException("Resource not found");
      case 500:
        throw FetchDataException("Server error: ${response.body}");
      default:
        throw FetchDataException(
            "Error occurred while communicating with server with status code ${response.statusCode}");
    }
  }
}
