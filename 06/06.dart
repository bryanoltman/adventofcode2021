import 'dart:io';

class Lanternfish {
  final int spawnTime;
  int currentCounter;

  Lanternfish({required this.spawnTime, required this.currentCounter});

  Lanternfish? ageOneDay() {
    currentCounter--;
    if (currentCounter < 0) {
      // reset spawn time and create a new fish
      currentCounter = spawnTime;
      return Lanternfish(spawnTime: spawnTime, currentCounter: spawnTime + 2);
    }

    return null;
  }
}

class LanternfishColony {
  List<Lanternfish> fish;

  LanternfishColony(this.fish);

  // Decrement every Laternfish counter by one. Lanternfish whose counter has
  // become negative reset to original counter value and spawn a new fish with
  // a counter of parent's original value + 1.
  List<Lanternfish> moveToNextDay() {
    final newFish =
        fish.map((f) => f.ageOneDay()).whereType<Lanternfish>().toList();
    fish.addAll(newFish);

    return fish;
  }

  List<Lanternfish> moveAhead({required int days}) {
    for (var i = 0; i < days; i++) {
      moveToNextDay();
    }

    return fish;
  }
}

main() {
  final file = File('input.txt');
  final lines = file.readAsLinesSync();
  final fish = lines[0]
      .split(',')
      .map(int.parse)
      .map((e) => Lanternfish(spawnTime: 6, currentCounter: e))
      .toList();
  final colony = LanternfishColony(fish);
  colony.moveAhead(days: 80);
  print(colony.fish.length);
}
