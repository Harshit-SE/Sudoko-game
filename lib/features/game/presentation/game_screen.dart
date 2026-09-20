import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/glass_modal.dart';
import '../../../core/widgets/number_pad.dart';
import '../../../core/widgets/sudoku_cell.dart';
import '../../../core/widgets/sudoku_grid.dart';
import '../../../core/widgets/toolbar_action_button.dart';
import '../application/game_state.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final controller = ref.read(gameProvider.notifier);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Daily puzzle',
        onMenuTap: controller.togglePaused,
        statusPill: _GameStatus(
          elapsedSeconds: game.elapsedSeconds,
          isPaused: game.isPaused,
          onPause: controller.togglePaused,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding,
                AppSpacing.p16,
                AppSpacing.containerPadding,
                AppSpacing.p24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Medium',
                            style: AppTypography.textTheme.labelSmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Take it one cell at a time',
                            style: AppTypography.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p12),
                      SudokuGrid(
                        cellBuilder: (context, row, column) {
                          final index = row * 9 + column;
                          final cell = game.board[index];
                          return SudokuCell(
                            value: cell.value,
                            isGiven: cell.isGiven,
                            notes: cell.notes.toList(),
                            highlightState: _highlightFor(
                              game,
                              row: row,
                              column: column,
                              value: cell.value,
                            ),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              controller.selectCell(index);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.p16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ToolbarActionButton(
                            icon: Icons.lightbulb_outline,
                            label: 'Hint',
                            onTap: () => _showHints(context),
                          ),
                          ToolbarActionButton(
                            icon: Icons.undo_rounded,
                            label: 'Undo',
                            isActive: game.undoHistory.isNotEmpty,
                            onTap: controller.undo,
                          ),
                          ToolbarActionButton(
                            icon: Icons.edit_note_rounded,
                            label: 'Notes',
                            isActive: game.notesMode,
                            onTap: controller.toggleNotesMode,
                          ),
                          ToolbarActionButton(
                            icon: Icons.backspace_outlined,
                            label: 'Erase',
                            onTap: controller.erase,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p16),
                      NumberPad(
                        selectedDigit: game.activeDigit,
                        disabled: game.isPaused ||
                            game.selectedCell == null ||
                            game.board[game.selectedCell ?? 0].isGiven,
                        digitCounts: const {},
                        onDigitTap: (digit) {
                          HapticFeedback.selectionClick();
                          controller.enterDigit(digit);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (game.isPaused)
            Positioned.fill(
              child: GlassModal(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.p24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pause_circle_outline, size: 48, color: AppColors.primary),
                      const SizedBox(height: AppSpacing.p16),
                      Text('Game paused', style: AppTypography.textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.p8),
                      Text(
                        'Take a breath and come back when you are ready.',
                        textAlign: TextAlign.center,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.p20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: controller.togglePaused,
                          child: const Text('Resume'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.p8),
                      TextButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Exit game'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static CellHighlightState _highlightFor(
    GameState game, {
    required int row,
    required int column,
    required int? value,
  }) {
    final index = game.selectedCell;
    if (index == row * 9 + column) return CellHighlightState.selected;
    if (index != null) {
      final selected = game.board[index];
      final sameUnit = selected.row == row ||
          selected.column == column ||
          (selected.row ~/ 3 == row ~/ 3 && selected.column ~/ 3 == column ~/ 3);
      if (value != null && value == selected.value) return CellHighlightState.match;
      if (sameUnit) return CellHighlightState.peer;
    }
    return CellHighlightState.none;
  }

  static Future<void> _showHints(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerPadding,
            AppSpacing.p8,
            AppSpacing.containerPadding,
            AppSpacing.p24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Need a little help?', style: AppTypography.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.p8),
              Text(
                'Choose a gentle nudge. These options are visual placeholders for now.',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.p16),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: const Text('Reveal a cell'),
                subtitle: const Text('See one possible move'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Learn a technique'),
                subtitle: const Text('Open a short Sudoku lesson'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameStatus extends StatelessWidget {
  final int elapsedSeconds;
  final bool isPaused;
  final VoidCallback onPause;

  const _GameStatus({
    required this.elapsedSeconds,
    required this.isPaused,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: AppTypography.textTheme.labelSmall?.copyWith(color: AppColors.primary),
        ),
        IconButton(
          onPressed: onPause,
          icon: Icon(isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
          tooltip: isPaused ? 'Resume game' : 'Pause game',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
