import 'package:test/test.dart';
import '06.dart';

main() {
  final initialCounts = [3, 4, 3, 1, 2];

  group(LanternfishColony, () {
    late LanternfishColony colony;
    setUp(() {
      colony = LanternfishColony(initialCounts);
    });

    test('moves ahead by many more days', () {
      colony.moveAhead(days: 256);
      int length = 0;
      for (var i = 0; i < 9; i++) {
        length += colony.fishAtDays[i]!;
      }
      expect(length, 26984457539);
    });
  });
}
