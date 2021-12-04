import 'package:test/test.dart';
import '04.dart';

main() {
  final testInput = '''
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
''';

  group(BingoInput, () {
    test('initializes from string', () {
      final input = BingoInput.fromLines(testInput.split('\n'));
      expect(input.draws[0], 7);
      expect(input.draws[1], 4);
      expect(input.draws[2], 9);
      expect(input.draws[3], 5);
      expect(input.draws[4], 11);
      expect(input.draws.last, 1);

      expect(input.boards.length, 3);

      final firstBoardRows = [
        [22, 13, 17, 11, 0],
        [8, 2, 23, 4, 24],
        [21, 9, 14, 16, 7],
        [6, 10, 3, 18, 5],
        [1, 12, 20, 15, 19],
      ];
      expect(input.boards.first.rows, firstBoardRows);

      final lastBoardRows = [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7],
      ];
      expect(input.boards.last.rows, lastBoardRows);
    });

    group('drawing', () {
      late BingoInput input;
      setUp(() {
        input = BingoInput.fromLines(testInput.split('\n'));
      });

      test('selects on all boards', () {
        input.drawNext();
        expect(input.boards.every((b) => b.selectedNumbers.contains(7)), true);

        input.drawNext();
        expect(input.boards.every((b) => b.selectedNumbers.contains(7)), true);
        expect(input.boards.every((b) => b.selectedNumbers.contains(4)), true);

        input.drawNext();
        expect(input.boards.every((b) => b.selectedNumbers.contains(7)), true);
        expect(input.boards.every((b) => b.selectedNumbers.contains(4)), true);
        expect(input.boards.every((b) => b.selectedNumbers.contains(9)), true);
      });

      test('drawing first twelve numbers makes only third board winner', () {
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();
        input.drawNext();

        expect(input.winners, [input.boards[2]]);
      });
    });
  });

  group(BingoBoard, () {
    late BingoBoard board;

    setUp(() {
      board = BingoBoard(rows: [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7],
      ]);
    });

    test('is not winner if no row or column of selected values exists', () {
      board.select(16);
      expect(board.isWinner, false);

      board.select(14);
      expect(board.isWinner, false);

      board.select(7);
      expect(board.isWinner, false);

      board.select(100001);
      expect(board.isWinner, false);
    });

    test('is winner if column of selected values exists', () {
      // Second column is selected
      board.select(21);
      board.select(16);
      board.select(8);
      board.select(11);
      board.select(0);
      expect(board.isWinner, true);
    });

    test('is winner if row of selected values exists', () {
      // Third row is selected
      board.select(18);
      board.select(8);
      board.select(23);
      board.select(26);
      board.select(20);
      expect(board.isWinner, true);
    });
  });
}
