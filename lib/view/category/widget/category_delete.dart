import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';

void showDeleteConfirmationDialog(BuildContext context, String categoryId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Perform delete operation
              Provider.of<CategoryViewModel>(context, listen: false)
                  .deleteCategory(categoryId, context);

              Navigator.of(context).pop(); // Close dialog after deletion
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
