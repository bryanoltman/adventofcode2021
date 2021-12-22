import 'dart:io';

import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';

// Inclusive bounds of cube size
const initializationLowerBound = -50;
const initializationUpperBound = 50;

class Command {
  final bool turnOn;
  final Tuple2<int, int> xRange;
  final Tuple2<int, int> yRange;
  final Tuple2<int, int> zRange;

  Command({
    required this.turnOn,
    required this.xRange,
    required this.yRange,
    required this.zRange,
  });

  List<Vector3> cubesForInitializationRanges() {
    var cubes = <Vector3>[];
    for (int x = xRange.item1; x <= xRange.item2; x++) {
      if (x < initializationLowerBound || x > initializationUpperBound) {
        continue;
      }
      for (int y = yRange.item1; y <= yRange.item2; y++) {
        if (y < initializationLowerBound || y > initializationUpperBound) {
          continue;
        }
        for (int z = zRange.item1; z <= zRange.item2; z++) {
          if (z < initializationLowerBound || z > initializationUpperBound) {
            continue;
          }
          cubes.add(Vector3(x.toDouble(), y.toDouble(), z.toDouble()));
        }
      }
    }
    return cubes;
  }
}

Tuple2<int, int> parseRangeString(String range) {
  final rangeEnds = range.split('=')[1].split('..').map(int.parse).toList();
  return Tuple2(rangeEnds[0], rangeEnds[1]);
}

Command parseLine(String line) {
  // Example commands:
  // on x=10..12,y=10..12,z=10..12
  // on x=11..13,y=11..13,z=11..13
  // off x=9..11,y=9..11,z=9..11
  // on x=10..10,y=10..10,z=10..10

  final parts = line.split(' ');
  final ranges = parts[1].split(',');

  return Command(
    turnOn: parts[0] == 'on',
    xRange: parseRangeString(ranges[0]),
    yRange: parseRangeString(ranges[1]),
    zRange: parseRangeString(ranges[2]),
  );
}

List<Command> parseInput(List<String> lines) => lines
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .map(parseLine)
    .toList();

Map<Vector3, bool> cubeStatesAfterCommands(List<Command> commands) {
  var states = <Vector3, bool>{};
  for (final command in commands) {
    for (final cube in command.cubesForInitializationRanges()) {
      states[cube] = command.turnOn;
    }
  }
  return states;
}

main() {
  final commands = parseInput(File('input.txt').readAsLinesSync());

  // Part 1
  final cubeStates = cubeStatesAfterCommands(commands);
  final onCubes = cubeStates.keys.where((e) => cubeStates[e] == true);
  print('there are ${onCubes.length} on cubes');
}
