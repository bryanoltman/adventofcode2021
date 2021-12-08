import 'dart:io';

final numSegmentsForDigits = {
  0: 6,
  1: 2,
  2: 5,
  3: 5,
  4: 4,
  5: 5,
  6: 6,
  7: 3,
  8: 7,
  9: 6,
};

final numSegmentsToDigits = {
  1: [],
  2: [1],
  3: [7],
  4: [4],
  5: [2, 3, 5],
  6: [0, 6, 9],
  7: [8],
};

class InputLine {
  late final List<String> inputs;
  late final List<String> outputs;

  InputLine(String raw) {
    final parts = raw.split('|');
    inputs = parts[0].split(' ').where((e) => e.isNotEmpty).toList();
    outputs = parts[1].split(' ').where((e) => e.isNotEmpty).toList();
  }
}

main() {
  final lines = File('input.txt').readAsLinesSync().map((e) => InputLine(e));
  const lengths1478 = [2, 3, 4, 7];
  final outputs1478 = lines
      .map((e) => e.outputs)
      .expand((e) => e)
      .where((e) => lengths1478.contains(e.length));
  print(outputs1478.length);
}
