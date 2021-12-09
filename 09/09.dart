import 'dart:io';

List<List<int>> parseHeightMap(List<String> lines) => lines
    .where((line) => !line.isEmpty)
    .map((line) => line.split('').map(int.parse).toList())
    .toList();

List<int> findLowPoints(List<List<int>> heightMap) {
  var lowPoints = <int>[];
  for (int y = 0; y < heightMap.length; y++) {
    for (int x = 0; x < heightMap[y].length; x++) {
      final point = heightMap[y][x];
      bool lowerThanAllAdjacentPoints = true;
      if (x > 0) {
        final adjacentPoint = heightMap[y][x - 1];
        if (point >= adjacentPoint) lowerThanAllAdjacentPoints = false;
      }
      if (x < heightMap[y].length - 1) {
        final adjacentPoint = heightMap[y][x + 1];
        if (point >= adjacentPoint) lowerThanAllAdjacentPoints = false;
      }
      if (y > 0) {
        final adjacentPoint = heightMap[y - 1][x];
        if (point >= adjacentPoint) lowerThanAllAdjacentPoints = false;
      }
      if (y < heightMap.length - 1) {
        final adjacentPoint = heightMap[y + 1][x];
        if (point >= adjacentPoint) lowerThanAllAdjacentPoints = false;
      }

      if (lowerThanAllAdjacentPoints) {
        lowPoints.add(point);
      }
    }
  }

  return lowPoints;
}

main() {
  final lines = File('input.txt').readAsLinesSync();
  final map = parseHeightMap(lines);
  final lowPoints = findLowPoints(map);
  final riskLevels = lowPoints.map((e) => e + 1);
  final riskLevelsSum = riskLevels.reduce((value, element) => value + element);
  print(riskLevelsSum);
}
