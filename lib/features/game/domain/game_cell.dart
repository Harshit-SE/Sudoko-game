class GameCell {
  final int row;
  final int column;
  final int? value;
  final bool isGiven;
  final Set<int> notes;

  const GameCell({
    required this.row,
    required this.column,
    this.value,
    this.isGiven = false,
    this.notes = const {},
  });

  GameCell copyWith({
    Object? value = _unset,
    bool? isGiven,
    Set<int>? notes,
  }) {
    return GameCell(
      row: row,
      column: column,
      value: identical(value, _unset) ? this.value : value as int?,
      isGiven: isGiven ?? this.isGiven,
      notes: notes ?? this.notes,
    );
  }
}

const _unset = Object();
