import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart'; // For utility functions

void showCategoryDialog(BuildContext context, CategoryData? category) {
  final TextEditingController _categoryController = TextEditingController();

  if (category != null) {
    _categoryController.text = category.name;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Update Category'),
        content: TextField(
          controller: _categoryController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_categoryController.text.isNotEmpty) {
                final categoryViewModel =
                    Provider.of<CategoryViewModel>(context, listen: false);

                if (category == null) {
                  categoryViewModel.createCategory(
                      _categoryController.text, context);
                } else {
                  categoryViewModel.updateCategory(
                      category.id, _categoryController.text, context);
                }
                Navigator.of(context).pop(); // Close dialog
              } else {
                Utils.flushBarErrorMessage('Name cannot be empty', context);
              }
            },
            child: Text(category == null ? 'Add' : 'Update'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
