import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:coupon_admin_panel/data/network/network_api_services.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/res/app_url.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';
import 'package:flutter/foundation.dart';

class StoreRepository {
  final BaseAPiServices _apiServices = NetworkApiServices();

  Future<dynamic> createStore(Map<String, dynamic> data) async {
    try {
      // Clean the data before sending
      final cleanedData = _cleanStoreData(data);

      // Validate required fields before sending
      _validateRequiredFields(cleanedData);

      // Use a timeout that's longer for image-heavy requests
      final response = await _apiServices.getPostApiResponse(
        AppUrl.createStoreUrl,
        cleanedData,
        timeout:
            const Duration(seconds: 30), // Extended timeout for store creation
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

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating store: $e");
      }
      rethrow;
    }
  }

  // Helper method to clean store data before sending
  Map<String, dynamic> _cleanStoreData(Map<String, dynamic> data) {
    // Create a copy of the data to avoid modifying the original
    final Map<String, dynamic> cleanedData = Map.from(data);

    // Clean heading value if it exists
    if (cleanedData.containsKey('heading')) {
      String heading = cleanedData['heading'];

      // Ensure proper encoding for special characters
      if (heading.contains('&amp;')) {
        heading = heading.replaceAll('&amp;', '&');
      }

      // Validate against allowed headings
      bool isAllowed = false;
      for (String allowedHeading in FormUtils.ALLOWED_HEADINGS) {
        if (heading == allowedHeading) {
          isAllowed = true;
          break;
        }
      }

      // If not an exact match, try to find the closest match
      if (!isAllowed) {
        for (String allowedHeading in FormUtils.ALLOWED_HEADINGS) {
          if (allowedHeading.replaceAll(' ', '').toLowerCase() ==
              heading.replaceAll(' ', '').toLowerCase()) {
            heading = allowedHeading;
            isAllowed = true;
            break;
          }
        }
      }

      // Use a default if still not valid
      if (!isAllowed) {
        heading = FormUtils.ALLOWED_HEADINGS[0];
      }

      cleanedData['heading'] = heading;
    }

    return cleanedData;
  }

  // Helper method to validate required fields
  void _validateRequiredFields(Map<String, dynamic> data) {
    if (!data.containsKey('name') || data['name'].toString().isEmpty) {
      throw Exception("Store name is required");
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

      // Print the raw response to verify categories
      print("API Response: $response");

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
      // Clean the data before sending
      final cleanedData = _cleanStoreData(data);

      final String storeId = cleanedData['_id']; // Extract ID correctly
      if (storeId.isEmpty) {
        throw Exception("Store ID is required for updating.");
      }

      // Validate required fields before sending
      _validateRequiredFields(cleanedData);

      // Use a timeout that's longer for image-heavy requests
      final response = await _apiServices.getPutApiResponse(
        AppUrl.updateStoreUrl(storeId),
        cleanedData,
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

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating store: $e");
      }
      rethrow;
    }
  }
}
