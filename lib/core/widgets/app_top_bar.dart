import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback? onSettingsTap;
  final Widget? statusPill; // Used for Game Board timer/difficulty

  const AppTopBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    this.onSettingsTap,
    this.statusPill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.touchTarget, // 48px
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.onSurface),
            onPressed: onMenuTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            title,
            style: AppTypography.textTheme.displayMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          if (statusPill != null) 
            statusPill!
          else if (onSettingsTap != null)
            IconButton(
              icon: const Icon(Icons.settings, color: AppColors.onSurface),
              onPressed: onSettingsTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            const SizedBox(width: 24), // Balance spacing if no trailing widget
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.touchTarget);
}