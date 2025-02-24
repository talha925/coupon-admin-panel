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
        print(
            "Sending store data: ${jsonEncode(data)}"); // ✅ Log request payload
      }
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.createStoreUrl, data);
      if (kDebugMode) {
        print("Response: $response");
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<List<Data>> fetchStores() async {
    try {
      // if (kDebugMode) {
      //   print("Fetching data from URL: ${AppUrl.getStoresUrl}");
      // }
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
      // if (kDebugMode) {
      //   print(
      //       "Deleting store with ID: $storeId from URL: ${AppUrl.deleteStoreUrl(storeId)}");
      // }
      await _apiServices.getDeleteApiResponse(AppUrl.deleteStoreUrl(storeId));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  Future<void> updateStore(Map<String, dynamic> data) async {
    try {
      final String storeId = data['_id']; // ✅ Extract ID correctly
      if (storeId.isEmpty) {
        throw Exception("Store ID is required for updating.");
      }

      final response = await _apiServices.getPutApiResponse(
        AppUrl.updateStoreUrl(storeId), // ✅ Ensure correct URL
        data,
      );

      if (response == null) {
        throw Exception("Failed to update store: No response from server.");
      }

      if (kDebugMode) {
        print("Store updated successfully: $response");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating store: $e");
      }
      rethrow;
    }
  }
}
