import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        onPrimary: Colors.white,
        secondary: AppColors.secondaryLight,
        onSecondary: Colors.white,
        error: AppColors.errorLight,
        onError: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceTint: AppColors.primaryLight.withAlpha(13),
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.headingLarge,
        displayMedium: AppTypography.headingMedium,
        displaySmall: AppTypography.headingSmall,
        headlineLarge: AppTypography.titleLarge,
        headlineMedium: AppTypography.titleMedium,
        headlineSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryLight,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: AppDimensions.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingS),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          textStyle: AppTypography.buttonMedium,
          elevation: AppDimensions.elevationS,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: AppTypography.buttonMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: BorderSide(color: AppColors.primaryLight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.errorLight, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.errorLight, width: 2),
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.errorLight,
        ),
        labelStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.textSecondaryLight,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabledLight,
        ),
      ),

      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surfaceLight,
        width: AppDimensions.drawerWidth,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppDimensions.radiusM),
            bottomRight: Radius.circular(AppDimensions.radiusM),
          ),
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight.withAlpha(51);
          }
          return Colors.grey.shade500.withAlpha(51);
        }),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.borderLight,
        thickness: AppDimensions.dividerThin,
        space: AppDimensions.paddingM,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerLight,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        circularTrackColor: AppColors.primaryLight.withAlpha(51),
        linearTrackColor: AppColors.primaryLight.withAlpha(51),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: Colors.white,
        secondary: AppColors.secondaryDark,
        onSecondary: Colors.white,
        error: AppColors.errorDark,
        onError: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceTint: AppColors.primaryDark.withAlpha(26),
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.headingLarge
            .copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.headingMedium
            .copyWith(color: AppColors.textPrimaryDark),
        displaySmall: AppTypography.headingSmall
            .copyWith(color: AppColors.textPrimaryDark),
        headlineLarge:
            AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: AppTypography.titleMedium
            .copyWith(color: AppColors.textPrimaryDark),
        headlineSmall:
            AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge:
            AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium:
            AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        bodySmall:
            AppTypography.bodySmall.copyWith(color: AppColors.textPrimaryDark),
        labelLarge:
            AppTypography.labelLarge.copyWith(color: AppColors.textPrimaryDark),
        labelMedium: AppTypography.labelMedium
            .copyWith(color: AppColors.textPrimaryDark),
        labelSmall:
            AppTypography.labelSmall.copyWith(color: AppColors.textPrimaryDark),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingS),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          textStyle: AppTypography.buttonMedium,
          elevation: AppDimensions.elevationS,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: AppTypography.buttonMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: BorderSide(color: AppColors.primaryDark),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.errorDark, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: AppColors.errorDark, width: 2),
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.errorDark,
        ),
        labelStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabledDark,
        ),
      ),

      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surfaceDark,
        width: AppDimensions.drawerWidth,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppDimensions.radiusM),
            bottomRight: Radius.circular(AppDimensions.radiusM),
          ),
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark.withAlpha(51);
          }
          return Colors.grey.shade400.withAlpha(51);
        }),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.borderDark,
        thickness: AppDimensions.dividerThin,
        space: AppDimensions.paddingM,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: AppDimensions.elevationL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        circularTrackColor: AppColors.primaryDark.withAlpha(51),
        linearTrackColor: AppColors.primaryDark.withAlpha(51),
      ),
    );
  }
}
