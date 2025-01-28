import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';
import 'package:coupon_admin_panel/data/response/status.dart';

import 'category_delete.dart';
import 'category_dialog.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryViewModel>(
      builder: (context, viewModel, child) {
        final response = viewModel.categoryResponse;

        if (response.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (response.status == Status.error) {
          return Center(child: Text('Error: ${response.message}'));
        }

        final categories = response.data ?? [];

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              child: ListTile(
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showCategoryDialog(context, category); // Now it works
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDeleteConfirmationDialog(context,
                            category.id); // Show delete confirmation dialog
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
