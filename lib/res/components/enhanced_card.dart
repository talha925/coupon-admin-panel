import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/res/theme/app_dimensions.dart';

class EnhancedCard extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? highlightColor;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isHoverable;
  final bool hasBorder;
  final bool isSelected;

  const EnhancedCard({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.highlightColor,
    this.padding = const EdgeInsets.all(AppDimensions.paddingM),
    this.elevation = AppDimensions.elevationS,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.isHoverable = true,
    this.hasBorder = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<EnhancedCard> createState() => _EnhancedCardState();
}

class _EnhancedCardState extends State<EnhancedCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBorderRadius = BorderRadius.circular(
      AppDimensions.cardBorderRadius,
    );

    final effectiveBackgroundColor = widget.backgroundColor ??
        (isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface);

    return MouseRegion(
      onEnter: widget.isHoverable && widget.onTap != null
          ? (_) => setState(() => _isHovering = true)
          : null,
      onExit: widget.isHoverable && widget.onTap != null
          ? (_) => setState(() => _isHovering = false)
          : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _getBackgroundColor(
              effectiveBackgroundColor,
              colorScheme,
              isDark,
            ),
            borderRadius: widget.borderRadius ?? defaultBorderRadius,
            border: widget.hasBorder || widget.isSelected
                ? Border.all(
                    color: widget.isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withAlpha(isDark ? 77 : 51),
                    width: widget.isSelected ? 2 : 1,
                  )
                : null,
            boxShadow: [
              if (widget.elevation > 0)
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(_isHovering ? 77 : 51)
                      : Colors.black.withAlpha(_isHovering ? 26 : 13),
                  blurRadius: widget.elevation * (_isHovering ? 2 : 1),
                  spreadRadius: widget.elevation * 0.4,
                  offset: Offset(0, widget.elevation * 0.5),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? defaultBorderRadius,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(
    Color defaultColor,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    if (widget.isSelected) {
      return colorScheme.primary.withAlpha(13);
    }

    if (_isHovering && widget.highlightColor != null) {
      return widget.highlightColor!;
    }

    if (_isHovering) {
      return isDark
          ? defaultColor.withAlpha(51)
          : Color.lerp(defaultColor, colorScheme.primary, 0.03)!;
    }

    return defaultColor;
  }
}
