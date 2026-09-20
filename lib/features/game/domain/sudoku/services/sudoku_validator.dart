import '../models/sudoku_board.dart';

enum SudokuBoardStatus { validIncomplete, validComplete, invalid }

class SudokuValidator {
  const SudokuValidator();

  SudokuBoardStatus status(SudokuBoard board) {
    if (!isValid(board)) return SudokuBoardStatus.invalid;
    return board.isComplete ? SudokuBoardStatus.validComplete : SudokuBoardStatus.validIncomplete;
  }

  bool isValid(SudokuBoard board) {
    for (var row = 0; row < SudokuBoard.size; row++) {
      if (!_unitHasNoDuplicates([for (var column = 0; column < SudokuBoard.size; column++) board.valueAt(row, column)])) {
        return false;
      }
    }
    for (var column = 0; column < SudokuBoard.size; column++) {
      if (!_unitHasNoDuplicates([for (var row = 0; row < SudokuBoard.size; row++) board.valueAt(row, column)])) {
        return false;
      }
    }
    for (var boxRow = 0; boxRow < 3; boxRow++) {
      for (var boxColumn = 0; boxColumn < 3; boxColumn++) {
        final values = <int>[];
        for (var row = boxRow * 3; row < boxRow * 3 + 3; row++) {
          for (var column = boxColumn * 3; column < boxColumn * 3 + 3; column++) {
            values.add(board.valueAt(row, column));
          }
        }
        if (!_unitHasNoDuplicates(values)) return false;
      }
    }
    return true;
  }

  bool isComplete(SudokuBoard board) => status(board) == SudokuBoardStatus.validComplete;

  bool canPlace(SudokuBoard board, int row, int column, int value) {
    if (value < 1 || value > 9) {
      throw const SudokuInputException('A move value must be between 1 and 9.');
    }
    final index = SudokuBoard.indexFor(row, column);
    if (board.values[index] != 0) return false;
    for (var i = 0; i < SudokuBoard.size; i++) {
      if (board.valueAt(row, i) == value || board.valueAt(i, column) == value) return false;
    }
    final boxRow = row ~/ 3 * 3;
    final boxColumn = column ~/ 3 * 3;
    for (var r = boxRow; r < boxRow + 3; r++) {
      for (var c = boxColumn; c < boxColumn + 3; c++) {
        if (board.valueAt(r, c) == value) return false;
      }
    }
    return true;
  }

  Set<int> getCandidates(SudokuBoard board, int row, int column) {
    SudokuBoard.indexFor(row, column);
    if (board.valueAt(row, column) != 0) return <int>{};
    return {
      for (var value = 1; value <= 9; value++)
        if (canPlace(board, row, column, value)) value,
    };
  }

  bool _unitHasNoDuplicates(List<int> values) {
    final present = <int>{};
    for (final value in values) {
      if (value != 0 && !present.add(value)) return false;
    }
    return true;
  }
}
