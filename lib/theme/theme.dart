import 'package:manazco/theme/colors.dart';
import 'package:manazco/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData bootcampTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    disabledColor: AppColors.disabled,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.gray01,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.transparent,
      backgroundColor: AppColors.gray01,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.bodyLg.copyWith(color: AppColors.primary);
        }
        return AppTextStyles.bodyLg.copyWith(color: AppColors.disabled);
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }
        return IconThemeData(color: AppColors.disabled);
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.gray07;
        }
        return AppColors.gray01;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.pressed)) {
          return AppColors.red07;
        } else if (states.contains(WidgetState.hovered)) {
          return AppColors.red07;
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.primary;
        }
        return AppColors.gray01;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.gray07;
        }
        return AppColors.gray01;
      }),
      side: const BorderSide(color: AppColors.gray01),
    ),
    cardTheme: CardTheme(
      color: AppColors.gray01,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.gray01),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.gray01,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.gray08,
        textStyle: AppTextStyles.bodyLgMedium.copyWith(color: AppColors.gray01),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: AppTextStyles.bodyLgSemiBold,
      unselectedLabelStyle: AppTextStyles.bodyLg,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.gray14,
      indicator: const BoxDecoration(
        color: AppColors.blue02,
        borderRadius: BorderRadius.all(Radius.circular(80)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppTextStyles.bodyLgMedium.copyWith(
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    textTheme: TextTheme(
      // Display styles
      displayLarge: AppTextStyles.headingxl,
      displayMedium: AppTextStyles.headingxl,
      displaySmall: AppTextStyles.headingxl,

      // Headline styles
      headlineLarge: AppTextStyles.headingMd,
      headlineMedium: AppTextStyles.headingMd,
      headlineSmall: AppTextStyles.headingSm,

      // Body styles
      bodyLarge: AppTextStyles.bodyLg,
      bodyMedium: AppTextStyles.bodyLg,
      bodySmall: AppTextStyles.bodyLg,

      // Subtitle styles
      titleLarge: AppTextStyles.bodyLgMedium,
      titleMedium: AppTextStyles.bodyLgMedium,
      titleSmall: AppTextStyles.bodyLg,

      // Label styles (button text, etc.)
      labelLarge: AppTextStyles.bodyLgSemiBold,
      labelMedium: AppTextStyles.bodyLgSemiBold,
      labelSmall: AppTextStyles.bodyLgSemiBold,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      //error: AppColors.bodyLgSemiBold,
      // background: AppColors.gray01,
      surface: AppColors.surface,
      onPrimary: AppColors.gray01,
      // Text color on primary elements
      onSecondary: AppColors.gray01,
      // Text color on secondary elements
      onError: AppColors.gray01, // Text color on error elements
    ),
  );
  static final BoxDecoration sectionBorderGray05 = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: AppColors.gray01),
    color: Colors.white, // Fondo blanco
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1), // Sombra suave
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
