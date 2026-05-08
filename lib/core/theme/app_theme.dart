import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgLight,
    colorScheme: const ColorScheme.light(
      primary:   AppColors.primary,
      surface:   AppColors.cardLight,
      error:     AppColors.error,
      onPrimary: Colors.white,
      onSurface: AppColors.fgLight,
    ),
    cardTheme: CardTheme(
      color: AppColors.cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.borderLight, thickness: 1, space: 0),
    textTheme: _buildTextTheme(AppColors.fgLight, AppColors.fgMutedLight),
    inputDecorationTheme: _inputTheme(Brightness.light),
    elevatedButtonTheme: _elevatedBtnTheme(),
    outlinedButtonTheme: _outlinedBtnTheme(Brightness.light),
    textButtonTheme: _textBtnTheme(),
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.primary,
      surface:   AppColors.cardDark,
      error:     AppColors.error,
      onPrimary: Colors.white,
      onSurface: AppColors.fgDark,
    ),
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.borderDark, thickness: 1, space: 0),
    textTheme: _buildTextTheme(AppColors.fgDark, AppColors.fgMutedDark),
    inputDecorationTheme: _inputTheme(Brightness.dark),
    elevatedButtonTheme: _elevatedBtnTheme(),
    outlinedButtonTheme: _outlinedBtnTheme(Brightness.dark),
    textButtonTheme: _textBtnTheme(),
  );

  static TextTheme _buildTextTheme(Color fg, Color muted) => TextTheme(
    displayLarge:  AppTypography.h1.copyWith(color: fg),
    displayMedium: AppTypography.h2.copyWith(color: fg),
    displaySmall:  AppTypography.h3.copyWith(color: fg),
    headlineMedium:AppTypography.h4.copyWith(color: fg),
    bodyLarge:     AppTypography.body.copyWith(color: fg),
    bodyMedium:    AppTypography.bodySm.copyWith(color: muted),
    labelLarge:    AppTypography.bodyMd.copyWith(color: fg),
    bodySmall:     AppTypography.caption.copyWith(color: muted),
  );

  static InputDecorationTheme _inputTheme(Brightness b) {
    final border = b == Brightness.light ? AppColors.borderLight : AppColors.borderDark;
    return InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    );
  }

  static ElevatedButtonThemeData _elevatedBtnTheme() => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: AppTypography.bodyMd,
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.pressed))  return AppColors.primaryPress;
        if (s.contains(WidgetState.hovered))  return AppColors.primaryHover;
        if (s.contains(WidgetState.disabled)) return AppColors.fgDisabledLight;
        return AppColors.primary;
      }),
    ),
  );

  static OutlinedButtonThemeData _outlinedBtnTheme(Brightness b) {
    final border = b == Brightness.light ? AppColors.borderLight : AppColors.borderDark;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: b == Brightness.light ? AppColors.fgLight : AppColors.fgDark,
        side: BorderSide(color: border),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: AppTypography.bodyMd,
      ),
    );
  }

  static TextButtonThemeData _textBtnTheme() => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: AppTypography.bodyMd,
    ),
  );
}