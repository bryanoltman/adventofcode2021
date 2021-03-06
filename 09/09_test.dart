import 'dart:math';

import 'package:collection/collection.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '09.dart';

main() {
  final heightMapString = '''
2199943210
3987894921
9856789892
8767896789
9899965678
''';

  late List<List<int>> heightMap;

  setUp(() {
    heightMap = parseHeightMap(heightMapString.split('\n'));
  });

  test('finds low points in map', () {
    final lowPoints = findLowPoints(heightMap);
    expect(lowPoints, hasLength(4));
    expect(lowPoints, contains(1));
    expect(lowPoints, contains(5));
    expect(lowPoints, contains(0));

    expect(lowPoints.map((e) => e + 1).sum, 15);
  });

  test('finds basins', () {
    final basins = findBasins(heightMap);
    expect(basins, hasLength(4));

    final basinLengths = basins.map((e) => e.length).toList()
      ..sort((a, b) => b.compareTo(a));
    final product = basinLengths[0] * basinLengths[1] * basinLengths[2];
    expect(product, 1134);
  });
}
