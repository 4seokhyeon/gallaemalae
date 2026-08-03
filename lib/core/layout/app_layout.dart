import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract final class AppLayout {
  static const phoneMaxContentWidth = 600.0;
  static const tabletMaxContentWidth = 760.0;

  static bool isIOS(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool isCompactWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 360;
  }

  static bool isCompactHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height < 700;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return 14;
    if (width < 430) return 20;
    if (width < 600) return 24;
    return 32;
  }

  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < 600 ? phoneMaxContentWidth : tabletMaxContentWidth;
  }

  /// iOS 탭 바는 콘텐츠 위에 오버레이되지만 Android NavigationBar는
  /// Scaffold가 body 영역에서 제외하므로 Android에서는 0을 반환합니다.
  static double navigationOverlayInset(BuildContext context) {
    if (!isIOS(context)) return 0;
    return 54 + MediaQuery.paddingOf(context).bottom;
  }

  static double fluid(
    BuildContext context, {
    required double compact,
    required double regular,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final progress = ((width - 320) / 110).clamp(0.0, 1.0);
    return compact + (regular - compact) * progress;
  }

  static double usableHeight(BuildContext context) {
    final media = MediaQuery.of(context);
    return math.max(
      0,
      media.size.height - media.padding.vertical - media.viewInsets.bottom,
    );
  }
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    super.key,
    this.padding,
    this.maxWidth,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? AppLayout.contentMaxWidth(context),
        ),
        child: Padding(
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding(context),
              ),
          child: child,
        ),
      ),
    );
  }
}
