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

enum DisplaySegment {
  top,
  upperLeft,
  upperRight,
  center,
  lowerLeft,
  lowerRight,
  bottom,
}

final zeroSegments = {
  DisplaySegment.top,
  DisplaySegment.upperLeft,
  DisplaySegment.upperRight,
  DisplaySegment.lowerLeft,
  DisplaySegment.lowerRight,
  DisplaySegment.bottom,
};
final twoSegments = {
  DisplaySegment.top,
  DisplaySegment.upperRight,
  DisplaySegment.center,
  DisplaySegment.lowerLeft,
  DisplaySegment.bottom,
};
final threeSegments = {
  DisplaySegment.top,
  DisplaySegment.upperRight,
  DisplaySegment.center,
  DisplaySegment.lowerRight,
  DisplaySegment.bottom,
};

final fiveSegments = {
  DisplaySegment.top,
  DisplaySegment.upperLeft,
  DisplaySegment.center,
  DisplaySegment.lowerRight,
  DisplaySegment.bottom,
};

final sixSegments = {
  DisplaySegment.top,
  DisplaySegment.upperLeft,
  DisplaySegment.center,
  DisplaySegment.lowerRight,
  DisplaySegment.lowerLeft,
  DisplaySegment.bottom,
};
final nineSegments = {
  DisplaySegment.top,
  DisplaySegment.upperLeft,
  DisplaySegment.upperRight,
  DisplaySegment.center,
  DisplaySegment.lowerRight,
  DisplaySegment.bottom,
};

class InputLine {
  late final List<List<String>> inputs;
  late final List<List<String>> outputs;
  late final Map<DisplaySegment, String> displaySegmentsMap;
  late final Map<String, DisplaySegment> charactersToDisplaySegments;

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
    displaySegmentsMap = displaySegmentMapping;
    charactersToDisplaySegments = {};
    for (final entry in displaySegmentsMap.entries) {
      charactersToDisplaySegments[entry.value] = entry.key;
    }
  }

  /// Determines which characters map to which display segment
  Map<DisplaySegment, String> get displaySegmentMapping {
    const allDigits = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];
    var mapping = <DisplaySegment, String>{};
    final oneDigits = inputs.firstWhere((e) => e.length == 2);
    final fourDigits = inputs.firstWhere((e) => e.length == 4);
    final sevenDigits = inputs.firstWhere((e) => e.length == 3);
    final rightDigits = oneDigits;

    final topDigit = sevenDigits.firstWhere((e) => !oneDigits.contains(e));
    mapping[DisplaySegment.top] = topDigit;

    // 0, 6, 9
    final sixSegmentDigits =
        inputs.where((e) => e.length == numSegmentsForDigits[6]);

    // Only 6 is missing a digit that is present in 1
    final sixDigits =
        sixSegmentDigits.firstWhere((e) => !e.containsAll(rightDigits));

    final upperRightCharacter = rightDigits.firstWhere((e) {
      return !sixDigits.join().contains(e);
    });
    mapping[DisplaySegment.upperRight] = upperRightCharacter;
    final lowerRightCharacter =
        rightDigits.firstWhere((e) => e != upperRightCharacter);
    mapping[DisplaySegment.lowerRight] = lowerRightCharacter;

    // The bottom left digit is the only one not shared between 4 and 0,6,9
    final nineAndZeroDigits =
        sixSegmentDigits.where((e) => e.contains(upperRightCharacter)).toList();

    // 9 has all missing a digit that is present in 4
    final nineDigits = nineAndZeroDigits.firstWhere((digits) {
      return digits.containsAll(fourDigits);
    });
    final lowerLeftDigit = allDigits.firstWhere((e) => !nineDigits.contains(e));
    mapping[DisplaySegment.lowerLeft] = lowerLeftDigit;

    // Now we can identify which is 0
    final zeroDigits =
        nineAndZeroDigits.firstWhere((e) => e.contains(lowerLeftDigit));

    // 6 and 0 are only missing one segment, ID those
    final centerDigit = allDigits.firstWhere((e) => !zeroDigits.contains(e));
    mapping[DisplaySegment.center] = centerDigit;

    // 2, 3, 5
    final fiveDigitSegments = inputs.where((e) => e.length == 5);

    // 2 and 3 both contain 6's missing segment, isolate 5 based on that
    final fiveDigits =
        fiveDigitSegments.firstWhere((e) => sixDigits.containsAll(e));

    final twoAndThreeDigits = fiveDigitSegments.where((e) => e != fiveDigits);
    // 3 is missing a lower left segment
    final threeDigits =
        twoAndThreeDigits.firstWhere((e) => !e.contains(lowerLeftDigit));
    final upperLeftDigit = allDigits
        .firstWhere((e) => e != lowerLeftDigit && !threeDigits.contains(e));
    mapping[DisplaySegment.upperLeft] = upperLeftDigit;

    // We've ID'd all but the bottom
    mapping[DisplaySegment.bottom] =
        allDigits.firstWhere((e) => !mapping.values.contains(e));

    return mapping;
  }

  // Set<DisplaySegment> _codesToSet(List<String> codes) {
  //   return codes.map((e) => charactersToDisplaySegments[e]!).toSet();
  // }

  int numberForCharacterCode(String code) {
    if (code.length == 2) return 1;
    if (code.length == 3) return 7;
    if (code.length == 4) return 4;
    if (code.length == 7) return 8;

    final segments = code.split('').map((e) => charactersToDisplaySegments[e]!);
    if (segments.containsExactly(zeroSegments)) return 0;
    if (segments.containsExactly(twoSegments)) return 2;
    if (segments.containsExactly(threeSegments)) return 3;
    if (segments.containsExactly(fiveSegments)) return 5;
    if (segments.containsExactly(sixSegments)) return 6;
    if (segments.containsExactly(nineSegments)) return 9;

    throw FallThroughError();
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
