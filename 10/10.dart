import 'dart:io';

import 'package:collection/collection.dart';

const bracketsMap = {
  '[': ']',
  '{': '}',
  '<': '>',
  '(': ')',
};

const bracketsPoints = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137,
};

/// Returns the first non-matching brace
String? firstIllegalCharacter(String bracketsString) {
  var bracketsStack = <String>[];
  for (String character in bracketsString.split('')) {
    if (bracketsMap.containsKey(character)) {
      bracketsStack.add(bracketsMap[character]!);
      continue;
    }

    final expectedClosingBracket = bracketsStack.removeLast();
    if (character == expectedClosingBracket) continue;
    return character;
  }
}

int scoreMissingBrackets(Iterable<String?> brackets) =>
    brackets.whereType<String>().map((e) => bracketsPoints[e]!).sum;

String? missingClosingString(String bracketsString) {
  var bracketsStack = <String>[];
  for (String character in bracketsString.split('')) {
    if (bracketsMap.containsKey(character)) {
      bracketsStack.add(bracketsMap[character]!);
      continue;
    }
    final expectedClosingBracket = bracketsStack.removeLast();
    if (character != expectedClosingBracket) {
      return null;
      // throw Exception('expected $expectedClosingBracket, found $character');
    }
  }

  return bracketsStack.reversed.join();
}

int scoreCompletionString(String? string) {
  if (string == null) return 0;

  const pointIncreases = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
  };

  var score = 0;
  for (final character in string.split('')) {
    score *= 5;
    score += pointIncreases[character]!;
  }

  return score;
}

main() {
  final lines = File('input.txt').readAsLinesSync();
  final missingCharacters =
      lines.map(firstIllegalCharacter).whereType<String>();
  print('missing characters sum to ${scoreMissingBrackets(missingCharacters)}');

  final completionStrings = lines
      .map(missingClosingString)
      .whereType<String>()
      .sorted((a, b) =>
          scoreCompletionString(a).compareTo(scoreCompletionString(b)));
  print('middle string is ${completionStrings.getMiddleElement()}');
  print(
      'middle score is ${scoreCompletionString(completionStrings.getMiddleElement())}');
}

extension Middle on List {
  E? getMiddleElement<E>() {
    // Only works on odd lists
    if (length % 2 == 0) return null;

    return this[length ~/ 2];
  }
}
