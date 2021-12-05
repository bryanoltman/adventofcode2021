import 'dart:io';

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

main() {
  final input = VentInput.fromFile('input.txt');
  print(input);
}
