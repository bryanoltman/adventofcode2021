import 'dart:io';

import 'dart:math';

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

int distanceSumForPoint(List<int> positions, int point) => positions
    .map((e) => (e - point).abs())
    .reduce((value, element) => value + element);

main() {
  final lines = File('input.txt').readAsLinesSync();
  final positions = lines.first.split(',').map(int.parse).toList();
  final bestPoint = findBestPoint(positions);
  print('best point is $bestPoint');
  print('distance sum is ${distanceSumForPoint(positions, bestPoint)}');
}
