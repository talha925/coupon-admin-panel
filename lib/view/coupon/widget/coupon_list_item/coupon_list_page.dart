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
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This ensures stores are refreshed when navigating back to this page
    if (!_initialLoadDone) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final storeVM = Provider.of<StoreViewModel>(context, listen: false);
    final couponVM = Provider.of<CouponViewModel>(context, listen: false);

    // Use addPostFrameCallback to safely call methods that trigger notifyListeners()
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Always refresh stores when the page is loaded or revisited
      await storeVM.getStores();

      // Mark that load is done
      _initialLoadDone = true;

      // If we already have a selected store, fetch its coupons
      if (_selectedStoreId.value != null &&
          _selectedStoreId.value!.isNotEmpty) {
        couponVM.fetchCouponsForStore(storeId: _selectedStoreId.value!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeVM = Provider.of<StoreViewModel>(context);
    final couponVM = Provider.of<CouponViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coupons by Store'),
          actions: [
            // Add a refresh button to manually refresh store data
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh store data',
              onPressed: () {
                // Use post-frame callback to avoid setState during build
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await storeVM.getStores();
                  if (_selectedStoreId.value != null &&
                      _selectedStoreId.value!.isNotEmpty) {
                    couponVM.fetchCouponsForStore(
                        storeId: _selectedStoreId.value!);
                  }
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StoreSearchDropdown(
                selectedStoreId: _selectedStoreId,
                onChanged: (storeId) {
                  if (storeId != null &&
                      storeId.isNotEmpty &&
                      storeVM.stores.isNotEmpty) {
                    // Look for the store with the matching ID
                    final storeIndex = storeVM.stores
                        .indexWhere((store) => store.id == storeId);

                    // If found, use it; otherwise use the first store
                    if (storeIndex >= 0) {
                      final selectedStore = storeVM.stores[storeIndex];
                      storeVM.selectStore(selectedStore);
                      _selectedStoreId.value = storeId;

                      // Update CouponViewModel's selected store ID
                      couponVM.updateSelectedStore(storeId);
                      couponVM.fetchCouponsForStore(storeId: storeId);
                    } else if (storeVM.stores.isNotEmpty) {
                      // Fallback to the first store if the selected one wasn't found
                      final selectedStore = storeVM.stores.first;
                      storeVM.selectStore(selectedStore);
                      _selectedStoreId.value = selectedStore.id;

                      // Update CouponViewModel's selected store ID
                      couponVM.updateSelectedStore(selectedStore.id);
                      couponVM.fetchCouponsForStore(storeId: selectedStore.id);
                    }
                  }
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
                              onDelete: () async {
                                await couponVM.deleteCoupon(coupon.id);
                                // Refresh coupons for current store after deletion
                                if (_selectedStoreId.value != null) {
                                  couponVM.fetchCouponsForStore(
                                      storeId: _selectedStoreId.value!);
                                }
                              },
                              onUpdate: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => UpdateCouponDialog(
                                    coupon: coupon,
                                    onUpdate: (updatedData) async {
                                      final updatedCoupon = coupon.copyWith(
                                        offerDetails:
                                            updatedData['offerDetails'],
                                        code: updatedData['code'],
                                        active: updatedData['active'],
                                        featuredForHome:
                                            updatedData['featuredForHome'],
                                      );

                                      await couponVM
                                          .updateCoupon(updatedCoupon);

                                      // Refresh coupons for current store after update
                                      if (_selectedStoreId.value != null) {
                                        couponVM.fetchCouponsForStore(
                                            storeId: _selectedStoreId.value!);
                                      }
                                    },
                                  ),
                                );
                              },
                              onToggleActive: () async {
                                await couponVM
                                    .toggleCouponActiveStatus(coupon.id);
                                // Refresh coupons for current store after toggling active status
                                if (_selectedStoreId.value != null) {
                                  couponVM.fetchCouponsForStore(
                                      storeId: _selectedStoreId.value!);
                                }
                              },
                              onToggleFeatured: () async {
                                await couponVM
                                    .toggleCouponFeaturedStatus(coupon.id);
                                // Refresh coupons for current store after toggling featured status
                                if (_selectedStoreId.value != null) {
                                  couponVM.fetchCouponsForStore(
                                      storeId: _selectedStoreId.value!);
                                }
                              },
                            );
                          },
                        ),
            ),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: couponVM.currentPage > 1
                      ? couponVM.goToPreviousPage
                      : null,
                ),
                Text('Page ${couponVM.currentPage} of ${couponVM.totalPages}'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: couponVM.currentPage < couponVM.totalPages
                      ? couponVM.goToNextPage
                      : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
