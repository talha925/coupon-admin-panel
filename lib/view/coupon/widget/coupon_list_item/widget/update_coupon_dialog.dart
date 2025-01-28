import 'package:coupon_admin_panel/utils/date_utils.dart';
import 'package:coupon_admin_panel/view_model/coupon_view_model/coupon_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'package:coupon_admin_panel/res/components/custom_textfild_component.dart';

class UpdateCouponDialog extends StatelessWidget {
  final Datum coupon;

  const UpdateCouponDialog({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController(text: coupon.code);
    final descriptionController =
        TextEditingController(text: coupon.description);
    final discountController =
        TextEditingController(text: coupon.discount.toString());
    final expirationDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(coupon.expirationDate));
    final affiliateLinkController =
        TextEditingController(text: coupon.affiliateLink);

    return AlertDialog(
      title: const Text('Update Coupon'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              controller: codeController,
              labelText: 'Coupon Code',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a coupon code';
                }
                return null;
              },
            ),
            CustomTextFormField(
              controller: descriptionController,
              labelText: 'Description',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            CustomTextFormField(
              controller: discountController,
              labelText: 'Discount (%)',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a discount';
                }
                return null;
              },
            ),
            TextFormField(
              controller: expirationDateController,
              decoration: InputDecoration(
                labelText: 'Expiration Date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => AppDateUtils.selectDate(
                    context: context,
                    controller: expirationDateController,
                  ),
                ),
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an expiration date';
                }
                return null;
              },
            ),
            CustomTextFormField(
              controller: affiliateLinkController,
              labelText: 'Affiliate Link',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an affiliate link';
                }
                if (!Uri.parse(value).isAbsolute) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Update'),
          onPressed: () {
            final updatedCoupon = Datum(
              id: coupon.id,
              code: codeController.text,
              description: descriptionController.text,
              discount:
                  int.tryParse(discountController.text) ?? coupon.discount,
              expirationDate: DateTime.parse(expirationDateController.text),
              store: coupon.store,
              affiliateLink: affiliateLinkController.text,
              v: coupon.v,
            );

            Provider.of<CouponViewModel>(context, listen: false)
                .updateCoupon(updatedCoupon);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
