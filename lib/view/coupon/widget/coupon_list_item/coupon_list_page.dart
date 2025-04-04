// ✅ Final Coupon Page UI using StoreModel with Searchable Store Dropdown

import 'package:coupon_admin_panel/res/components/store_dropdown_search.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/coupon_list_item.dart';
import 'widget/update_coupon_dialog.dart';

class CouponListByStorePage extends StatefulWidget {
  const CouponListByStorePage({super.key});

  @override
  State<CouponListByStorePage> createState() => _CouponListByStorePageState();
}

class _CouponListByStorePageState extends State<CouponListByStorePage> {
  final ValueNotifier<String?> _selectedStoreId = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storeVM = Provider.of<StoreViewModel>(context, listen: false);
      final couponVM = Provider.of<CouponViewModel>(context, listen: false);
      storeVM.getStores();
      couponVM.getCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeVM = Provider.of<StoreViewModel>(context);
    final couponVM = Provider.of<CouponViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Coupons by Store')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StoreSearchDropdown(
                selectedStoreId: _selectedStoreId,
                onChanged: (storeId) {
                  final selectedStore = storeVM.stores.firstWhere(
                    (store) => store.id == storeId,
                    orElse: () => storeVM.stores.first,
                  );
                  storeVM.selectStore(selectedStore);
                  couponVM.updateSelectedStore(storeId);
                },
              ),
            ),
            if (storeVM.selectedStore != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Coupons for: ${storeVM.selectedStore!.name}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            Expanded(
              child: couponVM.isFetching
                  ? const Center(child: CircularProgressIndicator())
                  : couponVM.filteredCoupons.isEmpty
                      ? const Center(
                          child: Text('No coupons available for this store'))
                      : ListView.builder(
                          itemCount: couponVM.filteredCoupons.length,
                          itemBuilder: (context, index) {
                            final coupon = couponVM.filteredCoupons[index];
                            return CouponListItem(
                              coupon: coupon,
                              onDelete: () => couponVM.deleteCoupon(coupon.id),
                              onUpdate: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => UpdateCouponDialog(
                                    coupon: coupon,
                                    onUpdate: (updatedData) {
                                      final updatedCoupon = coupon.copyWith(
                                        offerDetails:
                                            updatedData['offerDetails'],
                                        code: updatedData['code'],
                                        active: updatedData['active'],
                                        featuredForHome:
                                            updatedData['featuredForHome'],
                                      );
                                      couponVM.updateCoupon(updatedCoupon);
                                    },
                                  ),
                                );
                              },
                              onToggleActive: () =>
                                  couponVM.toggleCouponActiveStatus(coupon.id),
                              onToggleFeatured: () => couponVM
                                  .toggleCouponFeaturedStatus(coupon.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
