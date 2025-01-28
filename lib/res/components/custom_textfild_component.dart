import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/utils/utils.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool isObscure; // For password fields
  final FocusNode? focusNode; // Current field's focus node
  final FocusNode?
      nextFocusNode; // Next field's focus node to shift focus on submit
  final TextInputType keyboardType;
  final bool readOnly; // To make the field read-only
  final Widget? suffixIcon; // For additional icons

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.isObscure = false,
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isObscure,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: labelText,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
          border: InputBorder.none, // Removes default border
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15), // Adjust vertical padding
        ),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        validator: validator,
        onFieldSubmitted: (value) {
          // Shift focus to the next field
          if (focusNode != null && nextFocusNode != null) {
            Utils.fieldFocusChange(context, focusNode!, nextFocusNode!);
          }
        },
      ),
    );
  }
}
