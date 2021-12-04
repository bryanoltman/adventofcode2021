import 'dart:io';

/// 5x5 grid of ints
class BingoBoard {
  final List<List<int>> rows;

  List<int> selectedNumbers = [];

  BingoBoard({required this.rows});

  void select(int number) {
    selectedNumbers.add(number);
  }

  bool get isWinner {
    // check rows
    for (final row in rows) {
      if (row.every(selectedNumbers.contains)) return true;
    }

    // check columns
    for (int i = 0; i < rows[0].length; i++) {
      if (rows.map((e) => e[i]).every(selectedNumbers.contains)) return true;
    }

    return false;
  }
}

class BingoInput {
  final List<int> draws;
  final List<BingoBoard> boards;

  int _drawIndex = 0;

  BingoInput({required this.draws, required this.boards});

  static BingoInput fromFile(String filePath) {
    final file = File(filePath);
    final lines = file.readAsLinesSync();
    return BingoInput.fromLines(lines);
  }

  static BingoInput fromLines(List<String> lines) {
    final drawLine = lines.removeAt(0);
    final draws = drawLine.split(',').map(int.parse).toList();

    // Remove the blank line following the draws
    lines.removeAt(0);

    var boards = <BingoBoard>[];
    while (lines.isNotEmpty) {
      final boardLines = lines.getRange(0, 5).toList();
      final boardRows = boardLines
          .map((line) => line
              .split(' ')
              .where((substring) => substring.isNotEmpty)
              .map(int.parse)
              .toList())
          .toList();
      boards.add(BingoBoard(rows: boardRows));

      if (lines.length < 6) break;
      lines.removeRange(0, 6);
    }

    return BingoInput(draws: draws, boards: boards);
  }

  void drawNext() {
    final drawValue = draws[_drawIndex];
    for (final board in boards) {
      board.select(drawValue);
    }

    _drawIndex++;
  }

  List<BingoBoard> get winners => boards.where((b) => b.isWinner).toList();
}

main() {
  final input = BingoInput.fromFile('input.txt');
  print(input);
}
