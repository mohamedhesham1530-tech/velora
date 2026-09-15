import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // =========================================================
    // COLORS
    // =========================================================

    final backgroundColor = isDark
        ? const Color(0xFF0D0F14)
        : AppColors.background;

    final surfaceColor = isDark ? const Color(0xFF151820) : AppColors.surface;

    final cardColor = isDark ? const Color(0xFF1B1F28) : Colors.white;

    final surfaceVariantColor = isDark
        ? const Color(0xFF202530)
        : const Color(0xFFF1F3F9);

    final outlineColor = isDark ? const Color(0xFF3A414E) : AppColors.grey300;

    final outlineVariantColor = isDark
        ? const Color(0xFF2A303B)
        : AppColors.grey100;

    final onSurfaceColor = isDark ? const Color(0xFFF5F6F8) : AppColors.black;

    final onSurfaceVariantColor = isDark
        ? const Color(0xFFB7BDC8)
        : AppColors.grey700;

    // =========================================================
    // COLOR SCHEME
    // =========================================================

    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,

          surface: surfaceColor,
          onSurface: onSurfaceColor,

          surfaceContainerHighest: surfaceVariantColor,
          onSurfaceVariant: onSurfaceVariantColor,

          outline: outlineColor,
          outlineVariant: outlineVariantColor,

          background: backgroundColor,
          onBackground: onSurfaceColor,

          error: AppColors.error,
          onError: Colors.white,
        );

    // =========================================================
    // TEXT THEME
    // =========================================================

    final textTheme = TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: onSurfaceColor),

      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: onSurfaceColor,
      ),

      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: onSurfaceColor,
      ),

      titleLarge: AppTextStyles.titleLarge.copyWith(color: onSurfaceColor),

      titleMedium: AppTextStyles.titleMedium.copyWith(color: onSurfaceColor),

      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: onSurfaceColor),

      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: onSurfaceColor),

      bodySmall: AppTextStyles.bodySmall.copyWith(color: onSurfaceVariantColor),

      labelLarge: AppTextStyles.button.copyWith(color: onSurfaceColor),
    );

    // =========================================================
    // THEME
    // =========================================================

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      colorScheme: scheme,

      scaffoldBackgroundColor: backgroundColor,

      fontFamily: AppTextStyles.fontFamily,

      textTheme: textTheme,

      // =======================================================
      // APP BAR
      // =======================================================
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: surfaceColor,
        foregroundColor: onSurfaceColor,
        titleTextStyle: textTheme.titleLarge,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: onSurfaceColor),
      ),

      // =======================================================
      // ELEVATED BUTTON
      // =======================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: scheme.primary,

          foregroundColor: scheme.onPrimary,

          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),

          textStyle: AppTextStyles.button.copyWith(color: scheme.onPrimary),
        ),
      ),

      // =======================================================
      // TEXT BUTTON
      // =======================================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),

      // =======================================================
      // ICON BUTTON
      // =======================================================
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: onSurfaceColor),
      ),

      // =======================================================
      // INPUT
      // =======================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: surfaceVariantColor,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          borderSide: BorderSide(color: outlineVariantColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),

        labelStyle: textTheme.bodyMedium?.copyWith(
          color: onSurfaceVariantColor,
        ),

        hintStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceVariantColor),

        prefixIconColor: onSurfaceVariantColor,

        suffixIconColor: onSurfaceVariantColor,
      ),

      // =======================================================
      // CARD
      // =======================================================
      cardTheme: CardThemeData(
        elevation: 0,

        color: cardColor,

        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),

      // =======================================================
      // DIALOG
      // =======================================================
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,

        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),

        titleTextStyle: textTheme.titleLarge?.copyWith(color: onSurfaceColor),

        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: onSurfaceVariantColor,
        ),
      ),

      // =======================================================
      // BOTTOM SHEET
      // =======================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,

        surfaceTintColor: Colors.transparent,

        modalBackgroundColor: cardColor,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
      ),

      // =======================================================
      // DIVIDER
      // =======================================================
      dividerTheme: DividerThemeData(color: outlineVariantColor, thickness: 1),

      // =======================================================
      // SWITCH
      // =======================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }

          return isDark ? const Color(0xFFB7BDC8) : Colors.white;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }

          return isDark ? const Color(0xFF3A414E) : AppColors.grey300;
        }),

        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // =======================================================
      // PROGRESS INDICATOR
      // =======================================================
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: outlineVariantColor,
      ),

      // =======================================================
      // SNACKBAR
      // =======================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF252A34)
            : const Color(0xFF20242C),

        contentTextStyle: const TextStyle(color: Colors.white),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
