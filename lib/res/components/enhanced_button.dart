import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/res/theme/app_dimensions.dart';
import 'package:coupon_admin_panel/res/theme/app_typography.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  error,
  success,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class EnhancedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;

  const EnhancedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.width,
  }) : super(key: key);

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttonHeight = _getButtonHeight();
    final buttonTextStyle = _getButtonTextStyle();
    final horizontalPadding = _getHorizontalPadding();

    // Colors based on variant
    final backgroundColor = _getBackgroundColor(colorScheme);
    final foregroundColor = _getForegroundColor(colorScheme);
    final overlayColor = _getOverlayColor(colorScheme);
    final borderColor = _getBorderColor(colorScheme);

    final effectiveWidth = widget.isFullWidth ? double.infinity : widget.width;

    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: effectiveWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: widget.onPressed == null
              ? _getDisabledColor(colorScheme)
              : _isHovered
                  ? overlayColor
                  : backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: widget.variant == ButtonVariant.outline ||
                  widget.variant == ButtonVariant.text
              ? Border.all(
                  color: widget.onPressed == null
                      ? colorScheme.onSurface.withAlpha(31)
                      : borderColor,
                  width: 1,
                )
              : null,
          boxShadow: widget.variant != ButtonVariant.outline &&
                  widget.variant != ButtonVariant.text &&
                  widget.onPressed != null
              ? [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withAlpha(_isHovered ? 77 : 51)
                        : backgroundColor.withAlpha(_isHovered ? 102 : 51),
                    blurRadius: _isHovered ? 8 : 4,
                    spreadRadius: 0,
                    offset:
                        _isHovered ? const Offset(0, 2) : const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: Padding(
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: _getVerticalPadding(),
                  ),
              child: Row(
                mainAxisSize:
                    widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.prefixIcon != null && !widget.isLoading) ...[
                    Icon(
                      widget.prefixIcon,
                      color: widget.onPressed == null
                          ? colorScheme.onSurface.withAlpha(97)
                          : foregroundColor,
                      size: _getIconSize(),
                    ),
                    SizedBox(width: widget.label.isNotEmpty ? 8 : 0),
                  ],
                  if (widget.isLoading)
                    SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: foregroundColor,
                      ),
                    )
                  else if (widget.label.isNotEmpty)
                    Text(
                      widget.label,
                      style: buttonTextStyle.copyWith(
                        color: widget.onPressed == null
                            ? colorScheme.onSurface.withAlpha(97)
                            : foregroundColor,
                      ),
                    ),
                  if (widget.suffixIcon != null &&
                      !widget.isLoading &&
                      widget.label.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(
                      widget.suffixIcon,
                      color: widget.onPressed == null
                          ? colorScheme.onSurface.withAlpha(97)
                          : foregroundColor,
                      size: _getIconSize(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppDimensions.buttonHeightS;
      case ButtonSize.large:
        return AppDimensions.buttonHeightL;
      case ButtonSize.medium:
        return AppDimensions.buttonHeightM;
    }
  }

  TextStyle _getButtonTextStyle() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTypography.buttonSmall;
      case ButtonSize.large:
        return AppTypography.buttonLarge;
      case ButtonSize.medium:
        return AppTypography.buttonMedium;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppDimensions.paddingM;
      case ButtonSize.large:
        return AppDimensions.paddingL;
      case ButtonSize.medium:
        return AppDimensions.paddingM;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppDimensions.paddingXS;
      case ButtonSize.large:
        return AppDimensions.paddingM;
      case ButtonSize.medium:
        return AppDimensions.paddingS;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppDimensions.iconS;
      case ButtonSize.large:
        return AppDimensions.iconM;
      case ButtonSize.medium:
        return AppDimensions.iconS;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ButtonVariant.secondary:
        return colorScheme.secondaryContainer;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return Colors.transparent;
      case ButtonVariant.error:
        return colorScheme.error;
      case ButtonVariant.success:
        return Colors.green;
      case ButtonVariant.primary:
        return colorScheme.primary;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ButtonVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return colorScheme.primary;
      case ButtonVariant.error:
        return colorScheme.onError;
      case ButtonVariant.success:
        return Colors.white;
      case ButtonVariant.primary:
        return colorScheme.onPrimary;
    }
  }

  Color _getOverlayColor(ColorScheme colorScheme) {
    final baseColor = _getBackgroundColor(colorScheme);

    if (widget.variant == ButtonVariant.outline ||
        widget.variant == ButtonVariant.text) {
      return colorScheme.primary.withAlpha(26);
    }

    return Color.lerp(baseColor, Colors.white, 0.1)!;
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ButtonVariant.outline:
        return colorScheme.primary;
      case ButtonVariant.text:
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  Color _getDisabledColor(ColorScheme colorScheme) {
    if (widget.variant == ButtonVariant.outline ||
        widget.variant == ButtonVariant.text) {
      return Colors.transparent;
    }

    return colorScheme.onSurface.withAlpha(31);
  }
}
