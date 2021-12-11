import 'dart:math';

List<List<int>> parseInput(String input) {
  return input
      .split('\n')
      .map((e) => e.trim())
      .where((element) => element.isNotEmpty)
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
}

void printBoard(List<List<int>> board) => board
    .map((e) => e.map((e) => e.toString()).join(' '))
    .forEach((e) => print(e));

void incrementAtCoordIfPossible(List<List<int>> board, Point<int> point) {
  if (point.x < 0) return;
  if (point.y < 0) return;
  if (point.y >= board.length) return;
  if (point.x >= board[point.y].length) return;

  board[point.y][point.x] += 1;
}

List<List<int>> advanceToNextStep(List<List<int>> board) {
  var newBoard = board;
  for (int y = 0; y < newBoard.length; y++) {
    for (int x = 0; x < newBoard[y].length; x++) {
      newBoard[y][x] += 1;
    }
  }

  var flashingPoints = <Point<int>>{};
  var shouldContinue = true;
  while (shouldContinue) {
    shouldContinue = false;
    for (int y = 0; y < newBoard.length; y++) {
      for (int x = 0; x < newBoard[y].length; x++) {
        if (newBoard[y][x] > 9 && !flashingPoints.contains(Point(x, y))) {
          shouldContinue = true;
          flashingPoints.add(Point(x, y));
          incrementAtCoordIfPossible(newBoard, Point(x - 1, y - 1));
          incrementAtCoordIfPossible(newBoard, Point(x - 1, y));
          incrementAtCoordIfPossible(newBoard, Point(x - 1, y + 1));

          incrementAtCoordIfPossible(newBoard, Point(x, y - 1));
          incrementAtCoordIfPossible(newBoard, Point(x, y));
          incrementAtCoordIfPossible(newBoard, Point(x, y + 1));

          incrementAtCoordIfPossible(newBoard, Point(x + 1, y - 1));
          incrementAtCoordIfPossible(newBoard, Point(x + 1, y));
          incrementAtCoordIfPossible(newBoard, Point(x + 1, y + 1));
        }
      }
    }
  }

  for (final point in flashingPoints) {
    newBoard[point.y][point.x] = 0;
  }

  return newBoard;
}

int flashCount(List<List<int>> board) =>
    board.expand((e) => e).where((e) => e == 0).length;

main() {
  final input = '''
6111821767
1763611615
3512683131
8582771473
8214813874
2325823217
2222482823
5471356782
3738671287
8675226574
  ''';
  var board = parseInput(input);

  var flashes = 0;
  for (var i = 0; i < 100; i++) {
    board = advanceToNextStep(board);
    flashes += flashCount(board);
  }
  print('got $flashes flashes');

  board = parseInput(input);
  for (var i = 0; i < 250; i++) {
    board = advanceToNextStep(board);
    if (board.expand((e) => e).where((e) => e != 0).isEmpty) {
      print('flashed at ${i + 1}');
    }
  }
}
