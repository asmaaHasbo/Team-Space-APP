import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.font18SemiBold.copyWith(
        color: AppColors.white,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.white
              : AppColors.textSecondary,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => AppTextStyles.font13Medium.copyWith(
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.primaryLight,
        textStyle: AppTextStyles.font16Bold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        minimumSize: const Size.fromHeight(52),
      ),
    ),

    // المصدر الوحيد لشكل كل حقول الإدخال — الـ widgets بتاعتنا
    // (AppTextField / AppPhoneField) بتعتمد عليه ومبتعيدش تعريف الشكل.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldFill,
      hintStyle: AppTextStyles.font16Regular.copyWith(
        color: AppColors.textHint,
      ),
      errorStyle: AppTextStyles.font13Regular.copyWith(color: AppColors.error),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _border(AppColors.border),
      enabledBorder: _border(AppColors.border),
      disabledBorder: _border(AppColors.divider),
      focusedBorder: _border(AppColors.primary),
      errorBorder: _border(AppColors.error),
      focusedErrorBorder: _border(AppColors.error),
    ),

    textTheme: TextTheme(
      titleLarge: AppTextStyles.font20Bold.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyMedium: AppTextStyles.font15Regular.copyWith(
        color: AppColors.textPrimary,
      ),
      bodySmall: AppTextStyles.font13Regular.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
  );

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.base),
    borderSide: BorderSide(color: color, width: 1),
  );
}
