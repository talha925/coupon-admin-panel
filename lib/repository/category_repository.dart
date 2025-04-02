import 'package:coupon_admin_panel/data/network/category_api_service.dart';
import 'package:coupon_admin_panel/model/category_model.dart'; // Create a category model
import 'package:flutter/foundation.dart';

class CategoryRepository {
  final CategoryApiService _apiService = CategoryApiService();

  // Create a new category
  Future<dynamic> createCategory(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print("Repository creating category with data: $data");
      }

      final response = await _apiService.createCategory(data);

      if (kDebugMode) {
        print("Category creation response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Repository error creating category: $e");
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
        print("Repository error fetching categories: $e");
      }
      rethrow; // Re-throw the exception to be caught by the caller
    }
  }

  // Update an existing category
  Future<dynamic> updateCategory(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print("Repository updating category with data: $data");
      }

      final response = await _apiService.updateCategory(data);

      if (kDebugMode) {
        print("Category update response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Repository error updating category: $e");
      }
      rethrow;
    }
  }

  // Delete a category
  Future<dynamic> deleteCategory(String categoryId) async {
    try {
      if (kDebugMode) {
        print("Repository deleting category: $categoryId");
      }

      final response = await _apiService.deleteCategory(categoryId);

      if (kDebugMode) {
        print("Category deletion response: $response");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Repository error deleting category: $e");
      }
      rethrow;
    }
  }
}
