import 'package:flutter/material.dart';
import 'package:gallaemalae/core/theme/app_colors.dart';

abstract final class MaterialAppTheme {
  static ThemeData get light {
    final colors = ColorScheme.fromSeed(seedColor: AppColors.seed);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      cardTheme: const CardThemeData(elevation: 2),
      navigationBarTheme: const NavigationBarThemeData(elevation: 3),
    );
  }

  static ThemeData get dark {
    final colors = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
    );
  }
}
