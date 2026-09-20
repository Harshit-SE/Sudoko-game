import '../domain/game_cell.dart';

abstract class MockGameData {
  static const _puzzle = <String>[
    '530070000',
    '600195000',
    '098000060',
    '800060003',
    '400803001',
    '700020006',
    '060000280',
    '000419005',
    '000080079',
  ];

  static List<GameCell> get board {
    return [
      for (var row = 0; row < 9; row++)
        for (var column = 0; column < 9; column++)
          GameCell(
            row: row,
            column: column,
            value: _valueAt(row, column),
            isGiven: _valueAt(row, column) != null,
          ),
    ];
  }

  static int? _valueAt(int row, int column) {
    final value = int.parse(_puzzle[row][column]);
    return value == 0 ? null : value;
  }
}
