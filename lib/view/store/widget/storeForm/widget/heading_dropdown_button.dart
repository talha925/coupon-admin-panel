import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class HeadingDropdown extends StatelessWidget {
  const HeadingDropdown({super.key});

  final List<String> _headings = const [
    'Promo Codes & Coupon',
    'Coupons & Promo Codes',
    'Voucher & Discount Codes',
  ]; // ✅ Allowed Headings List

  @override
  Widget build(BuildContext context) {
    print("HeadingDropdown");
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: DropdownButton<String>(
            value: storeViewModel.selectedHeading,
            hint: const Text('Choose Heading'),
            isExpanded: true,
            underline: const SizedBox(), // ✅ Removes default underline
            onChanged: (String? newValue) {
              storeViewModel.selectHeading(newValue!); // ✅ Update in Provider
            },
            items: _headings.map((String heading) {
              return DropdownMenuItem<String>(
                value: heading,
                child: Text(heading),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
