import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/theme_provider.dart';
import 'package:coupon_admin_panel/res/theme/app_dimensions.dart';
import 'package:coupon_admin_panel/res/theme/app_typography.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              child: Row(
                children: [
                  Text(
                    'Theme',
                    style: AppTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  _buildThemeButton(
                    context: context,
                    isSelected: themeProvider.isLightTheme,
                    icon: Icons.light_mode_outlined,
                    tooltip: 'Light Mode',
                    onTap: () => themeProvider.setLightTheme(),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  _buildThemeButton(
                    context: context,
                    isSelected: themeProvider.isDarkTheme,
                    icon: Icons.dark_mode_outlined,
                    tooltip: 'Dark Mode',
                    onTap: () => themeProvider.setDarkTheme(),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  _buildThemeButton(
                    context: context,
                    isSelected: themeProvider.isSystemTheme,
                    icon: Icons.settings_outlined,
                    tooltip: 'System Default',
                    onTap: () => themeProvider.setSystemTheme(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required bool isSelected,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final surfaceColor = colorScheme.surface;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingS),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withAlpha(26) : surfaceColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(
              color:
                  isSelected ? primaryColor : colorScheme.outline.withAlpha(77),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconM,
            color: isSelected
                ? primaryColor
                : colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ),
    );
  }
}
