import 'package:coupon_admin_panel/data/network/category_api_service.dart';
import 'package:coupon_admin_panel/model/category_model.dart'; // Create a category model
import 'package:flutter/foundation.dart';

class CategoryRepository {
  final CategoryApiService _apiService = CategoryApiService();

  // Create a new category
  Future<dynamic> createCategory(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.createCategory(data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating category: $e");
      }
      rethrow;
    }
  }

  // Fetch all categories
  Future<List<CategoryData>> fetchCategories() async {
    try {
      // Fetch response from the API
      final response = await _apiService.fetchCategories();

      // Check if the API response is successful
      if (response['status'] == 'success') {
        // Extract the categories list from the data object
        List<dynamic> categoryData =
            response['data']['categories']; // Access 'categories' from 'data'

        // Convert the categories data to a list of CategoryData objects
        List<CategoryData> categories = categoryData
            .map((categoryJson) =>
                CategoryData.fromJson(categoryJson)) // Parse each category
            .toList();

        // Return the list of CategoryData objects
        return categories;
      } else {
        throw Exception(
            "Failed to load categories: ${response['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching categories: $e");
      }
      rethrow; // Re-throw the exception to be caught by the caller
    }
  }

  // Update an existing category
  Future<dynamic> updateCategory(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.updateCategory(data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating category: $e");
      }
      rethrow;
    }
  }

  // Delete a category
  Future<dynamic> deleteCategory(String categoryId) async {
    try {
      final response = await _apiService.deleteCategory(categoryId);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting category: $e");
      }
      rethrow;
    }
  }
}
