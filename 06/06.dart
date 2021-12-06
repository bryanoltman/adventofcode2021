import 'dart:io';

class LanternfishColony {
  List<int> fish;
  LanternfishColony(this.fish);

  List<int> moveToNextDay() {
    int newFish = 0;
    for (int i = 0; i < fish.length; i++) {
      if (fish[i] == 0) {
        fish[i] = 6;
        newFish++;
      } else {
        fish[i]--;
      }
    }

    for (var i = 0; i < newFish; i++) {
      fish.add(8);
    }

    return fish;
  }

  List<int> moveAhead({required int days}) {
    for (var i = 0; i < days; i++) {
      final currentFish = moveToNextDay();
      print('day $i: $currentFish');
    }

    return fish;
  }
}

main() {
  final file = File('input.txt');
  final lines = file.readAsLinesSync();
  final fish = lines[0].split(',').map(int.parse).toList();
  final colony = LanternfishColony(fish);
  colony.moveAhead(days: 10);
  print(colony.fish.length);
}
