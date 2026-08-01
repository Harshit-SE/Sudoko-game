import 'package:flutter/material.dart';

abstract class AppConfig {
  // Motion Language (Derived from UI Specification)
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationAmbient = Duration(milliseconds: 20000);
  
  // Shared Easing Curve for "zen" transitions
  static const Curve zenEasing = Curves.easeInOutCubic;
}