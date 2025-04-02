import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/category_model.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart'; // For utility functions

void showCategoryDialog(BuildContext context, CategoryData? category) {
  final TextEditingController categoryController = TextEditingController();

  if (category != null) {
    categoryController.text = category.name;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _CategoryDialogContent(
        categoryController: categoryController,
        category: category,
      );
    },
  );
}

class _CategoryDialogContent extends StatefulWidget {
  final TextEditingController categoryController;
  final CategoryData? category;

  const _CategoryDialogContent({
    required this.categoryController,
    this.category,
  });

  @override
  _CategoryDialogContentState createState() => _CategoryDialogContentState();
}

class _CategoryDialogContentState extends State<_CategoryDialogContent> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Add Category' : 'Update Category'),
      content: TextField(
        controller: widget.categoryController,
        decoration: const InputDecoration(labelText: 'Category Name'),
        enabled: !_isSubmitting,
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        _isSubmitting
            ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
            : TextButton(
                onPressed: _handleSubmit,
                child: Text(widget.category == null ? 'Add' : 'Update'),
              ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (widget.categoryController.text.isEmpty) {
      Utils.flushBarErrorMessage('Name cannot be empty', context);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);
    bool success = false;

    try {
      if (widget.category == null) {
        // Create category
        success = await categoryViewModel.createCategory(
            widget.categoryController.text, context);
      } else {
        // Update category
        success = await categoryViewModel.updateCategory(
            widget.category!.id, widget.categoryController.text, context);
      }

      if (success && mounted) {
        Navigator.of(context).pop(); // Close dialog on success
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
