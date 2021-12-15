import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

List<List<int>> parseInput(String input) => input
    .split('\n')
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .map((e) => e.split('').map(int.parse).toList())
    .toList();

List<Point<int>> possibleNextPoints(
    List<List<int>> map, Point<int> currentPoint) {
  return [
    // if (currentPoint.x > 0) Point(currentPoint.x - 1, currentPoint.y),
    // if (currentPoint.y > 0) Point(currentPoint.x, currentPoint.y - 1),
    if (currentPoint.x < map[0].length - 1)
      Point(currentPoint.x + 1, currentPoint.y),
    if (currentPoint.y < map.length - 1)
      Point(currentPoint.x, currentPoint.y + 1),
  ];
}

int scorePath(Iterable<Point<int>> path, List<List<int>> map) =>
    path.skip(1).map((e) => map[e.y][e.x]).sum;

LinkedHashSet<Point<int>> findBestPath(List<List<int>> map) {
  final endPoint = Point(map[0].length - 1, map.length - 1);
  var openPaths = [LinkedHashSet<Point<int>>()];
  openPaths[0].add(Point(0, 0));
  var bestPath = LinkedHashSet<Point<int>>();
  var currentMin = 9999999;
  var scoreMap = <List<int>>[];
  for (int i = 0; i < map.length; i++) {
    scoreMap.add(List.filled(map.first.length, 999999));
  }

  // var firstPath = LinkedHashSet<Point<int>>();
  // for (int y = 1; y <= endPoint.y; y++) {}
  // for (int x = 1; x <= endPoint.x; x++) {}

  int i = 0;
  while (openPaths.isNotEmpty) {
    i++;
    if (i % 10000 == 0) {
      print('there are ${openPaths.length} open paths');
    }
    final currentPath = openPaths.last;
    openPaths.remove(currentPath);
    final currentPoint = currentPath.last;
    final possiblePoints = possibleNextPoints(map, currentPoint)
        .where((e) => !currentPath.contains(e));
    // print('possible points for $currentPoint are ${possiblePoints.toList()}');
    if (possiblePoints.isEmpty) {
      continue;
    }
    final newPaths = possiblePoints
        .map((e) => LinkedHashSet.of(currentPath.toList() + [e]))
        .toList();
    for (final path in newPaths) {
      final score = scorePath(path, map);
      final lastPoint = path.last;
      if (score >= currentMin) continue;

      if (scoreMap[lastPoint.y][lastPoint.x] <= score) {
        continue;
      }
      scoreMap[lastPoint.y][lastPoint.x] = score;

      if (path.last == endPoint) {
        currentMin = score;
        bestPath = path;
      } else {
        openPaths.add(path);
      }
    }
  }

  return bestPath;
}

List<List<int>> expandMap(List<List<int>> map) {
  var expandedMap = map.map((e) => e.map((e) => e).toList()).toList();
  // Add in the y dimension
  var nextTile = [...map];
  for (int i = 0; i < 4; i++) {
    nextTile = nextTile
        .map((e) => e.map((e) => e + 1 < 10 ? e + 1 : 1).toList())
        .toList();
    expandedMap.addAll(nextTile);
  }

  // Add in the x dimension
  for (int i = 0; i < expandedMap.length; i++) {
    var newRow = expandedMap[i];
    for (int j = 0; j < 4; j++) {
      newRow = newRow.map((e) => e + 1 < 10 ? e + 1 : 1).toList();
      expandedMap[i].addAll(newRow);
    }
  }

  return expandedMap;
}

main() {
  // Part 1
  final inputString = File('input.txt').readAsLinesSync().join('\n');
  final map = parseInput(inputString);
  final bestPath1 = findBestPath(map);
  final score1 = scorePath(bestPath1, map);
  print('score1 is $score1');

  // Part 2
  final expandedMap = expandMap(map);
  final bestPath2 = findBestPath(expandedMap);
  final score2 = scorePath(bestPath2, expandedMap);
  print('score2 is $score2');
}
