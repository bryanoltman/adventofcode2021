import 'dart:io';

class LanternfishColony {
  LanternfishColony(List<int> fish) {
    for (final f in fish) {
      fishAtDays[f] = fishAtDays[f]! + 1;
    }
  }

  Map<int, int> fishAtDays = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
  };

  void moveToNextDay() {
    // get the number of new fish we need to make
    final numFishReproducing = fishAtDays[0]!;

    // Increment existing fish to next day
    for (int i = 0; i < 8; i++) {
      fishAtDays[i] = fishAtDays[i + 1]!;
    }

    // Add new fish
    fishAtDays[8] = numFishReproducing;

    // Reset reproduced fish
    fishAtDays[6] = fishAtDays[6]! + numFishReproducing;
  }

  void moveAhead({required int days}) {
    for (var i = 0; i < days; i++) {
      moveToNextDay();
    }
  }
}

main() {
  final file = File('input.txt');
  final lines = file.readAsLinesSync();
  final fish = lines[0].split(',').map(int.parse).toList();
  final colony = LanternfishColony(fish);
  colony.moveAhead(days: 256);
  int length = 0;
  for (var i = 0; i < 9; i++) {
    length += colony.fishAtDays[i]!;
  }
  print(length);
}
