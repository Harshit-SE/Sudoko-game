import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../config/app_config.dart';

enum CellHighlightState { none, selected, peer, match, error }

class SudokuCell extends StatelessWidget {
  final int? value;
  final bool isGiven;
  final CellHighlightState highlightState;
  final List<int> notes;
  final VoidCallback onTap;

  const SudokuCell({
    super.key,
    this.value,
    this.isGiven = false,
    this.highlightState = CellHighlightState.none,
    this.notes = const [],
    required this.onTap,
  });

  Color _getBackgroundColor() {
    switch (highlightState) {
      case CellHighlightState.selected:
        return AppColors.primaryContainer;
      case CellHighlightState.match:
        return AppColors.primaryFixedDim;
      case CellHighlightState.peer:
        return AppColors.surfaceVariant;
      case CellHighlightState.error:
        return AppColors.errorContainer;
      case CellHighlightState.none:
      default:
        return AppColors.surfaceContainerLowest;
    }
  }

  Color _getTextColor() {
    if (highlightState == CellHighlightState.error) return AppColors.error;
    if (isGiven) return AppColors.onSurface;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a mobile width to scale down the text
    final isMobile = MediaQuery.sizeOf(context).width < AppSpacing.mdBreakpoint;
    final textStyle = isMobile 
        ? AppTypography.textTheme.bodyMedium 
        : AppTypography.textTheme.bodyLarge;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConfig.animationFast,
        curve: AppConfig.zenEasing,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Center(
          child: value != null
              ? Text(
                  value.toString(),
                  style: textStyle?.copyWith(color: _getTextColor()),
                )
              : _buildNotesGrid(),
        ),
      ),
    );
  }

  Widget _buildNotesGrid() {
    if (notes.isEmpty) return const SizedBox.shrink();
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final noteValue = index + 1;
        return Center(
          child: notes.contains(noteValue)
              ? Text(
                  noteValue.toString(),
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 8, // Scaled down for 3x3 micro-grid
                  ),
                )
              : null,
        );
      },
    );
  }
}