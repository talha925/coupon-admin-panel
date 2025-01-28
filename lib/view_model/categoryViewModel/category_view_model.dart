import 'package:coupon_admin_panel/data/response/api_response.dart';
import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:coupon_admin_panel/repository/category_repository.dart';
import 'package:coupon_admin_panel/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoryViewModel with ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  ApiResponse<List<CategoryData>> _categoryResponse = ApiResponse.loading();
  ApiResponse<List<CategoryData>> get categoryResponse => _categoryResponse;

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      print("Fetching categories...");
      _categoryResponse = ApiResponse.loading();
      notifyListeners();

      // Make the API call
      final List<CategoryData> categories =
          await _categoryRepository.fetchCategories();

      // Log the fetched data
      print("Categories fetched successfully: ${categories.length}");

      // Update the state with fetched categories
      _categoryResponse = ApiResponse.completed(categories);
    } catch (error) {
      // Log the error
      print("Error fetching categories: $error");

      // Update the state with error
      _categoryResponse = ApiResponse.error(error.toString());
    }

    // Notify listeners to rebuild UI
    notifyListeners();
  }

  Future<void> createCategory(String name, BuildContext context) async {
    try {
      if (name.isEmpty) {
        Utils.flushBarErrorMessage('Category name cannot be empty', context);
        return;
      }

      await _categoryRepository.createCategory({'name': name});
      fetchCategories(); // Refresh the category list

      // Before accessing context, ensure widget is mounted
      if (context.mounted) {
        Utils.snackBar('Category added successfully', context);
      }
    } catch (e) {
      if (context.mounted) {
        Utils.flushBarErrorMessage('Failed to create category: $e', context);
      }
    }
  }

  Future<void> updateCategory(
      String id, String name, BuildContext context) async {
    try {
      await _categoryRepository.updateCategory({'_id': id, 'name': name});
      fetchCategories(); // Refresh the category list

      // Before accessing context, ensure widget is mounted
      if (context.mounted) {
        Utils.snackBar('Category updated successfully', context);
      }
    } catch (e) {
      if (context.mounted) {
        Utils.flushBarErrorMessage('Failed to update category: $e', context);
      }
    }
  }

  Future<void> deleteCategory(String id, BuildContext context) async {
    try {
      await _categoryRepository.deleteCategory(id);
      fetchCategories(); // Refresh the category list

      // Before accessing context, ensure widget is mounted
      if (context.mounted) {
        Utils.snackBar('Category deleted successfully', context);
      }
    } catch (e) {
      if (context.mounted) {
        Utils.flushBarErrorMessage('Failed to delete category: $e', context);
      }
    }
  }
}
