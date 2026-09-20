import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/difficulty_chip.dart';
import '../../../core/widgets/zen_card.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: 'Sudoku',
        onMenuTap: _doNothing,
        onSettingsTap: _doNothing,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find your focus.', style: AppTypography.textTheme.displayMedium),
                  const SizedBox(height: AppSpacing.p8),
                  Text(
                    'A calm puzzle is waiting whenever you are ready.',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p24),
                  ZenCard(
                    padding: const EdgeInsets.all(AppSpacing.p24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DifficultyChip(difficulty: SudokuDifficulty.medium),
                        const SizedBox(height: AppSpacing.p16),
                        Text('Daily puzzle', style: AppTypography.textTheme.headlineMedium),
                        const SizedBox(height: AppSpacing.p8),
                        Text(
                          'One thoughtful grid for today. Take your time.',
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.p20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                                onPressed: () => context.go('/game'),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Start daily puzzle'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p32),
                  Text(
                    'Choose a difficulty',
                    style: AppTypography.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.p12),
                  Text(
                    'Pick a pace that feels right for this moment.',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p16),
                  Wrap(
                    spacing: AppSpacing.p12,
                    runSpacing: AppSpacing.p12,
                    children: SudokuDifficulty.values
                        .map((difficulty) => _DifficultyOption(difficulty: difficulty))
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.p32),
                  ZenCard(
                    style: ZenCardStyle.neutral,
                    padding: const EdgeInsets.all(AppSpacing.p20),
                    child: Row(
                      children: [
                        Container(
                          width: AppSpacing.touchTarget,
                          height: AppSpacing.touchTarget,
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_outlined,
                            color: AppColors.onSecondaryFixed,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.p16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your quiet corner',
                                style: AppTypography.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.p4),
                              Text(
                                'No rush. Just one cell at a time.',
                                style: AppTypography.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _doNothing() {}
}

class _DifficultyOption extends StatelessWidget {
  final SudokuDifficulty difficulty;

  const _DifficultyOption({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return ZenCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.p16,
        vertical: AppSpacing.p12,
      ),
      child: DifficultyChip(difficulty: difficulty),
    );
  }
}
