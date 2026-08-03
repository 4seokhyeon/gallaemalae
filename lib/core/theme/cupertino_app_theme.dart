import 'package:flutter/cupertino.dart';
import 'package:gallaemalae/core/theme/app_colors.dart';

abstract final class CupertinoAppTheme {
  static const light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.iosTint,
    scaffoldBackgroundColor: AppColors.iosBackground,
    barBackgroundColor: AppColors.iosGlass,
    textTheme: CupertinoTextThemeData(
      navLargeTitleTextStyle: TextStyle(
        color: CupertinoColors.label,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
  );
}
