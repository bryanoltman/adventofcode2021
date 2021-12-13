import 'dart:math';

import 'package:test/test.dart';
import '13.dart';

main() {
  final inputString = '''
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
  ''';

  late Input input;

  setUp(() {
    input = Input(inputString);
  });

  test('parses input', () {
    expect(input.initialDotLocations, hasLength(18));

    expect(input.folds, hasLength(2));
    expect(input.folds[0].axis, Axis.y);
    expect(input.folds[0].point, 7);

    expect(input.folds[1].axis, Axis.x);
    expect(input.folds[1].point, 5);

    expect(input.dimensions, Point(11, 15));
  });

  test('folding', () {
    input.makeNextFold();
    expect(input.board[0], [
      true,
      false,
      true,
      true,
      false,
      false,
      true,
      false,
      false,
      true,
      false
    ]);

    input.makeNextFold();
    expect(input.board[0], [true, true, true, true, true]);
  });
}
