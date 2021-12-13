import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

enum Axis { x, y }

class Fold {
  late final Axis axis;
  late final int point;

  Fold(String string) {
    point = int.parse(string.split('=')[1]);
    axis = string.split('=')[0].endsWith('x') ? Axis.x : Axis.y;
  }
}

class Input {
  late final List<Point<int>> initialDotLocations;
  late final List<Fold> folds;
  late List<List<bool>> board;
  int _foldIndex = 0;

  Point<int> get dimensions => Point<int>(
        initialDotLocations.map((e) => e.x).reduce((v, e) => max(v, e)) + 1,
        initialDotLocations.map((e) => e.y).reduce((v, e) => max(v, e)) + 1,
      );

  Input(String input) {
    final lines = input
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final foldIndex = lines.indexOf(
      lines.firstWhere((e) => e.startsWith('fold')),
    );
    initialDotLocations = lines
        .slice(0, foldIndex)
        .map(
          (e) => Point(int.parse(e.split(',')[0]), int.parse(e.split(',')[1])),
        )
        .toList();
    folds = lines.slice(foldIndex).map((e) => Fold(e)).toList();
    board = <List<bool>>[];
    for (int y = 0; y < dimensions.y; y++) {
      board.add(List.filled(dimensions.x, false, growable: true));
      for (int x = 0; x < dimensions.x; x++) {
        board[y][x] = initialDotLocations.contains(Point(x, y));
      }
    }

    printBoard();
  }

  void printBoard() {
    final stringValue =
        board.map((e) => e.map((e) => e ? '#' : '.').join()).join('\n');
    print(stringValue);
  }

  bool dotAtPointOrFalse(Point<int> point, List<List<bool>> currentBoard) {
    if (point.y >= currentBoard.length) return false;
    if (point.x >= currentBoard[point.y].length) return false;
    return currentBoard[point.y][point.x];
  }

  void makeNextFold() {
    final fold = folds[_foldIndex];
    print('folding at ${fold.axis} ${fold.point}');
    switch (fold.axis) {
      case Axis.x:
        for (int y = 0; y < board.length; y++) {
          for (int x = fold.point + 1;
              x < board.last.length && fold.point - (x - fold.point) >= 0;
              x++) {
            final postfoldX = x;
            final prefoldX = fold.point - (x - fold.point);
            board[y][prefoldX] = board[y][prefoldX] || board[y][postfoldX];
          }
          board[y].removeRange(fold.point, board[y].length);
        }
        break;
      case Axis.y:
        for (int y = fold.point + 1;
            y < board.length && fold.point - (y - fold.point) >= 0;
            y++) {
          final postfoldY = y;
          final prefoldY = fold.point - (y - fold.point);
          for (int x = 0; x < board.first.length; x++) {
            board[prefoldY][x] = board[postfoldY][x] || board[prefoldY][x];
          }
        }

        board.removeRange(fold.point, board.length);
        break;
    }

    print('after fold at $_foldIndex');
    printBoard();
    _foldIndex++;
  }
}

main() {
  final input = Input(File('input.txt').readAsLinesSync().join('\n'));
  input.makeNextFold();
  var numDots = input.board.expand((e) => e).where((e) => e).length;
  print('numDots $numDots');
  for (int i = 0; i < input.folds.length - 1; i++) {
    input.makeNextFold();
  }
  numDots = input.board.expand((e) => e).where((e) => e).length;
  print('numDots $numDots');
}
