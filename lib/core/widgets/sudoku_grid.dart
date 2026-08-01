import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class SudokuGrid extends StatelessWidget {
  final Widget Function(BuildContext context, int row, int col) cellBuilder;

  const SudokuGrid({
    super.key,
    required this.cellBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Keep it perfectly square
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.boardGap),
        decoration: BoxDecoration(
          color: AppColors.outlineVariant, // Acts as the thick 3x3 separator lines
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          children: List.generate(3, (blockRow) {
            return Expanded(
              child: Row(
                children: List.generate(3, (blockCol) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1), // Sub-grid separator
                      // FIX: Passing context down to the helper method
                      child: _buildSubGrid(context, blockRow, blockCol),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  // FIX: Added BuildContext context to the method signature
  Widget _buildSubGrid(BuildContext context, int blockRow, int blockCol) {
    return Column(
      children: List.generate(3, (localRow) {
        return Expanded(
          child: Row(
            children: List.generate(3, (localCol) {
              final globalRow = (blockRow * 3) + localRow;
              final globalCol = (blockCol * 3) + localCol;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.boardGap / 2),
                  child: cellBuilder(context, globalRow, globalCol),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}