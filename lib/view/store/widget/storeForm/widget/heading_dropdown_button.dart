import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';

class HeadingDropdown extends StatelessWidget {
  const HeadingDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, child) {
        final currentValue = storeViewModel.selectedHeading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Heading *',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),

            // Use FormField to integrate with form validation
            FormField<String>(
              initialValue: currentValue,
              validator: (value) => FormUtils.validateHeading(value),
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.hasError ? Colors.red : Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentValue,
                          hint: const Text('Select a heading for the store'),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              storeViewModel.selectHeading(newValue);
                            }
                            state.didChange(newValue);
                          },
                          items:
                              FormUtils.ALLOWED_HEADINGS.map((String heading) {
                            return DropdownMenuItem<String>(
                              value: heading,
                              child: Text(
                                heading,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Show error message if validation fails
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    // Always show helper text to guide user
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        'Allowed values are: "Promo Codes & Coupon", "Coupons & Promo Codes", "Voucher & Discount Codes"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
