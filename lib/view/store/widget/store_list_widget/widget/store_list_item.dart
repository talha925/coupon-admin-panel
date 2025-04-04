import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:flutter/material.dart';
import 'delete_confirmation_dialog.dart';
import 'update_store_dialog.dart';

class StoreListItem extends StatelessWidget {
  final Data store;

  const StoreListItem({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: (store.image.url.isNotEmpty)
            ? _buildImage(store.image.url)
            : const Icon(Icons.store),
        title: Text(store.name.isNotEmpty ? store.name : 'Unnamed Store'),
        subtitle: Text(store.trackingUrl.isNotEmpty
            ? store.trackingUrl
            : 'No Tracking URL'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => UpdateStoreDialog(store: store),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      DeleteConfirmationDialog(storeId: store.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}
