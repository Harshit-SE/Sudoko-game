import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

enum ZenCardStyle { brand, neutral }

class ZenCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ZenCardStyle style;
  final EdgeInsetsGeometry padding;

  const ZenCard({
    super.key,
    required this.child,
    this.onTap,
    this.style = ZenCardStyle.brand,
    this.padding = const EdgeInsets.all(AppSpacing.p16),
  });

  @override
  State<ZenCard> createState() => _ZenCardState();
}

class _ZenCardState extends State<ZenCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isBrand = widget.style == ZenCardStyle.brand;
    final baseShadow = isBrand ? AppShadows.zenShadow : AppShadows.zenCard;
    final hoverShadow = isBrand ? AppShadows.zenShadowHover : AppShadows.zenCardHover;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppConfig.animationMedium,
        curve: AppConfig.zenEasing,
        transform: Matrix4.translationValues(0, _isPressed ? -2.0 : 0.0, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: _isPressed ? hoverShadow : baseShadow,
        ),
        child: widget.child,
      ),
    );
  }
}