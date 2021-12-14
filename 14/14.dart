import 'dart:io';

import 'dart:math';

class LetterMap {
  Map<String, int> pairCounts = {};
  Map<String, int> letterCounts = {};
}

class Input {
  late final String template;
  late final Map<String, String> patternsMap;

  Input(String string) {
    final lines = string
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    template = lines.removeAt(0);
    final patterns = <String, String>{};
    lines
        .map((e) => e.split('->'))
        .forEach((e) => patterns[e[0].trim()] = e[1].trim());
    patternsMap = patterns;
  }

  String expand(String input) {
    final buffer = StringBuffer();
    for (var i = 0; i < input.length - 1; i++) {
      final pair = [input[i], input[i + 1]].join();
      buffer.write(input[i]);
      if (patternsMap.containsKey(pair)) {
        buffer.write(patternsMap[pair]);
      }
    }

    buffer.write(input[input.length - 1]);

    return buffer.toString();
  }

  // For Part 2, [expand] wasn't fast enough
  LetterMap stringToCountsMap(String string) {
    var letterMap = LetterMap();
    for (final pattern in patternsMap.keys) {
      letterMap.pairCounts[pattern] = 0;
      letterMap.letterCounts[pattern[0]] = 0;
      letterMap.letterCounts[pattern[1]] = 0;
    }

    for (var i = 0; i < string.length - 1; i++) {
      final pair = [string[i], string[i + 1]].join();
      letterMap.letterCounts[string[i]] =
          letterMap.letterCounts[string[i]]! + 1;
      letterMap.pairCounts[pair] = letterMap.pairCounts[pair] ?? 0;
      if (string.contains(pair)) {
        letterMap.pairCounts[pair] = letterMap.pairCounts[pair]! + 1;
      }
    }

    letterMap.letterCounts[string[string.length - 1]] =
        letterMap.letterCounts[string[string.length - 1]]! + 1;

    return letterMap;
  }

  LetterMap expandCountsMap(LetterMap letterMap) {
    var newPairCountsMap = Map<String, int>.from(letterMap.pairCounts);
    var newLetterCountsMap = Map<String, int>.from(letterMap.letterCounts);
    for (final patternMapEntry in patternsMap.entries) {
      newPairCountsMap[patternMapEntry.key] =
          newPairCountsMap[patternMapEntry.key] ?? 0;

      final oldVal = letterMap.pairCounts[patternMapEntry.key];
      if (oldVal == null || oldVal == 0) continue;

      newPairCountsMap[patternMapEntry.key] =
          newPairCountsMap[patternMapEntry.key]! - oldVal;

      final newKey = patternMapEntry.key[0] + patternMapEntry.value;
      final newKey2 = patternMapEntry.value + patternMapEntry.key[1];
      newPairCountsMap[newKey] = (newPairCountsMap[newKey] ?? 0) + oldVal;
      newPairCountsMap[newKey2] = (newPairCountsMap[newKey2] ?? 0) + oldVal;
      newLetterCountsMap[patternMapEntry.value] =
          newLetterCountsMap[patternMapEntry.value]! + oldVal;
    }

    return LetterMap()
      ..letterCounts = newLetterCountsMap
      ..pairCounts = newPairCountsMap;
  }

  Map<String, int> characterCountsFromMap(Map<String, int> map) {
    var characterCounts = <String, int>{};
    for (final entry in map.entries) {
      final chars = entry.key.split('');
      characterCounts.putIfAbsent(chars[0], () => 0);
      characterCounts.putIfAbsent(chars[1], () => 0);
      characterCounts[chars[0]] = characterCounts[chars[0]]! + entry.value;
      characterCounts[chars[1]] = characterCounts[chars[1]]! + entry.value;
    }
    return characterCounts;
  }

  Map<String, int> characterCounts(String string) {
    var counts = Map<String, int>();
    for (final char in string.split('')) {
      if (!counts.containsKey(char)) {
        counts[char] = 0;
      }
      counts[char] = counts[char]! + 1;
    }

    return counts;
  }
}

main() {
  // Part 1
  final input = Input(File('input.txt').readAsLinesSync().join('\n'));
  var string = input.template;
  for (int i = 0; i < 10; i++) {
    string = input.expand(string);
  }
  var counts = input.characterCounts(string);
  print(counts);

  // Part 1 with part 2 logic
  var map = input.stringToCountsMap(input.template);
  for (int i = 0; i < 10; i++) {
    map = input.expandCountsMap(map);
  }
  print('${map.letterCounts}');

  // Part 2
  map = input.stringToCountsMap(input.template);
  for (int i = 0; i < 40; i++) {
    map = input.expandCountsMap(map);
  }
  print('${map.letterCounts}');
  var maxLetter;
  var maxCount = 0;
  for (final entry in map.letterCounts.entries) {
    if (entry.value > maxCount) {
      maxCount = entry.value;
      maxLetter = entry.key;
    }
  }

  print('highest count: ${maxLetter}: ${maxCount}');

  var minLetter;
  var minCount = 5246955808499000;
  for (final entry in map.letterCounts.entries) {
    if (entry.value < minCount) {
      minCount = entry.value;
      minLetter = entry.key;
    }
  }
  print('lowest count: ${minLetter}: ${minCount}');
  print('diff: ${maxCount - minCount}');
}
