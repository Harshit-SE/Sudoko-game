import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:sudoko_game/features/game/domain/sudoku/models/sudoku_board.dart';
import 'package:sudoko_game/features/game/domain/sudoku/models/sudoku_difficulty.dart';
import 'package:sudoko_game/features/game/domain/sudoku/services/sudoku_generator.dart';
import 'package:sudoko_game/features/game/domain/sudoku/services/sudoku_solver.dart';
import 'package:sudoko_game/features/game/domain/sudoku/services/sudoku_validator.dart';
import 'package:sudoko_game/features/game/domain/sudoku/sudoku_engine.dart';

const _puzzle = '530070000600195000098000060800060003400803001700020006060000280000419005000080079';
const _solution = '534678912672195348198342567859761423426853791713924856961537284287419635345286179';

void main() {
  group('SudokuBoard', () {
    test('creates empty board and supports immutable updates', () {
      final board = SudokuBoard.empty();
      final updated = board.withValue(0, 0, 5, given: true);

      expect(board.valueAt(0, 0), 0);
      expect(updated.valueAt(0, 0), 5);
      expect(updated.isGiven(0, 0), isTrue);
      expect(SudokuBoard.indexFor(8, 8), 80);
      expect(SudokuBoard.rowFor(17), 1);
      expect(SudokuBoard.columnFor(17), 8);
    });

    test('rejects malformed boards and coordinates', () {
      expect(() => SudokuBoard(List<int>.filled(80, 0)), throwsA(isA<SudokuInputException>()));
      expect(() => SudokuBoard.indexFor(9, 0), throwsA(isA<SudokuInputException>()));
      expect(() => SudokuBoard.fromString('short'), throwsA(isA<SudokuInputException>()));
    });
  });

  group('SudokuValidator', () {
    const validator = SudokuValidator();

    test('identifies valid, complete, and invalid boards', () {
      final incomplete = SudokuBoard.fromString(_puzzle);
      final complete = SudokuBoard.fromString(_solution);
      final invalid = incomplete.withValue(0, 2, 5);

      expect(validator.status(incomplete), SudokuBoardStatus.validIncomplete);
      expect(validator.isComplete(complete), isTrue);
      expect(validator.isValid(invalid), isFalse);
    });

    test('calculates candidates and validates legal moves', () {
      final board = SudokuBoard.fromString(_puzzle);

      expect(validator.getCandidates(board, 0, 2), {1, 2, 4});
      expect(validator.canPlace(board, 0, 2, 4), isTrue);
      expect(validator.canPlace(board, 0, 2, 5), isFalse);
      expect(validator.getCandidates(board, 0, 0), isEmpty);
    });
  });

  group('SudokuSolver', () {
    const solver = SudokuSolver();

    test('solves a known puzzle without mutating the input', () {
      final puzzle = SudokuBoard.fromString(_puzzle);
      final solved = solver.solve(puzzle);

      expect(solved?.values, SudokuBoard.fromString(_solution).values);
      expect(puzzle.valueAt(0, 2), 0);
      expect(solver.countSolutions(puzzle), 1);
    });

    test('detects unsolvable and multiple-solution boards', () {
      final invalid = SudokuBoard.fromString(_puzzle).withValue(0, 2, 5);
      expect(solver.solve(invalid), isNull);

      final empty = SudokuBoard.empty();
      expect(solver.countSolutions(empty), 2);
    });
  });

  group('SudokuGenerator', () {
    test('generates valid solved boards deterministically with a seed', () {
      final generator = SudokuGenerator(random: Random(42));
      final solved = generator.generateSolvedBoard();

      expect(const SudokuValidator().status(solved), SudokuBoardStatus.validComplete);
      expect(solved.values.toSet(), {1, 2, 3, 4, 5, 6, 7, 8, 9});
    });

    test('generates unique valid puzzles for every difficulty', () {
      final validator = const SudokuValidator();
      final solver = const SudokuSolver();
      final engine = SudokuEngine(generator: SudokuGenerator(random: Random(7)));

      for (final difficulty in SudokuDifficulty.values) {
        final puzzle = engine.generate(difficulty);
        final clues = puzzle.values.where((value) => value != 0).length;
        expect(validator.isValid(puzzle), isTrue);
        expect(solver.countSolutions(puzzle), 1);
        expect(clues, inInclusiveRange(difficulty.minClues, difficulty.maxClues));
        expect(solver.solve(puzzle), isNotNull);
      }
    });
  });
}
