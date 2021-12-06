import 'package:test/test.dart';
import '06.dart';

main() {
  final initialCounts = [3, 4, 3, 1, 2];

  group(LanternfishColony, () {
    late LanternfishColony colony;
    setUp(() {
      colony = LanternfishColony(initialCounts);
    });

    test('moves to next day', () {
      colony.moveToNextDay();
      expect(colony.fish, [2, 3, 2, 0, 1]);
    });

    test('moves to next day', () {
      colony.moveToNextDay();
      expect(colony.fish, [2, 3, 2, 0, 1]);
    });

    test('moves ahead by multiple days', () {
      expect(colony.moveAhead(days: 1), [2, 3, 2, 0, 1]);
      expect(colony.moveAhead(days: 1), [1, 2, 1, 6, 0, 8]);
      expect(colony.moveAhead(days: 1), [0, 1, 0, 5, 6, 7, 8]);
      expect(colony.moveAhead(days: 1), [6, 0, 6, 4, 5, 6, 7, 8, 8]);
      expect(colony.moveAhead(days: 1), [5, 6, 5, 3, 4, 5, 6, 7, 7, 8]);
      expect(colony.moveAhead(days: 1), [4, 5, 4, 2, 3, 4, 5, 6, 6, 7]);
      expect(colony.moveAhead(days: 1), [3, 4, 3, 1, 2, 3, 4, 5, 5, 6]);
      expect(colony.moveAhead(days: 1), [2, 3, 2, 0, 1, 2, 3, 4, 4, 5]);
      expect(colony.moveAhead(days: 1), [1, 2, 1, 6, 0, 1, 2, 3, 3, 4, 8]);
      expect(colony.moveAhead(days: 1), [0, 1, 0, 5, 6, 0, 1, 2, 2, 3, 7, 8]);
      expect(colony.moveAhead(days: 1),
          [6, 0, 6, 4, 5, 6, 0, 1, 1, 2, 6, 7, 8, 8, 8]);
      expect(colony.moveAhead(days: 1),
          [5, 6, 5, 3, 4, 5, 6, 0, 0, 1, 5, 6, 7, 7, 7, 8, 8]);
      expect(colony.moveAhead(days: 1),
          [4, 5, 4, 2, 3, 4, 5, 6, 6, 0, 4, 5, 6, 6, 6, 7, 7, 8, 8]);
      expect(colony.moveAhead(days: 1),
          [3, 4, 3, 1, 2, 3, 4, 5, 5, 6, 3, 4, 5, 5, 5, 6, 6, 7, 7, 8]);
      expect(colony.moveAhead(days: 1),
          [2, 3, 2, 0, 1, 2, 3, 4, 4, 5, 2, 3, 4, 4, 4, 5, 5, 6, 6, 7]);
      expect(colony.moveAhead(days: 1),
          [1, 2, 1, 6, 0, 1, 2, 3, 3, 4, 1, 2, 3, 3, 3, 4, 4, 5, 5, 6, 8]);
      expect(colony.moveAhead(days: 1),
          [0, 1, 0, 5, 6, 0, 1, 2, 2, 3, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 7, 8]);
      expect(colony.moveAhead(days: 1), [
        6,
        0,
        6,
        4,
        5,
        6,
        0,
        1,
        1,
        2,
        6,
        0,
        1,
        1,
        1,
        2,
        2,
        3,
        3,
        4,
        6,
        7,
        8,
        8,
        8,
        8
      ]);
    });

    test('moves ahead by many more days', () {
      colony.moveAhead(days: 256);
      expect(colony.fish, hasLength(26984457539));
    });
  });
}
