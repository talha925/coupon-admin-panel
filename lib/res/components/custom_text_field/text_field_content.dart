import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/utils/utils.dart';
import 'package:coupon_admin_panel/res/theme/app_dimensions.dart';
import 'package:coupon_admin_panel/res/theme/app_typography.dart';
import 'package:coupon_admin_panel/res/components/custom_text_field/text_field_state.dart';
import 'package:coupon_admin_panel/res/components/custom_text_field/custom_text_form_field.dart';

class TextFieldContent extends StatelessWidget {
  final CustomTextFormField widget;

  const TextFieldContent({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFieldState = Provider.of<TextFieldState>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.isObscure,
            readOnly: widget.readOnly,
            style: AppTypography.bodyMedium.copyWith(
              color: widget.readOnly
                  ? Theme.of(context).colorScheme.onSurface.withAlpha(179)
                  : Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText ?? widget.labelText,
              helperText: widget.helperText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: widget.readOnly
                  ? colorScheme.surfaceContainerHighest
                      .withAlpha(isDarkMode ? 77 : 128)
                  : textFieldState.isFocused
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest
                          .withAlpha(isDarkMode ? 51 : 26),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                borderSide: BorderSide(
                  color: textFieldState.hasError
                      ? colorScheme.error
                      : colorScheme.outline.withAlpha(128),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                borderSide: BorderSide(
                  color: textFieldState.hasError
                      ? colorScheme.error
                      : colorScheme.outline.withAlpha(128),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                borderSide: BorderSide(
                  color: textFieldState.hasError
                      ? colorScheme.error
                      : colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingM,
              ),
              labelStyle: AppTypography.labelLarge.copyWith(
                color: textFieldState.isFocused
                    ? colorScheme.primary
                    : textFieldState.hasError
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant.withAlpha(128),
              ),
              errorStyle: AppTypography.bodySmall.copyWith(
                color: colorScheme.error,
              ),
              helperStyle: AppTypography.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(128),
              ),
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(179),
              ),
            ),
            validator: (value) {
              if (widget.validator != null) {
                final error = widget.validator!(value);
                textFieldState.setError(error != null);
                return error;
              }
              return null;
            },
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }

              // If there was an error and now it's fixed, clear the error
              if (textFieldState.hasError && widget.validator != null) {
                final error = widget.validator!(value);
                textFieldState.setError(error != null);
              }
            },
            onFieldSubmitted: (value) {
              // Shift focus to the next field
              if (widget.focusNode != null && widget.nextFocusNode != null) {
                Utils.fieldFocusChange(
                    context, widget.focusNode!, widget.nextFocusNode!);
              }
            },
            maxLines: widget.maxLines ?? 1,
          ),
        ),
      ],
    );
  }
}
