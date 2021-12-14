import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '14.dart';

main() {
  final inputString = '''
      NNCB

      CH -> B
      HH -> N
      CB -> H
      NH -> C
      HB -> C
      HC -> B
      HN -> C
      NN -> C
      BH -> H
      NC -> B
      NB -> B
      BN -> B
      BB -> N
      BC -> B
      CC -> N
      CN -> C
  ''';

  late Input input;

  setUp(() {
    input = Input(inputString);
  });

  test('parses input', () {
    expect(input.template, 'NNCB');
    expect(input.patternsMap['HC'], 'B');
    expect(input.patternsMap['HB'], 'C');
    expect(input.patternsMap['CN'], 'C');
  });

  test('expands input', () {
    var expected = input.expand('NNCB');
    expect(expected, 'NCNBCHB');

    expected = input.expand('NCNBCHB');
    expect(expected, 'NBCCNBBBCBHCB');

    expected = input.expand('NBCCNBBBCBHCB');
    expect(expected, 'NBBBCNCCNBBNBNBBCHBHHBCHB');

    expected = input.expand('NBBBCNCCNBBNBNBBCHBHHBCHB');
    expect(expected, 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB');
  });

  test('generates char counts', () {
    var string = input.template;
    for (int i = 0; i < 10; i++) string = input.expand(string);
    final counts = input.characterCounts(string);
    expect(counts['B'], 1749);
    expect(counts['C'], 298);
    expect(counts['H'], 161);
    expect(counts['N'], 865);
  });

  test('generates counts map', () {
    var map = input.stringToCountsMap(input.template);
    // NNCB
    expect(map.pairCounts['NN'], 1);
    expect(map.pairCounts['NC'], 1);
    expect(map.pairCounts['CB'], 1);
  });

  test('expands counts map', () {
    var map = input.stringToCountsMap('BBB');
    var string = input.expand('BBB');
    // map = input.expandCountsMap(map);

    // // BNBBNB
    // expect(map['NB'], 2);
    // expect(map['BN'], 2);
    // expect(map['BB'], 1);

    map = input.stringToCountsMap('BBNCNC');
    string = input.expand('BBNCNC');
    final newMap = input.expandCountsMap(map);
    // BNBBNBCCNBC
    expect(newMap.pairCounts['BN'], 2);
    expect(newMap.pairCounts['NB'], 3);
    expect(newMap.pairCounts['BC'], 2);
    expect(newMap.pairCounts['CC'], 1);
    expect(newMap.pairCounts['CN'], 1);
    expect(newMap.pairCounts['BB'], 1);
    expect(newMap.pairCounts['NC'], 0);

    map = input.stringToCountsMap(input.template);
    expect(map.pairCounts['NN'], 1);
    expect(map.pairCounts['NC'], 1);
    expect(map.pairCounts['CB'], 1);
    final updatedMap = input.expandCountsMap(map);

    // NCNBCHB
    expect(updatedMap.pairCounts['NC'], 1);
    expect(updatedMap.pairCounts['CN'], 1);
    expect(updatedMap.pairCounts['NB'], 1);
    expect(updatedMap.pairCounts['BC'], 1);
    expect(updatedMap.pairCounts['CH'], 1);
    expect(updatedMap.pairCounts['HB'], 1);

    // NBCCNBBBCBHCB
    final updatedMap2 = input.expandCountsMap(updatedMap);
    expect(updatedMap2.pairCounts['NB'], 2);
    expect(updatedMap2.pairCounts['BC'], 2);
    expect(updatedMap2.pairCounts['CC'], 1);
    expect(updatedMap2.pairCounts['CN'], 1);
    expect(updatedMap2.pairCounts['BB'], 2);
    expect(updatedMap2.pairCounts['CB'], 2);
    expect(updatedMap2.pairCounts['BH'], 1);
    expect(updatedMap2.pairCounts['HC'], 1);

    expect(updatedMap2.pairCounts['NC'], 0);
    expect(updatedMap2.pairCounts['CH'], 0);
    expect(updatedMap2.pairCounts['HB'], 0);

    // NBBBCNCCNBBNBNBBCHBHHBCHB
    final updatedMap3 = input.expandCountsMap(updatedMap2);
    expect(updatedMap3.pairCounts['NB'], 4);
    expect(updatedMap3.pairCounts['BB'], 4);
    expect(updatedMap3.pairCounts['BC'], 3);
    expect(updatedMap3.pairCounts['CN'], 2);
    expect(updatedMap3.pairCounts['NC'], 1);
    expect(updatedMap3.pairCounts['CC'], 1);
    expect(updatedMap3.pairCounts['BN'], 2);
    expect(updatedMap3.pairCounts['CH'], 2);
    expect(updatedMap3.pairCounts['HB'], 3);
    expect(updatedMap3.pairCounts['BH'], 1);
    expect(updatedMap3.pairCounts['HH'], 1);

    expect(updatedMap3.pairCounts['CB'], 0);
    expect(updatedMap3.pairCounts['HC'], 0);
  });

  test('computes character counts', () {
    final map = input.stringToCountsMap('BBNCNC');
    expect(map.letterCounts['B'], 2);
    expect(map.letterCounts['N'], 2);
    expect(map.letterCounts['C'], 2);
  });
}
