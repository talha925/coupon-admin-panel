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
      // Check if stores are already loaded to avoid unnecessary fetches
      bool needsStoreRefresh = storeVM.stores.isEmpty;
      if (needsStoreRefresh) {
        await storeVM.getStores();
      }

      // Mark that load is done
      _initialLoadDone = true;

      // If we already have a selected store in the CouponViewModel, ensure store is selected and fetch coupons
      if (couponVM.selectedStoreId != null &&
          couponVM.selectedStoreId!.isNotEmpty) {
        // If we have a selected store ID, also update the StoreViewModel's selected store if needed
        final storeIndex = storeVM.stores
            .indexWhere((store) => store.id == couponVM.selectedStoreId);
        if (storeIndex >= 0 &&
            storeVM.selectedStore?.id != couponVM.selectedStoreId) {
          // Only update the selected store if it's different from the current one
          storeVM.selectStore(storeVM.stores[storeIndex], notify: false);
        }

        // Only fetch coupons if we refreshed stores or if filtered coupons is empty
        if (needsStoreRefresh || couponVM.filteredCoupons.isEmpty) {
          couponVM.fetchCouponsForStore(
              storeId: couponVM.selectedStoreId!, updateStore: false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the view models but don't rebuild the whole UI when they change
    final storeVM = Provider.of<StoreViewModel>(context, listen: false);
    final couponVM = Provider.of<CouponViewModel>(context, listen: false);

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
                  final storeVM =
                      Provider.of<StoreViewModel>(context, listen: false);
                  final couponVM =
                      Provider.of<CouponViewModel>(context, listen: false);

                  // Batch updates to minimize rebuilds
                  await storeVM.getStores();

                  if (couponVM.selectedStoreId != null &&
                      couponVM.selectedStoreId!.isNotEmpty) {
                    // After refreshing stores, make sure the selected store is still valid
                    final storeExists = storeVM.stores
                        .any((store) => store.id == couponVM.selectedStoreId);

                    if (storeExists) {
                      // Refresh coupons for the selected store
                      couponVM.fetchCouponsForStore(
                          storeId: couponVM.selectedStoreId!);
                    } else {
                      // Store no longer exists, reset selection or select first available
                      if (storeVM.stores.isNotEmpty) {
                        storeVM.selectStore(storeVM.stores.first,
                            notify: false);
                        couponVM.updateSelectedStore(storeVM.stores.first.id,
                            notify: false);
                        couponVM.fetchCouponsForStore(
                            storeId: storeVM.stores.first.id,
                            updateStore: false);
                      } else {
                        // No stores available, clear selection
                        storeVM.selectStore(null);
                        couponVM.updateSelectedStore(null);
                      }
                    }
                  }
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Wrapper widget for the store dropdown to handle selection state
            const StoreDropdownWrapper(),

            // Selected store display - only listen to StoreViewModel.selectedStore changes
            Consumer<StoreViewModel>(
              builder: (context, storeViewModel, _) {
                return storeViewModel.selectedStore != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Coupons for: ${storeViewModel.selectedStore!.name}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),

            // Coupons list - only listen to CouponViewModel's relevant state changes
            Expanded(
              child: Consumer<CouponViewModel>(
                builder: (context, couponViewModel, _) {
                  if (couponViewModel.isFetching) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (couponViewModel.filteredCoupons.isEmpty) {
                    return const Center(
                        child: Text('No coupons available for this store'));
                  }

                  return ListView.builder(
                    itemCount: couponViewModel.filteredCoupons.length,
                    itemBuilder: (context, index) {
                      final coupon = couponViewModel.filteredCoupons[index];
                      return CouponListItem(
                        coupon: coupon,
                        onDelete: () async {
                          await couponViewModel.deleteCoupon(coupon.id);
                          // Refresh coupons for current store after deletion
                          if (couponViewModel.selectedStoreId != null) {
                            couponViewModel.fetchCouponsForStore(
                                storeId: couponViewModel.selectedStoreId!);
                          }
                        },
                        onUpdate: () {
                          showDialog(
                            context: context,
                            builder: (_) => UpdateCouponDialog(
                              coupon: coupon,
                              onUpdate: (updatedData) async {
                                final updatedCoupon = coupon.copyWith(
                                  offerDetails: updatedData['offerDetails'],
                                  code: updatedData['code'],
                                  active: updatedData['active'],
                                  featuredForHome:
                                      updatedData['featuredForHome'],
                                );

                                await couponViewModel
                                    .updateCoupon(updatedCoupon);

                                // Refresh coupons for current store after update
                                if (couponViewModel.selectedStoreId != null) {
                                  couponViewModel.fetchCouponsForStore(
                                      storeId:
                                          couponViewModel.selectedStoreId!);
                                }
                              },
                            ),
                          );
                        },
                        onToggleActive: () async {
                          await couponViewModel
                              .toggleCouponActiveStatus(coupon.id);
                          // Refresh coupons for current store after toggling active status
                          if (couponViewModel.selectedStoreId != null) {
                            couponViewModel.fetchCouponsForStore(
                                storeId: couponViewModel.selectedStoreId!);
                          }
                        },
                        onToggleFeatured: () async {
                          await couponViewModel
                              .toggleCouponFeaturedStatus(coupon.id);
                          // Refresh coupons for current store after toggling featured status
                          if (couponViewModel.selectedStoreId != null) {
                            couponViewModel.fetchCouponsForStore(
                                storeId: couponViewModel.selectedStoreId!);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Pagination controls - only listen to page-related changes
            Consumer<CouponViewModel>(
              builder: (context, couponViewModel, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: couponViewModel.currentPage > 1
                          ? couponViewModel.goToPreviousPage
                          : null,
                    ),
                    Text(
                        'Page ${couponViewModel.currentPage} of ${couponViewModel.totalPages}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: couponViewModel.currentPage <
                              couponViewModel.totalPages
                          ? couponViewModel.goToNextPage
                          : null,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Wrapper for the store dropdown to handle the store selection state
class StoreDropdownWrapper extends StatelessWidget {
  const StoreDropdownWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the CouponViewModel with listen:false to avoid rebuilds
    final couponVM = Provider.of<CouponViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // Use Selector to only rebuild when selectedStoreId changes
      child: Selector<CouponViewModel, String?>(
        selector: (_, viewModel) => viewModel.selectedStoreId,
        builder: (context, selectedStoreId, _) {
          return Consumer<StoreViewModel>(
            // Only rebuild when stores or isFetching changes
            builder: (context, storeVM, _) {
              return StoreSearchDropdown(
                selectedStoreId: selectedStoreId,
                onChanged: (storeId) {
                  if (storeId != null &&
                      storeId.isNotEmpty &&
                      storeVM.stores.isNotEmpty) {
                    // Batch state updates to reduce rebuilds
                    _updateStoreSelection(context, storeId, storeVM, couponVM);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to batch state updates
  void _updateStoreSelection(BuildContext context, String storeId,
      StoreViewModel storeVM, CouponViewModel couponVM) {
    // Look for the store with the matching ID
    final storeIndex =
        storeVM.stores.indexWhere((store) => store.id == storeId);

    // If found, use it; otherwise use the first store
    if (storeIndex >= 0) {
      final selectedStore = storeVM.stores[storeIndex];

      // Batch updates to minimize rebuilds
      storeVM.selectStore(selectedStore, notify: false); // Don't notify yet
      couponVM.updateSelectedStore(storeId, notify: false); // Don't notify yet

      // This will trigger a single rebuild after fetching data
      couponVM.fetchCouponsForStore(storeId: storeId, updateStore: false);
    } else if (storeVM.stores.isNotEmpty) {
      // Fallback to the first store if the selected one wasn't found
      final selectedStore = storeVM.stores.first;

      // Batch updates to minimize rebuilds
      storeVM.selectStore(selectedStore, notify: false); // Don't notify yet
      couponVM.updateSelectedStore(selectedStore.id,
          notify: false); // Don't notify yet

      // This will trigger a single rebuild after fetching data
      couponVM.fetchCouponsForStore(
          storeId: selectedStore.id, updateStore: false);
    }
  }
}
