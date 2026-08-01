import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';

class GlassModal extends StatelessWidget {
  final Widget child;

  const GlassModal({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blurred backdrop
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: AppColors.background.withOpacity(0.4),
            ),
          ),
        ),
        // Centered Card Container
        Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg), // 'xl' token mapped to radiusLg
              boxShadow: AppShadows.modal,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}