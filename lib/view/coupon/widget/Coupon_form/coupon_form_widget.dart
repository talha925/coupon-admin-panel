import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_form_view_model.dart';
import 'package:coupon_admin_panel/res/components/custom_textfild_component.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class CouponFormWidget extends StatelessWidget {
  const CouponFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the CouponFormViewModel using Provider
    return ChangeNotifierProvider(
      create: (_) => CouponFormViewModel(),
      child: const _CouponFormContent(),
    );
  }
}

class _CouponFormContent extends StatefulWidget {
  const _CouponFormContent();

  @override
  _CouponFormContentState createState() => _CouponFormContentState();
}

class _CouponFormContentState extends State<_CouponFormContent> {
  // Create separate focus nodes for input fields
  final FocusNode _offerDetailsFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final storeVM = Provider.of<StoreViewModel>(context, listen: false);
        // Only fetch stores if the list is empty
        if (storeVM.stores.isEmpty) {
          storeVM.getStores();
        }
      }
    });
  }

  @override
  void dispose() {
    _offerDetailsFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formViewModel = Provider.of<CouponFormViewModel>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formViewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ADD COUPON",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Offer Details Field with explicit focus node
              CustomTextFormField(
                controller: formViewModel.offerDetailsController,
                focusNode: _offerDetailsFocusNode,
                labelText: 'Offer Details',
                validator: (value) => FormUtils.validateRequiredField(
                  value,
                  errorMessage: 'Please enter offer details',
                ),
              ),
              const SizedBox(height: 10),

              // Radio Buttons for "Code" and "Active"
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: formViewModel.isCodeSelected,
                    onChanged: (bool? value) {
                      // Remove focus before changing the UI to prevent keyboard issues
                      FocusManager.instance.primaryFocus?.unfocus();
                      formViewModel.setIsCodeSelected(true);
                    },
                  ),
                  const Text("Code"),
                  const SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: formViewModel.isCodeSelected,
                    onChanged: (bool? value) {
                      // Remove focus before changing the UI to prevent keyboard issues
                      FocusManager.instance.primaryFocus?.unfocus();
                      formViewModel.setIsActiveSelected(true);
                    },
                  ),
                  const Text("Active"),
                ],
              ),

              // Code Field (only if code is selected)
              if (formViewModel.isCodeSelected)
                CustomTextFormField(
                  controller: formViewModel.codeController,
                  focusNode: _codeFocusNode,
                  labelText: 'Enter Code',
                  validator: (value) => formViewModel.isCodeSelected
                      ? FormUtils.validateRequiredField(
                          value,
                          errorMessage: 'Please enter the coupon code',
                        )
                      : null,
                ),
              const SizedBox(height: 10),

              // Featured For Home Switch
              SwitchListTile(
                title: const Text("Featured For Home"),
                value: formViewModel.isFeaturedForHome,
                onChanged: (value) {
                  // Remove focus before changing the UI to prevent keyboard issues
                  FocusManager.instance.primaryFocus?.unfocus();
                  formViewModel.setIsFeaturedForHome(value);
                },
              ),

              // Store Dropdown
              Consumer<StoreViewModel>(
                builder: (context, storeViewModel, child) {
                  // Only show a loading indicator if we're fetching and have no stores
                  if (storeViewModel.isFetching &&
                      storeViewModel.stores.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (storeViewModel.stores.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                          'No stores available. Please add a store first.'),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    hint: const Text('Choose Store'),
                    value: formViewModel.selectedStoreId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: storeViewModel.isFetching
                        ? null // Disable dropdown while fetching
                        : (String? newValue) {
                            // Remove focus before changing the UI to prevent keyboard issues
                            FocusManager.instance.primaryFocus?.unfocus();
                            formViewModel.setSelectedStoreId(newValue);
                          },
                    items: storeViewModel.stores.map((Data store) {
                      return DropdownMenuItem<String>(
                        value: store.id,
                        child: Text(store.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a store';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // Submit Button
              Consumer<CouponViewModel>(
                builder: (context, couponViewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: couponViewModel.isSubmitting
                          ? null // Disable button while submitting
                          : () {
                              // Remove focus before submission to prevent keyboard issues
                              FocusManager.instance.primaryFocus?.unfocus();
                              formViewModel.submitForm(
                                  context, couponViewModel);
                            },
                      child: couponViewModel.isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.0)),
                                SizedBox(width: 8),
                                Text('Saving...'),
                              ],
                            )
                          : const Text('Save Your Coupon'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
