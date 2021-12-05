import 'dart:io';

import 'dart:math';

class Coordinate {
  late int x;
  late int y;

  Coordinate(this.x, this.y);

  Coordinate.fromString(String string) {
    final parts = string.split(',');
    x = int.parse(parts[0]);
    y = int.parse(parts[1]);
  }

  @override
  bool operator ==(Object other) =>
      other is Coordinate && other.x == x && other.y == y;
}

class Line {
  final Coordinate startCoordinate;
  final Coordinate endCoordinate;

  Line(this.startCoordinate, this.endCoordinate);

  bool get isHorizontal => startCoordinate.y == endCoordinate.y;

  bool get isVertical => startCoordinate.x == endCoordinate.x;

  @override
  bool operator ==(Object other) =>
      other is Line &&
      other.startCoordinate == startCoordinate &&
      other.endCoordinate == endCoordinate;
}

class VentInput {
  final List<Line> lines;

  VentInput(this.lines);

  static VentInput fromFile(String filename) {
    final file = File(filename);
    final lines = file.readAsLinesSync();
    return VentInput.fromFileLines(lines);
  }

  static VentInput fromFileLines(List<String> fileLines) {
    final lines = fileLines.map((line) {
      final parts = line.split('->');
      final start = Coordinate.fromString(parts[0]);
      final end = Coordinate.fromString(parts[1]);
      return Line(start, end);
    }).toList();
    return VentInput(lines);
  }
}

class VentMap {
  final VentInput input;
  final List<List<int>> heatmap;

  VentMap(this.input) : heatmap = VentMap.generateHeatmap(input);

  static List<List<int>> generateHeatmap(VentInput input) {
    final startCoords = input.lines.map((e) => e.startCoordinate).toList();
    final endCoords = input.lines.map((e) => e.endCoordinate).toList();
    final allCoords = startCoords + endCoords;
    final maxXCoord = allCoords
        .map((e) => e.x)
        .reduce((value, element) => max(value, element));
    final maxYCoord = allCoords
        .map((e) => e.y)
        .reduce((value, element) => max(value, element));

    var heatmap =
        List.generate(maxYCoord + 1, (_) => List.filled(maxXCoord + 1, 0));

    for (final line in input.lines) {
      var x = line.startCoordinate.x;
      var y = line.startCoordinate.y;
      for (var i = 0;
          !(x == line.endCoordinate.x && y == line.endCoordinate.y);
          i++) {
        heatmap[y][x]++;
        if (line.startCoordinate.x > line.endCoordinate.x) {
          x--;
        } else if (line.startCoordinate.x < line.endCoordinate.x) {
          x++;
        }

        if (line.startCoordinate.y > line.endCoordinate.y) {
          y--;
        } else if (line.startCoordinate.y < line.endCoordinate.y) {
          y++;
        }
      }

      heatmap[line.endCoordinate.y][line.endCoordinate.x]++;
    }

    return heatmap;
  }

  int get overlapCount {
    return heatmap
        .expand((element) => element)
        .where((element) => element > 1)
        .length;
  }
}

main() {
  final input = VentInput.fromFile('input.txt');
  final map = VentMap(input);
  print('overlap count of map is ${map.overlapCount}');
}
