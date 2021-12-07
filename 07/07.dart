import 'dart:io';

import 'dart:math';

int distanceSumForPoint(List<int> positions, int point) => positions
    .map((e) => (e - point).abs())
    .reduce((value, element) => value + element);

int findBestPoint(List<int> positions) {
  final minValue = positions.reduce((value, element) => min(value, element));
  final maxValue = positions.reduce((value, element) => max(value, element));
  int bestPoint = 0;
  int minDistance = 100000000;
  for (int i = minValue; i < maxValue; i++) {
    final differenceSum = distanceSumForPoint(positions, i);
    if (differenceSum < minDistance) {
      minDistance = differenceSum;
      bestPoint = i;
    }
  }

  return bestPoint;
}

int distanceSumForPointPart2(List<int> positions, int point) {
  var sumDistance = 0;
  for (final position in positions) {
    var minPosition = min(position, point);
    var maxPosition = max(position, point);
    var currentPosition = minPosition;
    var distance = 0;
    for (int i = 1; currentPosition < maxPosition; i++) {
      distance += i;
      currentPosition++;
    }

    sumDistance += distance;
  }
  return sumDistance;
}

int findBestPointPart2(List<int> positions) {
  final minValue = positions.reduce((value, element) => min(value, element));
  final maxValue = positions.reduce((value, element) => max(value, element));
  int bestPoint = 0;
  int minDistance = 100000000;
  for (int i = minValue; i < maxValue; i++) {
    final differenceSum = distanceSumForPointPart2(positions, i);
    if (differenceSum < minDistance) {
      minDistance = differenceSum;
      bestPoint = i;
    }
  }

  return bestPoint;
}

main() {
  final lines = File('input.txt').readAsLinesSync();
  final positions = lines.first.split(',').map(int.parse).toList();
  final bestPoint = findBestPoint(positions);
  print('best point is $bestPoint');
  print('distance sum is ${distanceSumForPoint(positions, bestPoint)}');

  final bestPointPart2 = findBestPointPart2(positions);
  print('best point is $bestPointPart2');
  print(
      'distance sum is ${distanceSumForPointPart2(positions, bestPointPart2)}');
}
