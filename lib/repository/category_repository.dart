import 'package:coupon_admin_panel/data/network/base_api_services.dart';
import 'package:coupon_admin_panel/data/network/network_api_services.dart';
import 'package:coupon_admin_panel/model/category_model.dart'; // Create a category model
import 'package:coupon_admin_panel/res/app_url.dart';
import 'package:flutter/foundation.dart';

class CategoryRepository {
  final BaseAPiServices _apiServices = NetworkApiServices();

  // Create a new category
  Future<dynamic> createCategory(Map<String, dynamic> data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.createCategoryUrl, data);
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

  // Fetch all categories
  Future<List<CategoryData>> fetchCategories() async {
    try {
      final Map<String, dynamic> response =
          await _apiServices.getGetApiResponse(AppUrl.getCategoriesUrl);

      if (response['status'] == 'success') {
        List<dynamic> categoryData = response['data'];

        List<CategoryData> categories = categoryData
            .map((categoryJson) => CategoryData.fromJson(categoryJson))
            .toList();

        return categories;
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  // Update an existing category
  Future<void> updateCategory(Map<String, dynamic> data) async {
    try {
      await _apiServices.getPutApiResponse(
          AppUrl.updateCategoryUrl(data['_id']), data);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _apiServices
          .getDeleteApiResponse(AppUrl.deleteCategoryUrl(categoryId));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }
}
