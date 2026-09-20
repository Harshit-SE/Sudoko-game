enum SudokuDifficulty {
  easy(
    minClues: 40,
    maxClues: 46,
    generationAttempts: 30,
  ),
  medium(
    minClues: 34,
    maxClues: 39,
    generationAttempts: 40,
  ),
  hard(
    minClues: 29,
    maxClues: 33,
    generationAttempts: 50,
  ),
  expert(
    minClues: 24,
    maxClues: 28,
    generationAttempts: 80,
  );

  final int minClues;
  final int maxClues;
  final int generationAttempts;

  const SudokuDifficulty({
    required this.minClues,
    required this.maxClues,
    required this.generationAttempts,
  });
}
