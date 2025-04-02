import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'widget/coupon_list_item.dart';
import 'widget/update_coupon_dialog.dart';
import 'package:coupon_admin_panel/view/widgets/error_widget.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';

extension CouponCopy on CouponData {
  CouponData copyWith({
    String? offerDetails,
    String? code,
    bool? active,
    bool? featuredForHome,
  }) {
    return CouponData(
      id: id,
      offerDetails: offerDetails ?? this.offerDetails,
      code: code ?? this.code,
      active: active ?? this.active,
      isValid: isValid,
      featuredForHome: featuredForHome ?? this.featuredForHome,
      hits: hits,
      lastAccessed: lastAccessed,
      storeId: storeId,
    );
  }
}
class CouponListPage extends StatefulWidget {
  const CouponListPage({super.key});

  @override
  CouponListPageState createState() => CouponListPageState();
}

class CouponListPageState extends State<CouponListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CouponViewModel>(context, listen: false).getCoupons();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Coupons',
                  hintText: 'Enter coupon code or description',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      Provider.of<CouponViewModel>(context, listen: false)
                          .searchCoupons('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  Provider.of<CouponViewModel>(context, listen: false)
                      .searchCoupons(value);
                },
              ),
            ),
            Expanded(
              child: Consumer<CouponViewModel>(
                builder: (context, couponViewModel, child) {
                  if (couponViewModel.isFetching) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (couponViewModel.errorMessage != null) {
                    return ApiErrorWidget(
                      errorMessage: couponViewModel.errorMessage!,
                      onRetry: () => couponViewModel.getCoupons(),
                    );
                  }

                  if (couponViewModel.filteredCoupons.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            couponViewModel.coupons.isEmpty
                                ? 'No coupons available'
                                : 'No coupons match your search',
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          if (couponViewModel.coupons.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                couponViewModel.searchCoupons('');
                              },
                              child: const Text('Clear Search'),
                            ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: couponViewModel.filteredCoupons.length,
                    itemBuilder: (context, index) {
                      final coupon = couponViewModel.filteredCoupons[index];
                      return CouponListItem(
                        coupon: coupon,
                        onDelete: () {
                          couponViewModel.deleteCoupon(coupon.id);
                        },
                        onUpdate: () {
                          couponViewModel.selectCoupon(coupon);
                          showDialog(
                            context: context,
                            builder: (context) => UpdateCouponDialog(
                              coupon: coupon,
                              onUpdate: (updatedData) {
                                Provider.of<CouponViewModel>(context, listen: false)
                                    .updateCoupon(
                                  coupon.copyWith(
                                    offerDetails: updatedData['offerDetails'],
                                    code: updatedData['code'],
                                    active: updatedData['active'],
                                    featuredForHome: updatedData['featuredForHome'],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        onToggleActive: () {
                          couponViewModel.toggleCouponActiveStatus(coupon.id);
                        },
                        onToggleFeatured: () {
                          couponViewModel.toggleCouponFeaturedStatus(coupon.id);
                        },
                      );
                    },
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
