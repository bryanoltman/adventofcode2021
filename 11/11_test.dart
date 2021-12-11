import 'dart:math';

import 'package:test/test.dart';
import '11.dart';

main() {
  final input = '''
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526''';

  final smallInput = '''
    11111
    19991
    19191
    19991
    11111''';

  late List<List<int>> board;
  late List<List<int>> smallBoard;

  setUp(() {
    board = parseInput(input);
    smallBoard = parseInput(smallInput);
  });

  test('advancesToNextStep', () {
    smallBoard = advanceToNextStep(smallBoard);
    expect(smallBoard[0], [3, 4, 5, 4, 3]);
    expect(smallBoard[1], [4, 0, 0, 0, 4]);
    expect(smallBoard[2], [5, 0, 0, 0, 5]);
    expect(smallBoard[3], [4, 0, 0, 0, 4]);
    expect(smallBoard[4], [3, 4, 5, 4, 3]);
  });

  test('computes flash count', () {
    smallBoard = advanceToNextStep(smallBoard);
    expect(flashCount(smallBoard), 9);

    smallBoard = advanceToNextStep(smallBoard);
    expect(flashCount(smallBoard), 0);

    for (int i = 0; i < 195; i++) {
      board = advanceToNextStep(board);
    }

    expect(board.expand((e) => e).where((e) => e != 0), isEmpty);
  });
}
