import 'dart:convert';

import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:coupon_admin_panel/data/network/network_api_services.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/res/app_url.dart';
import 'package:flutter/foundation.dart';

class StoreRepository {
  final BaseAPiServices _apiServices = NetworkApiServices();

  Future<dynamic> createStore(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print("Sending data: $data to URL: ${AppUrl.createStoreUrl}");
        print("Sending store data: ${jsonEncode(data)}");
      }

      // Validate required fields before sending
      _validateRequiredFields(data);

      // Use a timeout that's longer for image-heavy requests
      final response = await _apiServices.getPostApiResponse(
        AppUrl.createStoreUrl,
        data,
        timeout:
            const Duration(seconds: 30), // Extended timeout for store creation
      );

      if (kDebugMode) {
        print("Response: $response");
      }

      // Validate the response
      if (response == null) {
        throw Exception("No response received from server");
      }

      if (!response.containsKey('status') || response['status'] != 'success') {
        final message = response.containsKey('message')
            ? response['message']
            : 'Server returned unsuccessful status';
        throw Exception(message);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating store: $e");
      }
      rethrow;
    }
  }

  // Helper method to validate required fields
  void _validateRequiredFields(Map<String, dynamic> data) {
    if (!data.containsKey('name') || data['name'].toString().isEmpty) {
      throw Exception("Store name is required");
    }

    if (!data.containsKey('directUrl') ||
        data['directUrl'].toString().isEmpty) {
      throw Exception("Direct URL is required");
    }

    if (!data.containsKey('short_description') ||
        data['short_description'].toString().isEmpty) {
      throw Exception("Short description is required");
    }

    // Check image data
    if (!data.containsKey('image') ||
        !data['image'].containsKey('url') ||
        data['image']['url'].toString().isEmpty) {
      throw Exception("Store image is required");
    }
  }

  Future<List<Data>> fetchStores() async {
    try {
      final Map<String, dynamic> response =
          await _apiServices.getGetApiResponse(AppUrl.getStoresUrl);

      if (response['status'] == 'success') {
        List<dynamic> storeData = response['data'];

        List<Data> stores =
            storeData.map((storeJson) => Data.fromJson(storeJson)).toList();

        stores.sort((a, b) => b.id.compareTo(a.id)); // Sort by ID

        return stores;
      } else {
        throw Exception("Failed to load stores");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<void> deleteStore(String storeId) async {
    try {
      await _apiServices.getDeleteApiResponse(AppUrl.deleteStoreUrl(storeId));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<dynamic> updateStore(Map<String, dynamic> data) async {
    try {
      final String storeId = data['_id']; // Extract ID correctly
      if (storeId.isEmpty) {
        throw Exception("Store ID is required for updating.");
      }

      // Validate required fields before sending
      _validateRequiredFields(data);

      // Use a timeout that's longer for image-heavy requests
      final response = await _apiServices.getPutApiResponse(
        AppUrl.updateStoreUrl(storeId),
        data,
        timeout:
            const Duration(seconds: 30), // Extended timeout for store update
      );

      // Validate the response
      if (response == null) {
        throw Exception("No response received from server");
      }

      if (!response.containsKey('status') || response['status'] != 'success') {
        final message = response.containsKey('message')
            ? response['message']
            : 'Server returned unsuccessful status';
        throw Exception(message);
      }

      if (kDebugMode) {
        print("Store updated successfully: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating store: $e");
      }
      rethrow;
    }
  }
}
