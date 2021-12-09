import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

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

var seenCoordinates = <Point>{};

List<Point<int>> findAdjacentBasinCoords(
  List<List<int>> heightMap,
  Point<int> coordinate,
) {
  if (seenCoordinates.contains(coordinate)) return [];
  seenCoordinates.add(coordinate);

  final height = heightMap[coordinate.y][coordinate.x];
  if (height == 9) return [];

  var coords = [coordinate];
  if (coordinate.x > 0) {
    final nextCoord = Point(coordinate.x - 1, coordinate.y);
    coords.addAll(findAdjacentBasinCoords(heightMap, nextCoord));
  }
  if (coordinate.x < heightMap[coordinate.y].length - 1) {
    final nextCoord = Point(coordinate.x + 1, coordinate.y);
    coords.addAll(findAdjacentBasinCoords(heightMap, nextCoord));
  }
  if (coordinate.y > 0) {
    final nextCoord = Point(coordinate.x, coordinate.y - 1);
    coords.addAll(findAdjacentBasinCoords(heightMap, nextCoord));
  }
  if (coordinate.y < heightMap.length - 1) {
    final nextCoord = Point(coordinate.x, coordinate.y + 1);
    coords.addAll(findAdjacentBasinCoords(heightMap, nextCoord));
  }

  return coords;
}

List<List<Point>> findBasins(List<List<int>> heightMap) {
  var basins = <List<Point>>[];
  for (int y = 0; y < heightMap.length; y++) {
    for (int x = 0; x < heightMap[y].length; x++) {
      basins.add(findAdjacentBasinCoords(heightMap, Point(x, y)));
    }
  }

  return basins.where((e) => !e.isEmpty).toList();
}

main() {
  final lines = File('input.txt').readAsLinesSync();
  final map = parseHeightMap(lines);
  final lowPoints = findLowPoints(map);
  final riskLevels = lowPoints.map((e) => e + 1);
  final riskLevelsSum = riskLevels.sum;
  print(riskLevelsSum);

  final basins = findBasins(map);
  final basinLengths = basins.map((e) => e.length).toList()
    ..sort((a, b) => b.compareTo(a));
  final product = basinLengths[0] * basinLengths[1] * basinLengths[2];
  print('product is $product');
}
