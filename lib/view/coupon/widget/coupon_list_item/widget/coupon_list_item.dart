import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'delete_confirmation_dialog.dart';

class CouponListItem extends StatelessWidget {
  final CouponData coupon;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback onToggleActive;
  final VoidCallback onToggleFeatured;

  const CouponListItem({
    super.key,
    required this.coupon,
    required this.onDelete,
    required this.onUpdate,
    required this.onToggleActive,
    required this.onToggleFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.store, size: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store ID: ${coupon.storeId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          if (coupon.featuredForHome)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      size: 14, color: Colors.purple.shade800),
                                  const SizedBox(width: 4),
                                  Text('Featured',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.purple.shade800)),
                                ],
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: coupon.active
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              coupon.active ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 12,
                                color: coupon.active
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.offerDetails,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (coupon.hits > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Used ${coupon.hits} times',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        coupon.code,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const Text(
                        "CODE",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.code, size: 16),
                          const SizedBox(width: 4),
                          SelectableText(
                            coupon.code,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            onPressed: () {
                              // Copy code to clipboard
                            },
                            splashRadius: 20,
                            tooltip: 'Copy code',
                          ),
                        ],
                      ),
                      if (coupon.lastAccessed != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Last accessed: ${coupon.lastAccessed.toString().split('T')[0]}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Active toggle
                      Column(
                        children: [
                          const Text("Active", style: TextStyle(fontSize: 12)),
                          Switch(
                            value: coupon.active,
                            onChanged: (bool value) => onToggleActive(),
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      // Featured toggle
                      Column(
                        children: [
                          const Text("Featured",
                              style: TextStyle(fontSize: 12)),
                          Switch(
                            value: coupon.featuredForHome,
                            onChanged: (bool value) => onToggleFeatured(),
                            activeColor: Colors.purple,
                          ),
                        ],
                      ),
                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: onUpdate,
                        tooltip: 'Edit coupon',
                      ),
                      // Delete button
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
                        tooltip: 'Delete coupon',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
