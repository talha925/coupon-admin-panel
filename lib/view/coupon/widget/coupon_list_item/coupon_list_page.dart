import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'widget/coupon_list_item.dart';
import 'widget/update_coupon_dialog.dart';

class CouponListPage extends StatefulWidget {
  const CouponListPage({super.key});

  @override
  CouponListPageState createState() => CouponListPageState();
}

class CouponListPageState extends State<CouponListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final couponViewModel =
            Provider.of<CouponViewModel>(context, listen: false);
        if (couponViewModel.coupons.isEmpty) {
          // Fetch coupons only if the list is empty
          couponViewModel.getCoupons();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("CouponListPage");
    return Consumer<CouponViewModel>(
      builder: (context, couponViewModel, child) {
        if (couponViewModel.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (couponViewModel.coupons.isEmpty) {
          return const Center(child: Text('No coupons available'));
        }

        return ListView.builder(
          itemCount: couponViewModel.coupons.length,
          itemBuilder: (context, index) {
            final coupon = couponViewModel.coupons[index];
            return CouponListItem(
              coupon: coupon,
              onDelete: () {
                Provider.of<CouponViewModel>(context, listen: false)
                    .deleteCoupon(coupon.id);
              },
              onUpdate: () {
                showDialog(
                  context: context,
                  builder: (context) => UpdateCouponDialog(coupon: coupon),
                );
              },
            );
          },
        );
      },
    );
  }
}
