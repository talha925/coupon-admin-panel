import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';

void showDeleteConfirmationDialog(BuildContext context, String categoryId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _DeleteConfirmationDialog(categoryId: categoryId);
    },
  );
}

class _DeleteConfirmationDialog extends StatefulWidget {
  final String categoryId;

  const _DeleteConfirmationDialog({required this.categoryId});

  @override
  _DeleteConfirmationDialogState createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<_DeleteConfirmationDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Category'),
      content: const Text('Are you sure you want to delete this category?'),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        _isDeleting
            ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
            : TextButton(
                onPressed: _handleDelete,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
      ],
    );
  }

  Future<void> _handleDelete() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      final categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      final success =
          await categoryViewModel.deleteCategory(widget.categoryId, context);

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }
}
