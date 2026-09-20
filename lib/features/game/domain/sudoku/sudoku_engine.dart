import 'models/sudoku_board.dart';
import 'models/sudoku_difficulty.dart';
import 'services/sudoku_generator.dart';
import 'services/sudoku_solver.dart';
import 'services/sudoku_validator.dart';

class SudokuEngine {
  final SudokuValidator validator;
  final SudokuSolver solver;
  final SudokuGenerator generator;

  SudokuEngine({SudokuGenerator? generator})
      : validator = const SudokuValidator(),
        solver = const SudokuSolver(),
        generator = generator ?? SudokuGenerator();

  SudokuBoard generateSolvedBoard() => generator.generateSolvedBoard();

  SudokuBoard generate(SudokuDifficulty difficulty) => generator.generate(difficulty);

  bool isValid(SudokuBoard board) => validator.isValid(board);

  bool isComplete(SudokuBoard board) => validator.isComplete(board);

  bool canPlace(SudokuBoard board, int row, int column, int value) =>
      validator.canPlace(board, row, column, value);

  Set<int> getCandidates(SudokuBoard board, int row, int column) =>
      validator.getCandidates(board, row, column);

  SudokuBoard? solve(SudokuBoard board) => solver.solve(board);

  int countSolutions(SudokuBoard board, {int limit = 2}) =>
      solver.countSolutions(board, limit: limit);
}
