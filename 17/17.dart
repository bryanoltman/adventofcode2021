import 'dart:math';

Rectangle parseTargetString(String string) {
  string = string.replaceFirst('target area: ', '');
  final parts = string.split(',');

  final xRange = parts[0].split('=').last.split('..').map(int.parse).toList();
  final xStart = xRange[0];
  final xEnd = xRange[1];

  final yRange = parts[1].split('=').last.split('..').map(int.parse).toList();
  final yStart = yRange[0];
  final yEnd = yRange[1];

  return Rectangle(xStart, yStart, xEnd - xStart, yEnd - yStart);
}

List<Point<int>> fireProbe({
  required Point<int> velocity,
  required Rectangle target,
}) {
  const startingPoint = Point(0, 0);
  var points = <Point<int>>[startingPoint];

  while (points.last.x < target.right && points.last.y > target.top) {
    final lastPoint = points.last;

    if (target.containsPoint(lastPoint)) {
      break;
    }

    // Step forward with another point:
    // The probe's x position increases by its x velocity.
    // The probe's y position increases by its y velocity.
    // Due to drag, the probe's x velocity changes by 1 toward the value 0;
    //    that is, it decreases by 1 if it is greater than 0, increases by 1
    //    if it is less than 0, or does not change if it is already 0.
    // Due to gravity, the probe's y velocity decreases by 1.

    var nextPoint = Point(lastPoint.x + velocity.x, lastPoint.y + velocity.y);
    velocity = Point(max(velocity.x - 1, 0), velocity.y - 1);
    points.add(nextPoint);
  }

  return points;
}

Point<int> findBestVelocityForTarget(Rectangle target) {
  var maxY = -9999;
  var bestVelocity = Point(0, 0);
  for (int x = 0; x < 500; x++) {
    for (int y = 0; y < 500; y++) {
      final velocity = Point(x, y);
      final path = fireProbe(velocity: velocity, target: target);
      final isHit = target.containsPoint(path.last);
      if (!isHit) {
        continue;
      }

      final currentMaxY = path.map((e) => e.y).reduce((acc, e) => max(acc, e));
      if (currentMaxY > maxY) {
        maxY = currentMaxY;
        bestVelocity = velocity;
      }
    }
  }
  return bestVelocity;
}

List<Point<int>> findAllHittingVelocities({required Rectangle target}) {
  var allVelocities = <Point<int>>[];
  for (int x = -300; x < 500; x++) {
    for (int y = -300; y < 500; y++) {
      final velocity = Point(x, y);
      final points = fireProbe(velocity: velocity, target: target);
      if (target.containsPoint(points.last)) {
        allVelocities.add(velocity);
      }
    }
  }
  return allVelocities;
}

main() {
  final input = 'target area: x=206..250, y=-105..-57';
  final targetRect = parseTargetString(input);

  // Part 1
  final bestVelocity = findBestVelocityForTarget(targetRect);
  print('best velocity is $bestVelocity');
  final path = fireProbe(velocity: bestVelocity, target: targetRect);
  final highestY = path.map((e) => e.y).reduce((acc, e) => max(acc, e));
  print('highestY is $highestY');

  // Part 2
  final hittingVelocities = findAllHittingVelocities(target: targetRect);
  print('there are ${hittingVelocities.length} velocities');
}
