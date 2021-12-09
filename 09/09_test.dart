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

    expect(lowPoints.map((e) => e + 1).reduce((v, e) => v + e), 15);
  });
}
