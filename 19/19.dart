import 'dart:io';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

typedef Rotation = Vector3 Function(Vector3);

final rotations = <Rotation>[
  // ([x, y, z]) => [x, y, z],
  (Vector3 v) => Vector3(v.x, v.y, v.z),

  // ([x, y, z]) => [y, z, x],
  (Vector3 v) => Vector3(v.y, v.z, v.x),

  // ([x, y, z]) => [z, x, y],
  (Vector3 v) => Vector3(v.z, v.x, v.y),

  // ([x, y, z]) => [-x, z, y],
  (Vector3 v) => Vector3(-v.x, v.z, v.y),

  // ([x, y, z]) => [z, y, -x],
  (Vector3 v) => Vector3(v.z, v.y, -v.x),

  // ([x, y, z]) => [y, -x, z],
  (Vector3 v) => Vector3(v.y, -v.x, v.z),

  // ([x, y, z]) => [x, z, -y],
  (Vector3 v) => Vector3(v.x, v.z, -v.y),

  // ([x, y, z]) => [z, -y, x],
  (Vector3 v) => Vector3(v.z, -v.y, v.x),

  // ([x, y, z]) => [-y, x, z],
  (Vector3 v) => Vector3(-v.y, v.x, v.z),

  // ([x, y, z]) => [x, -z, y],
  (Vector3 v) => Vector3(v.x, -v.z, v.y),

  // ([x, y, z]) => [-z, y, x],
  (Vector3 v) => Vector3(-v.z, v.y, v.x),

  // ([x, y, z]) => [y, x, -z],
  (Vector3 v) => Vector3(v.y, v.x, -v.z),

  // ([x, y, z]) => [-x, -y, z],
  (Vector3 v) => Vector3(-v.x, -v.y, v.z),

  // ([x, y, z]) => [-y, z, -x],
  (Vector3 v) => Vector3(-v.y, v.z, -v.x),

  // ([x, y, z]) => [z, -x, -y],
  (Vector3 v) => Vector3(v.z, -v.x, -v.y),

  // ([x, y, z]) => [-x, y, -z],
  (Vector3 v) => Vector3(-v.x, v.y, -v.z),

  // ([x, y, z]) => [y, -z, -x],
  (Vector3 v) => Vector3(v.y, -v.z, -v.x),

  // ([x, y, z]) => [-z, -x, y],
  (Vector3 v) => Vector3(-v.z, -v.x, v.y),

  // ([x, y, z]) => [x, -y, -z],
  (Vector3 v) => Vector3(v.x, -v.y, -v.z),

  // ([x, y, z]) => [-y, -z, x],
  (Vector3 v) => Vector3(-v.y, -v.z, v.x),

  // ([x, y, z]) => [-z, x, -y],
  (Vector3 v) => Vector3(-v.z, v.x, -v.y),

  // ([x, y, z]) => [-x, -z, -y],
  (Vector3 v) => Vector3(-v.x, -v.z, -v.y),

  // ([x, y, z]) => [-z, -y, -x],
  (Vector3 v) => Vector3(-v.z, -v.y, -v.x),

  // ([x, y, z]) => [-y, -x, -z],
  (Vector3 v) => Vector3(-v.y, -v.x, -v.z),
];

class Scanner {
  List<Vector3> readings;

  Scanner(this.readings);
}

class Placement {
  // Rotation relative to the "true" scanner position
  final Rotation rotation;

  // Position relative to the "true" scanner position
  final Vector3 position;

  Placement(this.rotation, this.position);
}

List<Scanner> parseScanners(List<String> input) {
  var scanners = <Scanner>[];
  var currentReadings = <Vector3>[];
  for (int i = 0; i < input.length; i++) {
    final line = input[i].trim();

    if (line.isEmpty) continue;

    if (line.startsWith('---')) {
      // We've hit a new scanner
      if (currentReadings.isNotEmpty) {
        scanners.add(Scanner(currentReadings));
        currentReadings = [];
      }
    } else {
      final points = line.split(',').map(double.parse).toList();
      final reading = Vector3(points[0], points[1], points[2]);
      currentReadings.add(reading);
    }
  }

  if (currentReadings.isNotEmpty) {
    scanners.add(Scanner(currentReadings));
    currentReadings = [];
  }

  return scanners;
}

Map<Scanner, Placement> placeScanners(List<Scanner> scanners) {
  var knownScanners = {scanners[0]: Placement(rotations[0], Vector3.zero())};
  while (knownScanners.keys.length < scanners.length) {
    for (final unplaced
        in scanners.where((e) => !knownScanners.containsKey(e))) {
      final placement = placementForScanner(unplaced, knownScanners);
      if (placement != null) {
        knownScanners[unplaced] = placement;
      }
    }
  }
  return knownScanners;
}

Placement? placementForScanner(
  Scanner scanner,
  Map<Scanner, Placement> placedScanners,
) {
  for (final placedScanner in placedScanners.keys) {
    final placement = placedScanners[placedScanner]!;
    final placedReadings = placedScanner.readings
        .map(placement.rotation)
        .map((e) => e + placement.position);

    for (final rotation in rotations) {
      var distanceCounts = <Vector3, int>{};
      for (final rotatedUnplacedReading in scanner.readings.map(rotation)) {
        for (final placedReading in placedReadings) {
          final distance =
              positionDifference(placedReading, rotatedUnplacedReading);
          distanceCounts[distance] = (distanceCounts[distance] ?? 0) + 1;
          if (distanceCounts[distance]! == 12) {
            return Placement(rotation, distance);
          }
        }
      }
    }
  }

  return null;
}

Set<Vector3> beaconPositions(Map<Scanner, Placement> placedScanners) =>
    placedScanners.entries
        .map(
          (e) => e.key.readings
              .map(e.value.rotation)
              .map((reading) => reading + e.value.position),
        )
        .expand((e) => e)
        .toSet();

Vector3 positionDifference(Vector3 a, Vector3 b) =>
    Vector3(a.x - b.x, a.y - b.y, a.z - b.z);

double manhattanDistance(Vector3 a, Vector3 b) =>
    (a.x - b.x).abs() + (a.y - b.y).abs() + (a.z - b.z).abs();

double greatestManhattanDistance(List<Vector3> positions) {
  double maxDistance = 0;
  for (int i = 0; i < positions.length; i++) {
    for (int j = 0; j < positions.length; j++) {
      if (i == j) continue;
      final distance = manhattanDistance(positions[i], positions[j]);
      maxDistance = max(distance, maxDistance);
    }
  }

  return maxDistance;
}

main() {
  // Part 1
  final scanners = parseScanners(File('input.txt').readAsLinesSync());
  final placedScanners = placeScanners(scanners);
  final beacons = beaconPositions(placedScanners);
  print('there are ${beacons.length} beacons');

  // Part 2
  final scannerPositions =
      placedScanners.values.map((e) => e.position).toList();
  final maxDistance = greatestManhattanDistance(scannerPositions);
  print('max distance is $maxDistance');
}
