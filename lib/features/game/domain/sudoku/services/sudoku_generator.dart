import 'dart:math';

import '../models/sudoku_board.dart';
import '../models/sudoku_difficulty.dart';
import 'sudoku_solver.dart';
import 'sudoku_validator.dart';

class SudokuGenerator {
  final Random random;
  final SudokuSolver solver;
  final SudokuValidator validator;

  SudokuGenerator({Random? random})
      : random = random ?? Random(),
        solver = const SudokuSolver(),
        validator = const SudokuValidator();

  SudokuBoard generateSolvedBoard() {
    final values = List<int>.filled(SudokuBoard.cellCount, 0);
    if (!_fill(values)) throw StateError('Unable to generate a solved Sudoku board.');
    return SudokuBoard(values);
  }

  SudokuBoard generate(SudokuDifficulty difficulty) {
    for (var attempt = 0; attempt < difficulty.generationAttempts; attempt++) {
      final solved = generateSolvedBoard();
      final puzzle = _removeClues(solved, difficulty);
      final solutionCount = solver.countSolutions(puzzle, limit: 2);
      if (validator.isValid(puzzle) && solutionCount == 1) return puzzle;
    }
    throw StateError('Unable to generate a unique ${difficulty.name} puzzle.');
  }

  SudokuBoard _removeClues(SudokuBoard solved, SudokuDifficulty difficulty) {
    var puzzle = SudokuBoard(solved.values, givenIndices: [for (var i = 0; i < 81; i++) i]);
    final indices = [for (var i = 0; i < 81; i++) i]..shuffle(random);
    final target = difficulty.minClues + random.nextInt(difficulty.maxClues - difficulty.minClues + 1);
    var clues = 81;
    for (final index in indices) {
      if (clues <= target) break;
      final row = index ~/ 9;
      final column = index % 9;
      final candidate = puzzle.withValue(row, column, 0, given: false);
      if (solver.countSolutions(candidate, limit: 2) == 1) {
        puzzle = candidate;
        clues--;
      }
    }
    return puzzle;
  }

  bool _fill(List<int> values) {
    final index = _firstEmpty(values);
    if (index == -1) return true;
    final candidates = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(random);
    for (final value in candidates) {
      if (!_isSafe(values, index, value)) continue;
      values[index] = value;
      if (_fill(values)) return true;
      values[index] = 0;
    }
    return false;
  }

  int _firstEmpty(List<int> values) {
    for (var index = 0; index < values.length; index++) {
      if (values[index] == 0) return index;
    }
    return -1;
  }

  bool _isSafe(List<int> values, int index, int value) {
    final row = index ~/ 9;
    final column = index % 9;
    for (var i = 0; i < 9; i++) {
      if (values[row * 9 + i] == value || values[i * 9 + column] == value) return false;
    }
    final boxRow = row ~/ 3 * 3;
    final boxColumn = column ~/ 3 * 3;
    for (var r = boxRow; r < boxRow + 3; r++) {
      for (var c = boxColumn; c < boxColumn + 3; c++) {
        if (values[r * 9 + c] == value) return false;
      }
    }
    return true;
  }
}
