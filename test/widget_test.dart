import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudoko_game/features/game/application/game_state.dart';
import 'package:sudoko_game/features/game/presentation/game_screen.dart';

void main() {
  test('game controller supports entry, notes, undo, and pause', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(gameProvider.notifier);

    controller.selectCell(2);
    controller.enterDigit(5);
    expect(container.read(gameProvider).board[2].value, 5);

    controller.toggleNotesMode();
    controller.enterDigit(7);
    expect(container.read(gameProvider).board[2].notes, contains(7));

    controller.undo();
    expect(container.read(gameProvider).board[2].notes, isEmpty);

    controller.togglePaused();
    expect(container.read(gameProvider).isPaused, isTrue);
    controller.enterDigit(9);
    expect(container.read(gameProvider).board[2].value, 5);
  });

  testWidgets('game screen renders the board and gameplay controls', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: GameScreen()),
      ),
    );

    expect(find.text('Daily puzzle'), findsOneWidget);
    expect(find.text('Hint'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Erase'), findsOneWidget);
    expect(find.text('5'), findsWidgets);
  });
}
