import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemId;
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Confirmation'),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
