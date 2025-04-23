import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view/store/widget/storeForm/store_form.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class CreateStorePage extends StatelessWidget {
  const CreateStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Store'),
      ),
      body: Consumer<StoreViewModel>(
        builder: (context, storeViewModel, _) {
          return Column(
            children: [
              // Error message display
              if (storeViewModel.errorMessage != null &&
                  storeViewModel.errorMessage!.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    storeViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Main content
              Expanded(
                child: Stack(
                  children: [
                    // Form
                    const SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StoreFormWidget(),
                        ],
                      ),
                    ),

                    // Loading overlay
                    if (storeViewModel.isSubmitting)
                      Container(
                        color: Colors.black.withValues(alpha: 0.1),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
