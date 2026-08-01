import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../config/app_config.dart';

class NumberPadKey extends StatelessWidget {
  final int digit;
  final int remainingCount;
  final VoidCallback onTap;

  const NumberPadKey({
    super.key,
    required this.digit,
    required this.remainingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = remainingCount <= 0;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: AppConfig.animationFast,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Opacity(
          opacity: isDisabled ? 0.3 : 1.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                digit.toString(),
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Text(
                  remainingCount.toString(),
                  style: AppTypography.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  final Map<int, int> digitCounts; // Map of digit (1-9) to remaining count
  final void Function(int) onDigitTap;

  const NumberPad({
    super.key,
    required this.digitCounts,
    required this.onDigitTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: AppSpacing.unit,
        crossAxisSpacing: AppSpacing.unit,
        childAspectRatio: 0.8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final digit = index + 1;
        return NumberPadKey(
          digit: digit,
          remainingCount: digitCounts[digit] ?? 9,
          onTap: () => onDigitTap(digit),
        );
      },
    );
  }
}