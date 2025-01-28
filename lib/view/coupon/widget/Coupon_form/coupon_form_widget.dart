// lib/view/coupon/coupon_form_widget.dart

import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'package:coupon_admin_panel/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'package:coupon_admin_panel/utils/utils.dart';
import 'package:coupon_admin_panel/res/components/custom_textfild_component.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';

class CouponFormWidget extends StatefulWidget {
  const CouponFormWidget({super.key});

  @override
  CouponFormWidgetState createState() => CouponFormWidgetState();
}

class CouponFormWidgetState extends State<CouponFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _affiliateLinkController =
      TextEditingController();

  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _expirationDateFocusNode = FocusNode();
  final FocusNode _affiliateLinkFocusNode = FocusNode();

  String? _selectedStoreId; // Track selected store

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    _expirationDateController.dispose();
    _affiliateLinkController.dispose();
    _codeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _discountFocusNode.dispose();
    _expirationDateFocusNode.dispose();
    _affiliateLinkFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("CouponFormWidget");

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Coupon Code field
          CustomTextFormField(
            controller: _codeController,
            labelText: 'Coupon Code',
            focusNode: _codeFocusNode,
            nextFocusNode: _descriptionFocusNode,
            validator: (value) => FormUtils.validateRequiredField(
              value,
              errorMessage: 'Please enter the coupon code',
            ),
          ),
          // Description field
          CustomTextFormField(
            controller: _descriptionController,
            labelText: 'Description',
            focusNode: _descriptionFocusNode,
            nextFocusNode: _discountFocusNode,
            validator: (value) => FormUtils.validateRequiredField(
              value,
              errorMessage: 'Please enter the description',
            ),
          ),
          // Discount field
          CustomTextFormField(
            controller: _discountController,
            labelText: 'Discount',
            focusNode: _discountFocusNode,
            nextFocusNode: _expirationDateFocusNode,
            keyboardType: TextInputType.number,
            validator: (value) => FormUtils.validateRequiredField(
              value,
              errorMessage: 'Please enter the discount amount',
            ),
          ),
          // Expiration Date CouponFormWidget
          CustomTextFormField(
            controller: _expirationDateController,
            labelText: 'Expiration Date',
            focusNode: _expirationDateFocusNode,
            nextFocusNode: _affiliateLinkFocusNode,
            readOnly: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => AppDateUtils.selectDate(
                context: context,
                controller: _expirationDateController,
                initialDate: DateTime.now(),
              ),
            ),
            validator: (value) => FormUtils.validateRequiredField(
              value,
              errorMessage: 'Please select an expiration date',
            ),
          ),
          // Affiliate Link field
          CustomTextFormField(
            controller: _affiliateLinkController,
            labelText: 'Affiliate Link',
            focusNode: _affiliateLinkFocusNode,
            validator: (value) => FormUtils.validateWebsite(
              value,
            ),
          ),
          const SizedBox(height: 20),
          // Store dropdown using the StoreDropdown widget
          // StoreDropdown(
          //   selectedStoreId: _selectedStoreId,
          //   onStoreSelected: (String? newStoreId) {
          //     setState(() {
          //       _selectedStoreId = newStoreId;
          //     });
          //   },
          // ),
          const SizedBox(height: 20),
          Consumer<CouponViewModel>(
            builder: (context, couponViewModel, child) {
              return couponViewModel.isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final expirationDate =
                                DateTime.parse(_expirationDateController.text);
                            final coupon = Datum(
                              id: '',
                              code: _codeController.text,
                              description: _descriptionController.text,
                              discount: int.parse(_discountController.text),
                              expirationDate: expirationDate,
                              store: Store(
                                id: _selectedStoreId ?? '',
                                name: '',
                                image: '',
                              ),
                              affiliateLink: _affiliateLinkController.text,
                              v: 0,
                            );
                            await couponViewModel.createCoupon(coupon);
                            Utils.toastMessage('Coupon created successfully!');
                            _codeController.clear();
                            _descriptionController.clear();
                            _discountController.clear();
                            _expirationDateController.clear();
                            _affiliateLinkController.clear();
                          } catch (e) {
                            Utils.toastMessage(
                                'Error creating coupon: ${e.toString()}');
                          }
                        }
                      },
                      child: const Text('Create Coupon'),
                    );
            },
          ),
        ],
      ),
    );
  }
}
