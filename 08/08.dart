import 'dart:io';

class InputLine {
  static const allDigits = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

  late final List<List<String>> inputs;
  late final List<List<String>> outputs;
  late final Map<List<String>, int> characterSetsToNumbers;

  InputLine(String raw) {
    final parts = raw.split('|');
    inputs = parts[0]
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e.split(''))
        .toList();
    outputs = parts[1]
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e.split(''))
        .toList();
    characterSetsToNumbers = mapStringsToNumbers();
  }

  Map<List<String>, int> mapStringsToNumbers() {
    var mapping = <List<String>, int>{};

    mapping[allDigits] = 8;

    final oneDigits = inputs.firstWhere((e) => e.length == 2);
    mapping[oneDigits] = 1;

    final fourDigits = inputs.firstWhere((e) => e.length == 4);
    mapping[fourDigits] = 4;

    final sevenDigits = inputs.firstWhere((e) => e.length == 3);
    mapping[sevenDigits] = 7;

    final rightDigits = oneDigits;

    // 0, 6, 9
    final sixSegmentDigits = inputs.where((e) => e.length == 6);

    // Only 6 is missing a digit that is present in 1
    final sixDigits =
        sixSegmentDigits.firstWhere((e) => !e.containsAll(rightDigits));
    mapping[sixDigits] = 6;

    final upperRightCharacter = rightDigits.firstWhere((e) {
      return !sixDigits.join().contains(e);
    });

    // The bottom left digit is the only one not shared between 4 and 0,6,9
    final nineAndZeroDigits =
        sixSegmentDigits.where((e) => e.contains(upperRightCharacter)).toList();

    // 9 has all missing a digit that is present in 4
    final nineDigits = nineAndZeroDigits.firstWhere((digits) {
      return digits.containsAll(fourDigits);
    });
    mapping[nineDigits] = 9;
    final lowerLeftDigit = allDigits.firstWhere((e) => !nineDigits.contains(e));

    // Now we can identify which is 0
    final zeroDigits = nineAndZeroDigits.firstWhere((e) => e != nineDigits);
    mapping[zeroDigits] = 0;

    // 2, 3, 5
    final fiveDigitSegments = inputs.where((e) => e.length == 5);

    // 2 and 3 both contain 6's missing segment, isolate 5 based on that
    final fiveDigits =
        fiveDigitSegments.firstWhere((e) => sixDigits.containsAll(e));
    mapping[fiveDigits] = 5;

    final twoAndThreeDigits = fiveDigitSegments.where((e) => e != fiveDigits);
    // 3 is missing a lower left segment
    final threeDigits =
        twoAndThreeDigits.firstWhere((e) => !e.contains(lowerLeftDigit));
    mapping[threeDigits] = 3;

    final twoDigits = twoAndThreeDigits.firstWhere((e) => e != threeDigits);
    mapping[twoDigits] = 2;

    return mapping;
  }

  int numberForCharacterCode(String code) {
    final codeParts = code.split('');
    final codeKey = characterSetsToNumbers.keys
        .firstWhere((k) => k.containsExactly(codeParts));
    return characterSetsToNumbers[codeKey]!;
  }

  int get outputValue {
    final outputDigits = outputs
        .map((e) => e.join())
        .map((e) => numberForCharacterCode(e))
        .toList();
    var value = 0;
    value += outputDigits[0] * 1000;
    value += outputDigits[1] * 100;
    value += outputDigits[2] * 10;
    value += outputDigits[3] * 1;
    return value;
  }
}

main() {
  final lines =
      File('input.txt').readAsLinesSync().map((e) => InputLine(e)).toList();
  const lengths1478 = [2, 3, 4, 7];
  final outputs1478 = lines
      .map((e) => e.outputs)
      .expand((e) => e)
      .where((e) => lengths1478.contains(e.length));
  print(outputs1478.length);

  final outputSum = lines
      .map((e) => e.outputValue)
      .reduce((value, element) => value + element);
  print(outputSum);
}

extension ContainsAll on Iterable {
  bool containsAll(Iterable<Object> objects) {
    for (final object in objects) {
      if (!contains(object)) return false;
    }
    return true;
  }
}

extension ContainsExactly on Iterable {
  bool containsExactly(Iterable<Object> objects) {
    if (length != objects.length) return false;
    return containsAll(objects);
  }
}
