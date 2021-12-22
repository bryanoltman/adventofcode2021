import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';

// Inclusive bounds of cube size
const initializationLowerBound = -50;
const initializationUpperBound = 50;

class Range {
  final Tuple2<int, int> _backing;
  int get start => _backing.item1;
  int get end => _backing.item2;

  // +1 because ranges are inclusive here
  int get length => end - start + 1;

  Range(int start, int end)
      : _backing = Tuple2(
          min(start, end),
          max(start, end),
        );

  @override
  operator ==(Object other) => other is Range && other._backing == _backing;

  @override
  int get hashCode => _backing.hashCode;

  @override
  String toString() => '($start,$end)';

  bool overlapsWith(Range otherRange) {
    return (start <= otherRange.start && end >= otherRange.end) ||
        (otherRange.start <= start && otherRange.end >= end) ||
        (start <= otherRange.start && end >= otherRange.start) ||
        (start <= otherRange.end && end >= otherRange.end) ||
        start == otherRange.end ||
        end == otherRange.start;
  }

  Range? intersectionWith(Range otherRange) {
    if (!overlapsWith(otherRange)) return null;

    return Range(max(start, otherRange.start), min(end, otherRange.end));
  }
}

class Range3D {
  final Range xRange;
  final Range yRange;
  final Range zRange;

  int get volume => xRange.length * yRange.length * zRange.length;

  Range3D({required this.xRange, required this.yRange, required this.zRange});

  bool overlapsWith(Range3D otherRange) {
    return xRange.overlapsWith(otherRange.xRange) &&
        yRange.overlapsWith(otherRange.yRange) &&
        zRange.overlapsWith(otherRange.zRange);
  }

  Range3D? intersectionWith(Range3D otherRange) {
    if (!overlapsWith(otherRange)) return null;
    return Range3D(
      xRange: otherRange.xRange.intersectionWith(xRange)!,
      yRange: otherRange.yRange.intersectionWith(yRange)!,
      zRange: otherRange.zRange.intersectionWith(zRange)!,
    );
  }

  @override
  String toString() =>
      '${xRange.toString()},${yRange.toString()},${zRange.toString()}';
}

class Command {
  final bool turnOn;
  final Range3D range;

  Command({
    required this.turnOn,
    required Range xRange,
    required Range yRange,
    required Range zRange,
  }) : range = Range3D(xRange: xRange, yRange: yRange, zRange: zRange);

  Command.withRange3D({required this.turnOn, required this.range});

  // Build cubes for Part 1
  List<Vector3> cubesForInitializationRanges() {
    var cubes = <Vector3>[];
    for (int x = range.xRange.start; x <= range.xRange.end; x++) {
      if (x < initializationLowerBound || x > initializationUpperBound) {
        continue;
      }
      for (int y = range.yRange.start; y <= range.yRange.end; y++) {
        if (y < initializationLowerBound || y > initializationUpperBound) {
          continue;
        }
        for (int z = range.zRange.start; z <= range.zRange.end; z++) {
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

Range parseRangeString(String range) {
  final rangeEnds = range.split('=')[1].split('..').map(int.parse).toList();
  return Range(rangeEnds[0], rangeEnds[1]);
}

Command parseLine(String line) {
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

int onVolumeAfterCommands(List<Command> commands) {
  List<Command> processedCommands = [];
  for (final command in commands) {
    List<Command> updatedProcessedList = [];
    for (final processedCommand in processedCommands) {
      updatedProcessedList.add(processedCommand);

      final intersection =
          processedCommand.range.intersectionWith(command.range);
      if (intersection != null) {
        bool isIntersectionOn;
        if (processedCommand.turnOn == command.turnOn) {
          // We need to negate the intersecting volume of
          // two on|off commands
          isIntersectionOn = !command.turnOn;
        } else if (processedCommand.turnOn) {
          // We're turning off a subset of an on command
          isIntersectionOn = false;
        } else /* command.turnOn */ {
          // We're turning on a subset of an off command
          isIntersectionOn = true;
        }
        updatedProcessedList.add(
          Command.withRange3D(
            turnOn: isIntersectionOn,
            range: intersection,
          ),
        );
      }
    }

    if (command.turnOn) {
      // Only add this command to the list if it's an on command – we've already
      // accounted for off commands in the loop above.
      updatedProcessedList.add(command);
    }

    processedCommands = updatedProcessedList;
  }

  return processedCommands
      .map((e) => e.turnOn ? e.range.volume : -e.range.volume)
      .sum;
}

main() {
  final commands = parseInput(File('input.txt').readAsLinesSync());

  // Part 1
  final cubeStates = cubeStatesAfterCommands(commands);
  final onCubes = cubeStates.keys.where((e) => cubeStates[e] == true);
  print('there are ${onCubes.length} on cubes');

  // Part 2
  final volume = onVolumeAfterCommands(commands);
  print('there are $volume on cubes');
}
