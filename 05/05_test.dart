import 'package:test/test.dart';
import '05.dart';

main() {
  group(VentInput, () {
    final stringValue = '''0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2''';

    test('deserializes from string', () {
      final input = VentInput.fromFileLines(stringValue.split('\n'));
      expect(input.lines.first, Line(Coordinate(0, 9), Coordinate(5, 9)));
      expect(input.lines.last, Line(Coordinate(5, 5), Coordinate(8, 2)));
    });
  });
}
