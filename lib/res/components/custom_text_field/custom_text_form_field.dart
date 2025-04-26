import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/res/components/custom_text_field/text_field_state.dart';
import 'package:coupon_admin_panel/res/components/custom_text_field/text_field_content.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool isObscure; // For password fields
  final FocusNode? focusNode; // Current field's focus node
  final FocusNode?
      nextFocusNode; // Next field's focus node to shift focus on submit
  final TextInputType? keyboardType;
  final bool readOnly; // To make the field read-only
  final Widget? suffixIcon; // For additional icons
  final Widget? prefixIcon; // For prefix icons
  final Function(String)? onChanged;
  final int? maxLines;
  final String? helperText;
  final String? hintText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.isObscure = false,
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.maxLines,
    this.helperText,
    this.hintText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextFieldState _textFieldState;

  @override
  void initState() {
    super.initState();
    _textFieldState = TextFieldState();
    widget.focusNode?.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    _textFieldState.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    _textFieldState.setFocus(widget.focusNode?.hasFocus ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _textFieldState,
      child: TextFieldContent(widget: widget),
    );
  }
}
