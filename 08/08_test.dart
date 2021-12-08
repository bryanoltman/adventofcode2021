import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '08.dart';

main() {
  final input = 'acedgfb cdfbe gcdfa fbcad dab cefabd '
      'cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf';

  group(InputLine, () {
    test('parses line', () {
      final inputLine = InputLine(input);
      expect(inputLine.inputs, hasLength(10));
      expect(inputLine.outputs, hasLength(4));
      expect(inputLine.inputs, [
        'acedgfb',
        'cdfbe',
        'gcdfa',
        'fbcad',
        'dab',
        'cefabd',
        'cdfgeb',
        'eafb',
        'cagedb',
        'ab',
      ]);
      expect(inputLine.outputs, ['cdfeb', 'fcadb', 'cdfeb', 'cdbaf']);
    });
  });
}
