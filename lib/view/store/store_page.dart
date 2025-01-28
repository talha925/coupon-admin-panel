import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view/store/widget/storeForm/store_form.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

import 'widget/store_list_widget/store_list_get_widget.dart';

class CreateStorePage extends StatelessWidget {
  const CreateStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("CreateStorePage ");
    return Scaffold(
      body: Consumer<StoreViewModel>(
        builder: (context, storeViewModel, child) {
          return const CustomScrollView(
            slivers: [
              // Adding the StoreFormWidget as a SliverToBoxAdapter
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: StoreFormWidget(),
                ),
              ),
              // Adding some space between the form and the list
              SliverToBoxAdapter(
                child: SizedBox(height: 16.0),
              ),
              // Adding the Stores List
              SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: StoreListPage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
