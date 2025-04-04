import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:provider/provider.dart';
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
    final theme = Theme.of(context);
    final storeVM = Provider.of<StoreViewModel>(context, listen: false);
    final store = storeVM.stores.firstWhere(
      (s) => s.id == coupon.storeId,
      orElse: () => Data(
        id: '',
        name: 'Unknown Store',
        trackingUrl: 'N/A',
        shortDescription: '',
        longDescription: '',
        image: StoreImage(url: '', alt: ''),
        categories: [],
        seo: Seo(metaTitle: '', metaDescription: '', metaKeywords: ''),
        language: '',
        isTopStore: false,
        isEditorsChoice: false,
        heading: '',
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Store Info and Action Buttons
            Row(
              children: [
                // Store Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.store, size: 24, color: theme.primaryColor),
                ),
                const SizedBox(width: 12),

                // Store Name and URL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        store.trackingUrl,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Featured Toggle
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: coupon.featuredForHome
                            ? Colors.purple
                            : Colors.grey,
                        size: 20,
                      ),
                      onPressed: onToggleFeatured,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: coupon.featuredForHome
                          ? 'Remove from featured'
                          : 'Mark as featured',
                    ),

                    // Edit Button
                    IconButton(
                      icon:
                          const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: onUpdate,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Edit coupon',
                    ),

                    // Delete Button
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteConfirmationDialog(
                            itemId: coupon.id,
                            onDelete: onDelete,
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Delete coupon',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Coupon Details
            Row(
              children: [
                Expanded(
                  child: Text(
                    coupon.offerDetails,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),

                // Coupon Code
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    coupon.code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Footer with Usage Info
            if (coupon.hits > 0 || coupon.lastAccessed != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    if (coupon.hits > 0)
                      Row(
                        children: [
                          Icon(Icons.people_alt_outlined,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${coupon.hits} uses',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    if (coupon.lastAccessed != null)
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Last used: ${coupon.lastAccessed.toString().split('T')[0]}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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
