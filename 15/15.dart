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

List<Point<int>> possibleNextPoints(
    List<List<int>> map, Point<int> currentPoint) {
  return [
    if (currentPoint.x > 0) Point(currentPoint.x - 1, currentPoint.y),
    if (currentPoint.y > 0) Point(currentPoint.x, currentPoint.y - 1),
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

  while (openPaths.isNotEmpty) {
    final currentPath = openPaths.last;
    openPaths.remove(currentPath);
    final currentPoint = currentPath.last;
    final possiblePoints = possibleNextPoints(map, currentPoint)
        .where((e) => !currentPath.contains(e));
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

// Find the least expensive path from (0,0) to (width-1, height-1) using dijkstra
int bestPathToEndCost(List<List<int>> map) {
  final endPoint = Point(map[0].length - 1, map.length - 1);
  var distanceMap = <Point<int>, int>{};
  // A reverse priority queue
  var queue = PriorityQueue<Point<int>>(
      (a, b) => distanceMap[a]!.compareTo(distanceMap[b]!));

  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map.first.length; x++) {
      final point = Point(x, y);
      if (x == 0 && y == 0) {
        distanceMap[point] = 0;
      } else {
        distanceMap[point] = 9999999999;
      }
      queue.add(point);
    }
  }

  queue.addAll(distanceMap.keys);
  while (queue.isNotEmpty) {
    final currentPoint = queue.removeFirst();
    final currentPointDistance = distanceMap[currentPoint]!;
    final possiblePoints = possibleNextPoints(map, currentPoint);
    for (final neighbor in possiblePoints) {
      final maybeNewDistance =
          currentPointDistance + map[neighbor.y][neighbor.x];
      if (maybeNewDistance < distanceMap[neighbor]!) {
        distanceMap[neighbor] = maybeNewDistance;

        // Required to rebalance queue
        queue.remove(neighbor);
        queue.add(neighbor);
      }
    }
  }

  return distanceMap[endPoint]!;
}

main() {
  // Part 1
  final inputString = File('input.txt').readAsLinesSync().join('\n');
  final map = parseInput(inputString);
  final score1 = bestPathToEndCost(map);
  print('score1 is $score1');

  // Part 2
  final expandedMap = expandMap(map);
  final score2 = bestPathToEndCost(expandedMap);
  print('score2 is $score2');
}
