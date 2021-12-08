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
      expect(
        inputLine.inputs.map((e) => e.join()),
        [
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
        ],
      );
      expect(
        inputLine.outputs.map((e) => e.join()),
        ['cdfeb', 'fcadb', 'cdfeb', 'cdbaf'],
      );
    });

    test('displaySegmentMapping', () {
      final inputLine = InputLine(input);
      final mapping = inputLine.displaySegmentMapping;
      expect(mapping[DisplaySegment.top], 'd');
      expect(mapping[DisplaySegment.upperLeft], 'e');
      expect(mapping[DisplaySegment.upperRight], 'a');
      expect(mapping[DisplaySegment.center], 'f');
      expect(mapping[DisplaySegment.lowerRight], 'b');
      expect(mapping[DisplaySegment.lowerLeft], 'g');
      expect(mapping[DisplaySegment.bottom], 'c');
    });

    test('maps codes to ints', () {
      final inputLine = InputLine(input);
      // final expectedMapping = {
      //   'acedgfb': 8,
      //   'cdfbe': 5,
      //   'gcdfa': 2,
      //   'fbcad': 3,
      //   'dab': 7,
      //   'cefabd': 9,
      //   'cdfgeb': 6,
      //   'eafb': 4,
      //   'cagedb': 0,
      //   'ab': 1,
      // };

      expect(inputLine.numberForCharacterCode('cagedb'), 0);
      expect(inputLine.numberForCharacterCode('ab'), 1);
      expect(inputLine.numberForCharacterCode('gcdfa'), 2);
      expect(inputLine.numberForCharacterCode('fbcad'), 3);
      expect(inputLine.numberForCharacterCode('eafb'), 4);
      expect(inputLine.numberForCharacterCode('cdfbe'), 5);
      expect(inputLine.numberForCharacterCode('cdfgeb'), 6);
      expect(inputLine.numberForCharacterCode('dab'), 7);
      expect(inputLine.numberForCharacterCode('acedgfb'), 8);
      expect(inputLine.numberForCharacterCode('cefabd'), 9);
    });

    test('produces four-digit number from output', () {
      final inputLine = InputLine(input);
      expect(inputLine.outputValue, 5353);
    });
  });

  test('containsAll', () {
    expect([1, 2, 3].containsAll([3, 2, 1]), true);
    expect([1, 2, 3, 4].containsAll([3, 2, 1]), true);
    expect([1, 2, 3, 4].containsAll([3, 2, 1, 8]), false);
  });
}
