import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'delete_confirmation_dialog.dart';

class CouponListItem extends StatelessWidget {
  final Datum coupon;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const CouponListItem({
    super.key,
    required this.coupon,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (coupon.store.image.isNotEmpty)
                  Image.network(
                    coupon.store.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.store, size: 50);
                    },
                  )
                else
                  const Icon(Icons.store, size: 50),
                const SizedBox(width: 10),
                Text(
                  coupon.store.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Description: ${coupon.description}",
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              "Coupon Code: ${coupon.code}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Discount: ${coupon.discount}%",
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              "Expires on: ${coupon.expirationDate.toLocal()}",
              style: const TextStyle(color: Colors.red),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: onUpdate,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteConfirmationDialog(
                          itemId: coupon.id,
                          onDelete: onDelete,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
