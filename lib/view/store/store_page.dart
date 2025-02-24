import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view/store/widget/storeForm/store_form.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class CreateStorePage extends StatelessWidget {
  const CreateStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("CreateStorePage ");
    return Scaffold(
      body: Consumer<StoreViewModel>(
        builder: (context, storeViewModel, child) {
          return const Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  // ✅ Ensure scrolling prevents layout overflow
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StoreFormWidget(), // ✅ Form is now scrollable
                        // const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child:
              //       StoreListPage(), // ✅ Store list now takes remaining space
              // ),
            ],
          );
        },
      ),
    );
  }
}
