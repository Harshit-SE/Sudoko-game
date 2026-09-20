import 'dart:collection';

class SudokuInputException implements Exception {
  final String message;

  const SudokuInputException(this.message);

  @override
  String toString() => 'SudokuInputException: $message';
}

class SudokuBoard {
  static const int size = 9;
  static const int cellCount = size * size;

  final List<int> _values;
  final Set<int> _givens;

  SudokuBoard(List<int> values, {Iterable<int> givenIndices = const []})
      : _values = List.unmodifiable(values),
        _givens = UnmodifiableSetView(Set<int>.from(givenIndices)) {
    _validateValues(values);
    for (final index in _givens) {
      if (index < 0 || index >= cellCount) {
        throw const SudokuInputException('Given index must be between 0 and 80.');
      }
      if (_values[index] == 0) {
        throw const SudokuInputException('A given cell must contain a value.');
      }
    }
  }

  factory SudokuBoard.empty() => SudokuBoard(List<int>.filled(cellCount, 0));

  factory SudokuBoard.fromRows(
    List<List<int>> rows, {
    bool markNonEmptyAsGiven = false,
  }) {
    if (rows.length != size || rows.any((row) => row.length != size)) {
      throw const SudokuInputException('A Sudoku board must contain 9 rows of 9 values.');
    }
    final values = rows.expand((row) => row).toList();
    return SudokuBoard(
      values,
      givenIndices: markNonEmptyAsGiven
          ? [for (var i = 0; i < values.length; i++) if (values[i] != 0) i]
          : const [],
    );
  }

  factory SudokuBoard.fromString(
    String puzzle, {
    bool markNonEmptyAsGiven = true,
  }) {
    final normalized = puzzle.replaceAll(RegExp(r'\s'), '');
    if (normalized.length != cellCount) {
      throw const SudokuInputException('A Sudoku string must contain exactly 81 digits.');
    }
    final values = [for (final character in normalized.split('')) int.tryParse(character) ?? -1];
    return SudokuBoard.fromRows(
      [for (var row = 0; row < size; row++) values.sublist(row * size, (row + 1) * size)],
      markNonEmptyAsGiven: markNonEmptyAsGiven,
    );
  }

  int valueAt(int row, int column) => _values[indexFor(row, column)];

  bool isGiven(int row, int column) => _givens.contains(indexFor(row, column));

  List<int> get values => List.unmodifiable(_values);

  Set<int> get givenIndices => _givens;

  List<List<int>> get rows => [
        for (var row = 0; row < size; row++)
          [for (var column = 0; column < size; column++) valueAt(row, column)],
      ];

  bool get isComplete => !_values.contains(0);

  SudokuBoard withValue(
    int row,
    int column,
    int value, {
    bool? given,
  }) {
    _validateValue(value);
    final index = indexFor(row, column);
    final values = List<int>.from(_values)..[index] = value;
    final givens = Set<int>.from(_givens);
    if (given == true) givens.add(index);
    if (given == false || value == 0) givens.remove(index);
    return SudokuBoard(values, givenIndices: givens);
  }

  SudokuBoard copy() => SudokuBoard(_values, givenIndices: _givens);

  static int indexFor(int row, int column) {
    if (row < 0 || row >= size || column < 0 || column >= size) {
      throw const SudokuInputException('Row and column must be between 0 and 8.');
    }
    return row * size + column;
  }

  static int rowFor(int index) {
    _validateIndex(index);
    return index ~/ size;
  }

  static int columnFor(int index) {
    _validateIndex(index);
    return index % size;
  }

  static void _validateValues(List<int> values) {
    if (values.length != cellCount) {
      throw const SudokuInputException('A Sudoku board must contain exactly 81 values.');
    }
    for (final value in values) {
      _validateValue(value);
    }
  }

  static void _validateValue(int value) {
    if (value < 0 || value > 9) {
      throw const SudokuInputException('Cell values must be between 0 and 9.');
    }
  }

  static void _validateIndex(int index) {
    if (index < 0 || index >= cellCount) {
      throw const SudokuInputException('Cell index must be between 0 and 80.');
    }
  }
}
