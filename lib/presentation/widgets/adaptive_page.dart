import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';

class AdaptivePage extends StatelessWidget {
  const AdaptivePage({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          backgroundColor: CupertinoTheme.of(
            context,
          ).barBackgroundColor.withValues(alpha: 0.82),
          enableBackgroundFilterBlur: true,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveContent(
            padding: EdgeInsets.fromLTRB(
              AppLayout.horizontalPadding(context),
              20,
              AppLayout.horizontalPadding(context),
              AppLayout.navigationOverlayInset(context) + 16,
            ),
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ResponsiveContent(
          padding: EdgeInsets.fromLTRB(
            AppLayout.horizontalPadding(context),
            20,
            AppLayout.horizontalPadding(context),
            16,
          ),
          child: child,
        ),
      ),
    );
  }
}
