import 'package:test/test.dart';
import '05.dart';

main() {
  final inputString = '''0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2''';

  group(VentInput, () {
    test('deserializes from string', () {
      final input = VentInput.fromFileLines(inputString.split('\n'));
      expect(input.lines.first, Line(Coordinate(0, 9), Coordinate(5, 9)));
      expect(input.lines.last, Line(Coordinate(5, 5), Coordinate(8, 2)));
    });
  });

  group(VentMap, () {
    // Expected (with only horizontal and verical lines):
    // .......1..
    // ..1....1..
    // ..1....1..
    // .......1..
    // .112111211
    // ..........
    // ..........
    // ..........
    // ..........
    // 222111....
    // overlapCount: 5

    // Expected (with diagonal lines included):
    // 1.1....11.
    // .111...2..
    // ..2.1.111.
    // ...1.2.2..
    // .112313211
    // ...1.2....
    // ..1...1...
    // .1.....1..
    // 1.......1.
    // 222111....
    // overlapCount:

    late VentInput input;
    late VentMap map;

    setUp(() {
      input = VentInput.fromFileLines(inputString.split('\n'));
      map = VentMap(input);
    });

    group('heatmap', () {
      test('parses correctly', () {
        expect(map.heatmap, hasLength(10));
        for (final line in map.heatmap) {
          expect(line, hasLength(10));
        }

        final fifthLine = [0, 1, 1, 2, 3, 1, 3, 2, 1, 1];
        expect(map.heatmap[4], fifthLine);

        final lastLine = [2, 2, 2, 1, 1, 1, 0, 0, 0, 0];
        expect(map.heatmap.last, lastLine);
      });

      test('overlapCount', () {
        expect(map.overlapCount, 12);
      });
    });
  });
}
