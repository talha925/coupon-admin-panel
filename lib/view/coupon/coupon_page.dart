import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view/coupon/widget/Coupon_form/coupon_form_widget.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'widget/coupon_list_item/coupon_list_page.dart';

class CreateCouponPage extends StatelessWidget {
  const CreateCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Coupon'),
      ),
      body: Consumer<StoreViewModel>(
        builder: (context, storeViewModel, child) {
          if (storeViewModel.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          return const CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CouponFormWidget(), // Directly using CouponFormWidget
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 16.0),
              ),
              // SliverFillRemaining(
              //   child: Padding(
              //     padding: EdgeInsets.all(16.0),
              //     child: CouponListPage(),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
