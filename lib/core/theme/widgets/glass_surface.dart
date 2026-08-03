import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground
                .resolveFrom(context)
                .withValues(alpha: 0.72),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.45),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
