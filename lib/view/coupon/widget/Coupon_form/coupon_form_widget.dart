import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart';
import 'package:coupon_admin_panel/res/components/custom_textfild_component.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class CouponFormWidget extends StatefulWidget {
  const CouponFormWidget({super.key});

  @override
  CouponFormWidgetState createState() => CouponFormWidgetState();
}

class CouponFormWidgetState extends State<CouponFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _offerDetailsController = TextEditingController();

  String? _selectedStoreId;
  bool _isCodeSelected = false;
  bool _isActiveSelected = true;
  bool _isFeaturedForHome = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<StoreViewModel>(context, listen: false).getStores();
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _offerDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ADD COUPON",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Offer Details Field
              CustomTextFormField(
                controller: _offerDetailsController,
                labelText: 'Offer Details',
                // maxLines: 3,
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
                    groupValue: _isCodeSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCodeSelected = true;
                        _isActiveSelected = false;
                      });
                    },
                  ),
                  const Text("Code"),
                  const SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: _isCodeSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCodeSelected = false;
                        _isActiveSelected = true;
                      });
                    },
                  ),
                  const Text("Active"),
                ],
              ),

              // Code Field (only if code is selected)
              if (_isCodeSelected)
                CustomTextFormField(
                  controller: _codeController,
                  labelText: 'Enter Code',
                  validator: (value) => _isCodeSelected
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
                value: _isFeaturedForHome,
                onChanged: (value) {
                  setState(() => _isFeaturedForHome = value);
                },
              ),

              // Store Dropdown
              Consumer<StoreViewModel>(
                builder: (context, storeViewModel, child) {
                  if (storeViewModel.isFetching) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (storeViewModel.stores.isEmpty) {
                    return const Text('No stores available');
                  }

                  return DropdownButtonFormField<String>(
                    hint: const Text('Choose Store'),
                    value: _selectedStoreId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStoreId = newValue;
                      });
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
                    child: couponViewModel.isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () =>
                                _submitForm(context, couponViewModel),
                            child: const Text('Save Your Coupon'),
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

  Future<void> _submitForm(
      BuildContext context, CouponViewModel couponViewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final couponData = {
      "offerDetails": _offerDetailsController.text,
      "code": _isCodeSelected ? _codeController.text : '',
      "store": _selectedStoreId, // just ID (string)
      "active": _isActiveSelected,
      "featuredForHome": _isFeaturedForHome,
    };

    try {
      final success = await couponViewModel.createCoupon(couponData);
      if (success) {
        Utils.toastMessage('Coupon created successfully!');
        _clearForm();
      } else {
        Utils.toastMessage('Failed to create coupon. Please try again.');
      }
    } catch (e) {
      Utils.toastMessage('Error creating coupon: ${e.toString()}');
    }
  }

  void _clearForm() {
    _codeController.clear();
    _offerDetailsController.clear();
    setState(() {
      _selectedStoreId = null;
      _isCodeSelected = false;
      _isActiveSelected = true;
      _isFeaturedForHome = false;
    });
  }
}
