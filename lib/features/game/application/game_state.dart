import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_game_data.dart';
import '../domain/game_cell.dart';

final gameProvider = NotifierProvider<GameController, GameState>(GameController.new);

class GameState {
  final List<GameCell> board;
  final int? selectedCell;
  final int? activeDigit;
  final bool notesMode;
  final int elapsedSeconds;
  final bool isPaused;
  final List<GameSnapshot> undoHistory;

  const GameState({
    required this.board,
    this.selectedCell,
    this.activeDigit,
    this.notesMode = false,
    this.elapsedSeconds = 0,
    this.isPaused = false,
    this.undoHistory = const [],
  });

  GameState copyWith({
    List<GameCell>? board,
    Object? selectedCell = _unset,
    Object? activeDigit = _unset,
    bool? notesMode,
    int? elapsedSeconds,
    bool? isPaused,
    List<GameSnapshot>? undoHistory,
  }) {
    return GameState(
      board: board ?? this.board,
      selectedCell: identical(selectedCell, _unset) ? this.selectedCell : selectedCell as int?,
      activeDigit: identical(activeDigit, _unset) ? this.activeDigit : activeDigit as int?,
      notesMode: notesMode ?? this.notesMode,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isPaused: isPaused ?? this.isPaused,
      undoHistory: undoHistory ?? this.undoHistory,
    );
  }
}

class GameSnapshot {
  final List<GameCell> board;
  final int? selectedCell;
  final int? activeDigit;

  const GameSnapshot({
    required this.board,
    required this.selectedCell,
    required this.activeDigit,
  });
}

const _unset = Object();

class GameController extends Notifier<GameState> {
  Timer? _timer;

  @override
  GameState build() {
    ref.onDispose(() => _timer?.cancel());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
    return GameState(board: MockGameData.board);
  }

  void selectCell(int index) {
    if (state.isPaused) return;
    state = state.copyWith(selectedCell: index, activeDigit: null);
  }

  void toggleNotesMode() {
    if (state.isPaused) return;
    state = state.copyWith(notesMode: !state.notesMode, activeDigit: null);
  }

  void enterDigit(int digit) {
    final index = state.selectedCell;
    if (state.isPaused || index == null || state.board[index].isGiven) return;

    final cell = state.board[index];
    final nextBoard = List<GameCell>.from(state.board);
    final history = _historyWithCurrentState();
    if (state.notesMode) {
      final notes = Set<int>.from(cell.notes);
      if (!notes.add(digit)) notes.remove(digit);
      nextBoard[index] = cell.copyWith(value: null, notes: notes);
    } else {
      nextBoard[index] = cell.copyWith(value: digit, notes: const {});
    }
    state = state.copyWith(
      board: nextBoard,
      activeDigit: digit,
      undoHistory: history,
    );
  }

  void erase() {
    final index = state.selectedCell;
    if (state.isPaused || index == null || state.board[index].isGiven) return;
    final cell = state.board[index];
    final nextBoard = List<GameCell>.from(state.board);
    final history = _historyWithCurrentState();
    if (state.notesMode && state.activeDigit != null) {
      final notes = Set<int>.from(cell.notes)..remove(state.activeDigit);
      nextBoard[index] = cell.copyWith(notes: notes);
    } else {
      nextBoard[index] = cell.copyWith(value: null, notes: const {});
    }
    state = state.copyWith(board: nextBoard, activeDigit: null, undoHistory: history);
  }

  void undo() {
    if (state.isPaused || state.undoHistory.isEmpty) return;
    final history = List<GameSnapshot>.from(state.undoHistory);
    final snapshot = history.removeLast();
    state = state.copyWith(
      board: snapshot.board,
      selectedCell: snapshot.selectedCell,
      activeDigit: snapshot.activeDigit,
      undoHistory: history,
    );
  }

  void togglePaused() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  List<GameSnapshot> _historyWithCurrentState() {
    final history = List<GameSnapshot>.from(state.undoHistory)
      ..add(GameSnapshot(
        board: List<GameCell>.from(state.board),
        selectedCell: state.selectedCell,
        activeDigit: state.activeDigit,
      ));
    return history;
  }
}
