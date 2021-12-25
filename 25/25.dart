import 'dart:io';

import 'package:collection/collection.dart';

typedef FloorMap = List<List<String>>;

FloorMap parseFloorMap(List<String> lines) => lines
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .map((e) => e.split(''))
    .toList();

FloorMap copy(FloorMap floorMap) => floorMap.map((e) => [...e]).toList();

FloorMap move(FloorMap floorMap) {
  var newMap = copy(floorMap);
  newMap = moveEast(newMap);
  newMap = moveSouth(newMap);
  return newMap;
}

FloorMap moveEast(FloorMap floorMap) {
  var newMap = copy(floorMap);

  for (int y = 0; y < floorMap.length; y++) {
    for (int x = 0; x < floorMap[y].length; x++) {
      final spot = floorMap[y][x];
      if (spot != '>') continue;
      final nextSpot = x + 1 == floorMap[y].length ? 0 : x + 1;
      final nextSpotOccupant = floorMap[y][nextSpot];
      if (nextSpotOccupant != '.') continue;
      newMap[y][x] = '.';
      newMap[y][nextSpot] = '>';
    }
  }
  return newMap;
}

FloorMap moveSouth(FloorMap floorMap) {
  var newMap = copy(floorMap);
  for (int y = 0; y < floorMap.length; y++) {
    for (int x = 0; x < floorMap[y].length; x++) {
      final spot = floorMap[y][x];
      if (spot != 'v') continue;
      final nextSpot = y + 1 == floorMap.length ? 0 : y + 1;
      final nextSpotOccupant = floorMap[nextSpot][x];
      if (nextSpotOccupant != '.') continue;
      newMap[y][x] = '.';
      newMap[nextSpot][x] = 'v';
    }
  }
  return newMap;
}

bool areMapsEqual(FloorMap first, FloorMap second) {
  final iterable = IterableZip([first, second]);
  return iterable.every((e) => e[0].equals(e[1]));
}

int movesUntilSettled(FloorMap floorMap) {
  var runningMap = copy(floorMap);
  for (int i = 0;; i++) {
    final newMap = move(runningMap);
    if (areMapsEqual(newMap, runningMap)) return i + 1;
    runningMap = newMap;
  }
}

main() {
  final inputMap = parseFloorMap(File('input.txt').readAsLinesSync());
  final movesCount = movesUntilSettled(inputMap);
  print('$movesCount until settled');
}
