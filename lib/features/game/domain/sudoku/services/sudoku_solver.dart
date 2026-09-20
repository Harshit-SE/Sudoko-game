import '../models/sudoku_board.dart';
import 'sudoku_validator.dart';

class SudokuSolver {
  final SudokuValidator validator;

  const SudokuSolver({this.validator = const SudokuValidator()});

  SudokuBoard? solve(SudokuBoard board) {
    if (!validator.isValid(board)) return null;
    final values = List<int>.from(board.values);
    if (!_search(values, limit: 1)) return null;
    return SudokuBoard(values, givenIndices: board.givenIndices);
  }

  int countSolutions(SudokuBoard board, {int limit = 2}) {
    if (limit < 1) throw const SudokuInputException('Solution count limit must be at least 1.');
    if (!validator.isValid(board)) return 0;
    return _count(List<int>.from(board.values), limit);
  }

  bool _search(List<int> values, {required int limit}) {
    final index = _bestEmptyIndex(values);
    if (index == -1) return true;
    final candidates = _candidates(values, index);
    if (candidates.isEmpty) return false;
    for (final value in candidates) {
      values[index] = value;
      if (_search(values, limit: limit)) return true;
      values[index] = 0;
    }
    return false;
  }

  int _count(List<int> values, int limit) {
    final index = _bestEmptyIndex(values);
    if (index == -1) return 1;
    var count = 0;
    for (final value in _candidates(values, index)) {
      values[index] = value;
      count += _count(values, limit);
      values[index] = 0;
      if (count >= limit) return count;
    }
    return count;
  }

  int _bestEmptyIndex(List<int> values) {
    var bestIndex = -1;
    var bestCount = 10;
    for (var index = 0; index < SudokuBoard.cellCount; index++) {
      if (values[index] != 0) continue;
      final count = _candidates(values, index).length;
      if (count < bestCount) {
        bestCount = count;
        bestIndex = index;
        if (count == 1) break;
      }
    }
    return bestIndex;
  }

  List<int> _candidates(List<int> values, int index) {
    final row = index ~/ SudokuBoard.size;
    final column = index % SudokuBoard.size;
    final used = <int>{};
    for (var i = 0; i < SudokuBoard.size; i++) {
      used.add(values[row * SudokuBoard.size + i]);
      used.add(values[i * SudokuBoard.size + column]);
    }
    final boxRow = row ~/ 3 * 3;
    final boxColumn = column ~/ 3 * 3;
    for (var r = boxRow; r < boxRow + 3; r++) {
      for (var c = boxColumn; c < boxColumn + 3; c++) {
        used.add(values[r * 9 + c]);
      }
    }
    return [for (var value = 1; value <= 9; value++) if (!used.contains(value)) value];
  }
}
