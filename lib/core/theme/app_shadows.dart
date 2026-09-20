import 'package:flutter/material.dart';

abstract class AppShadows {
  // Brand Shadows (Primary Green Tinted)
  static final List<BoxShadow> zenShadow = [
    BoxShadow(
      color: const Color(0xFF476550).withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 24,
    ),
  ];

  static final List<BoxShadow> zenShadowHover = [
    BoxShadow(
      color: const Color(0xFF476550).withValues(alpha: 0.12),
      offset: const Offset(0, 8),
      blurRadius: 32,
    ),
  ];

  // Neutral Shadows
  static final List<BoxShadow> zenCard = [
    BoxShadow(
      color: const Color(0xFF131D25).withValues(alpha: 0.03),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
    BoxShadow(
      color: const Color(0xFF131D25).withValues(alpha: 0.02),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static final List<BoxShadow> zenCardHover = [
    BoxShadow(
      color: const Color(0xFF131D25).withValues(alpha: 0.05),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
    BoxShadow(
      color: const Color(0xFF131D25).withValues(alpha: 0.03),
      offset: const Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  // Component Specific
  static final List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: const Offset(0, -4),
      blurRadius: 12,
    ),
  ];
  
  static final List<BoxShadow> modal = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 24,
    ),
  ];
}