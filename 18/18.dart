import 'dart:convert';

import 'dart:io';

class SnailfishNumber {
  SnailfishNumber? parent;

  // If this is not a leaf
  SnailfishNumber? left;
  SnailfishNumber? right;

  // If this is a leaf
  int? value;

  SnailfishNumber() {}

  factory SnailfishNumber.fromString(String string) =>
      SnailfishNumber.fromList(json.decode(string));

  SnailfishNumber.fromValue(this.value);

  SnailfishNumber.fromList(List<dynamic> list) {
    if (list[0] is int) {
      left = SnailfishNumber.fromValue(list[0])..parent = this;
    } else {
      left = SnailfishNumber.fromList(list[0])..parent = this;
    }

    if (list[1] is int) {
      right = SnailfishNumber.fromValue(list[1])..parent = this;
    } else {
      right = SnailfishNumber.fromList(list[1])..parent = this;
    }
  }

  SnailfishNumber operator +(SnailfishNumber other) {
    final newLeft = SnailfishNumber.fromString(this.toString());
    final newRight = SnailfishNumber.fromString(other.toString());
    final newNumber = SnailfishNumber()
      ..left = newLeft
      ..right = newRight;
    newLeft.parent = newNumber;
    newRight.parent = newNumber;

    while (SnailfishNumber.reduceOneStep(newNumber)) {}
    return newNumber;
  }

  int get depth {
    int ancestorCount = 0;
    var node = this;
    while (node.parent != null) {
      ancestorCount++;
      node = node.parent!;
    }
    return ancestorCount;
  }

  bool get shouldExplode => value == null && depth >= 4;

  bool get shouldSplit => (value ?? 0) >= 10;

  static List<SnailfishNumber> allValues(SnailfishNumber number) {
    if (number.value != null) return [number];
    return allValues(number.left!) + allValues(number.right!);
  }

  SnailfishNumber root(SnailfishNumber number) {
    if (number.parent == null) return number;
    return root(number.parent!);
  }

  SnailfishNumber? get nextLeftValue {
    final starting = value == null ? left! : this;
    final values = allValues(root(this));
    final thisIndex = values.indexOf(starting);
    if (thisIndex == 0) return null;
    return values[thisIndex - 1];
  }

  SnailfishNumber? get nextRightValue {
    final starting = value == null ? right! : this;
    final values = allValues(root(this));
    final thisIndex = values.indexOf(starting);
    if (thisIndex == values.length - 1) return null;
    return values[thisIndex + 1];
  }

  void split() {
    final newLeftValue = ((value!).toDouble() / 2.0).floor();
    final newRightValue = ((value!).toDouble() / 2.0).ceil();
    left = SnailfishNumber.fromValue(newLeftValue)..parent = this;
    right = SnailfishNumber.fromValue(newRightValue)..parent = this;
    value = null;
  }

  void explode() {
    final nextLeft = nextLeftValue;
    if (nextLeft != null) {
      nextLeft.value = nextLeft.value! + left!.value!;
    }

    final nextRight = nextRightValue;
    if (nextRight != null) {
      nextRight.value = nextRight.value! + right!.value!;
    }

    final isLeft = parent!.left == this;
    if (isLeft) {
      parent!.left = SnailfishNumber.fromValue(0)..parent = parent;
    } else {
      parent!.right = SnailfishNumber.fromValue(0)..parent = parent;
    }
  }

  static bool explodeOneStep(SnailfishNumber number) {
    if (number.shouldExplode) {
      number.explode();
      return true;
    }

    if (number.value != null) {
      return false;
    }

    return explodeOneStep(number.left!) || explodeOneStep(number.right!);
  }

  static bool splitOneStep(SnailfishNumber number) {
    if (number.shouldSplit) {
      number.split();
      return true;
    }

    if (number.value != null) {
      return false;
    }

    return splitOneStep(number.left!) || splitOneStep(number.right!);
  }

  static bool reduceOneStep(SnailfishNumber number) {
    return explodeOneStep(number) || splitOneStep(number);
  }

  static int magnitude(SnailfishNumber number) {
    if (number.value != null) {
      return number.value!;
    }

    return 3 * magnitude(number.left!) + 2 * magnitude(number.right!);
  }

  @override
  String toString() {
    if (value != null) return value.toString();
    return '[${left!.toString()},${right!.toString()}]';
  }
}

int largestMagnitudeSumOfTwoNumbers(List<SnailfishNumber> numbers) {
  int largestMagnitude = 0;
  for (int i = 0; i < numbers.length; i++) {
    for (int j = 0; j < numbers.length; j++) {
      final currentSum = numbers[i] + numbers[j];
      final currentMagnitude = SnailfishNumber.magnitude(currentSum);
      if (currentMagnitude > largestMagnitude) {
        largestMagnitude = currentMagnitude;
      }
    }
  }

  return largestMagnitude;
}

main() {
  // Part 1
  final numbers = File('input.txt')
      .readAsLinesSync()
      .map(SnailfishNumber.fromString)
      .toList();
  final sum = numbers.reduce((acc, e) => acc + e);
  print('sum is $sum');
  final magnitude = SnailfishNumber.magnitude(sum);
  print('magnitude is $magnitude');

  // Part 2
  int largestMagnitude = largestMagnitudeSumOfTwoNumbers(numbers);
  print('largest magnitude from adding any two numbers is $largestMagnitude');
}
