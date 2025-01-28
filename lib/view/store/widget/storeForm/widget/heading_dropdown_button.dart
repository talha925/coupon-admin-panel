import 'package:flutter/material.dart';

class HeadingDropdown extends StatefulWidget {
  const HeadingDropdown({super.key});

  @override
  HeadingDropdownState createState() => HeadingDropdownState();
}

class HeadingDropdownState extends State<HeadingDropdown> {
  String? _selectedHeading; // Stores the currently selected heading

  final List<String> _headings = [
    'Promo Codes & Coupon',
    'Coupons & Promo Codes',
    'Voucher & Discount Codes',
  ]; // List of headings

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButton<String>(
        value: _selectedHeading,
        hint: const Text('Choose Heading'),
        isExpanded: true,
        underline: const SizedBox(), // Removes default underline
        onChanged: (String? newValue) {
          setState(() {
            _selectedHeading = newValue; // Update the selected heading
          });
        },
        items: _headings.map((String heading) {
          return DropdownMenuItem<String>(
            value: heading,
            child: Text(heading),
          );
        }).toList(),
      ),
    );
  }
}
