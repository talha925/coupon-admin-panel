import 'package:coupon_admin_panel/data/response/api_response.dart';
import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:coupon_admin_panel/repository/category_repository.dart';
import 'package:coupon_admin_panel/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryViewModel with ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  ApiResponse<List<CategoryData>> _categoryResponse = ApiResponse.loading();
  ApiResponse<List<CategoryData>> get categoryResponse => _categoryResponse;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      if (kDebugMode) {
        print("Fetching categories...");
      }
      _categoryResponse = ApiResponse.loading();
      notifyListeners();

      // Make the API call
      final List<CategoryData> categories =
          await _categoryRepository.fetchCategories();

      // Log the fetched data
      if (kDebugMode) {
        print("Categories fetched successfully: ${categories.length}");
      }

      // Update the state with fetched categories
      _categoryResponse = ApiResponse.completed(categories);
    } catch (error) {
      // Log the error
      if (kDebugMode) {
        print("Error fetching categories: $error");
      }

      // Update the state with error
      _categoryResponse = ApiResponse.error(error.toString());
    }

    // Notify listeners to rebuild UI
    notifyListeners();
  }

  Future<bool> createCategory(String name, BuildContext context) async {
    if (name.isEmpty) {
      Utils.flushBarErrorMessage('Category name cannot be empty', context);
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      if (kDebugMode) {
        print("Creating category with name: $name");
      }

      final response = await _categoryRepository.createCategory({'name': name});

      if (kDebugMode) {
        print("Category creation response: $response");
      }

      await fetchCategories(); // Refresh the category list

      // Check response status
      if (response != null && response['status'] == 'success') {
        // Before accessing context, ensure widget is mounted
        if (context.mounted) {
          Utils.snackBar('Category added successfully', context);
        }
        return true;
      } else {
        final errorMessage = response != null && response.containsKey('message')
            ? response['message']
            : 'Failed to create category';

        if (context.mounted) {
          Utils.flushBarErrorMessage(errorMessage, context);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating category: $e");
      }

      if (context.mounted) {
        Utils.flushBarErrorMessage('Failed to create category: $e', context);
      }
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateCategory(
      String id, String name, BuildContext context) async {
    if (name.isEmpty) {
      Utils.flushBarErrorMessage('Category name cannot be empty', context);
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final response =
          await _categoryRepository.updateCategory({'_id': id, 'name': name});

      await fetchCategories(); // Refresh the category list

      // Check response status
      if (response != null && response['status'] == 'success') {
        // Before accessing context, ensure widget is mounted
        if (context.mounted) {
          Utils.snackBar('Category updated successfully', context);
        }
        return true;
      } else {
        final errorMessage = response != null && response.containsKey('message')
            ? response['message']
            : 'Failed to update category';

        if (context.mounted) {
          Utils.flushBarErrorMessage(errorMessage, context);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating category: $e");
      }

      if (context.mounted) {
        Utils.flushBarErrorMessage('Failed to update category: $e', context);
      }
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCategory(String id, BuildContext context) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final response = await _categoryRepository.deleteCategory(id);

      await fetchCategories(); // Refresh the category list

      // Check response status
      if (response != null && response['status'] == 'success') {
        // Before accessing context, ensure widget is mounted
        if (context.mounted) {
          Utils.snackBar('Category deleted successfully', context);
        }
        return true;
      } else {
        final errorMessage = response != null && response.containsKey('message')
            ? response['message']
            : 'Failed to delete category';

        if (context.mounted) {
          Utils.flushBarErrorMessage(errorMessage, context);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting category: $e");
      }

      if (context.mounted) {
        Utils.flushBarErrorMessage('Failed to delete category: $e', context);
      }
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
