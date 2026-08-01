import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/app_shadows.dart';

enum SudokuDifficulty { easy, medium, hard, expert }

class DifficultyChip extends StatelessWidget {
  final SudokuDifficulty difficulty;
  final bool isActive;
  final bool interactive;
  final VoidCallback? onTap;

  const DifficultyChip({
    super.key,
    required this.difficulty,
    this.isActive = false,
    this.interactive = false,
    this.onTap,
  });

  Color _getDifficultyColor() {
    switch (difficulty) {
      case SudokuDifficulty.easy:
      case SudokuDifficulty.medium:
        return AppColors.primary;
      case SudokuDifficulty.hard:
        return AppColors.tertiary;
      case SudokuDifficulty.expert:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getDifficultyColor();
    final isFilled = isActive || !interactive;

    return GestureDetector(
      onTap: interactive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p12, vertical: AppSpacing.p4),
        decoration: BoxDecoration(
          color: isFilled ? color : Colors.transparent,
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull), // Pill shape
          boxShadow: isActive ? AppShadows.modal : null, // Reusing soft shadow for active state
        ),
        child: Text(
          difficulty.name.toUpperCase(),
          style: AppTypography.textTheme.labelSmall?.copyWith(
            color: isFilled ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
