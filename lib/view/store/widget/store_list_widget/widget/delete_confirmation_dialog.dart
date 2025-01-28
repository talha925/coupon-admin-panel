import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String storeId;

  const DeleteConfirmationDialog({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Store'),
      content: const Text('Are you sure you want to delete this store?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            Provider.of<StoreViewModel>(context, listen: false)
                .deleteStore(storeId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
