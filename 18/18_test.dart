import 'package:test/test.dart';
import '18.dart';

main() {
  test('parses snailfish numbers', () {
    var number = SnailfishNumber.fromString('[1, 2]');
    expect(number.toString(), '[1,2]');

    number = SnailfishNumber.fromString('[[1,2],3]');
    expect(number.toString(), '[[1,2],3]');
  });

  test('explodes right', () {
    final number = SnailfishNumber.fromString('[[[[[1,2],3],4],5],6]');
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,5],4],5],6]');
  });

  test('explodes left', () {
    final number = SnailfishNumber.fromString('[1,[2,[3,[4,[5,6]]]]]');
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[1,[2,[3,[9,0]]]]');
  });

  test('adds snailfish numbers', () {
    final left = SnailfishNumber.fromList([1, 2]);
    final right = SnailfishNumber.fromList([
      [3, 4],
      5
    ]);

    final actual = left + right;
    expect(actual.left!.left!.value, 1);
    expect(actual.right!.right!.value, 5);
  });

  test('adds and reduces numbers', () {
    final numbers = [
      SnailfishNumber.fromString('[1,1]'),
      SnailfishNumber.fromString('[2,2]'),
      SnailfishNumber.fromString('[3,3]'),
      SnailfishNumber.fromString('[4,4]'),
    ];

    final sum = numbers.reduce((acc, e) => acc + e);
    expect(sum.toString(), '[[[[1,1],[2,2]],[3,3]],[4,4]]');
  });

  test('adds and reduces numbers', () {
    final numbers = [
      SnailfishNumber.fromString('[1,1]'),
      SnailfishNumber.fromString('[2,2]'),
      SnailfishNumber.fromString('[3,3]'),
      SnailfishNumber.fromString('[4,4]'),
      SnailfishNumber.fromString('[5,5]'),
    ];

    final sum = numbers.reduce((acc, e) => acc + e);
    expect(sum.toString(), '[[[[3,0],[5,3]],[4,4]],[5,5]]');
  });

  test('adds and reduces numbers', () {
    final numbers = [
      SnailfishNumber.fromString('[1,1]'),
      SnailfishNumber.fromString('[2,2]'),
      SnailfishNumber.fromString('[3,3]'),
      SnailfishNumber.fromString('[4,4]'),
      SnailfishNumber.fromString('[5,5]'),
      SnailfishNumber.fromString('[6,6]'),
    ];

    final sum = numbers.reduce((acc, e) => acc + e);
    expect(sum.toString(), '[[[[5,0],[7,4]],[5,5]],[6,6]]');
  });

  test('adds and reduces more complex numbers', () {
    final number1 = SnailfishNumber.fromString(
        '[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]');
    final number2 = SnailfishNumber.fromString('[2,9]');
    final sum = number1 + number2;
    expect(sum.toString(), '[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]');
  });

  test('adds and reduces more complex numbers', () {
    final numbers = [
      SnailfishNumber.fromString('[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]'),
      SnailfishNumber.fromString('[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]'),
      SnailfishNumber.fromString('[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]'),
      SnailfishNumber.fromString(
          '[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]'),
      SnailfishNumber.fromString('[7,[5,[[3,8],[1,4]]]]'),
      SnailfishNumber.fromString('[[2,[2,2]],[8,[8,1]]]'),
      SnailfishNumber.fromString('[2,9]'),
      SnailfishNumber.fromString('[1,[[[9,3],9],[[9,0],[0,7]]]]'),
      SnailfishNumber.fromString('[[[5,[7,4]],7],1]'),
      SnailfishNumber.fromString('[[[[4,2],2],6],[8,7]]')
    ];

    final sum = numbers.reduce((acc, e) => acc + e);
    expect(sum.toString(),
        '[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]');
  });

  test('computes depth', () {
    final number = SnailfishNumber.fromString('[[1, 2],[[3, 4],5]]');
    expect(number.depth, 0);
    expect(number.left!.depth, 1);
    expect(number.right!.left!.left!.depth, 3);
  });

  group('next adjacent value', () {
    test('finds next left value', () {
      final number = SnailfishNumber.fromString('[[1, 2],[3, 4]]');
      final targetNumber = number.right!.left!;
      expect(targetNumber.value!, 3);
      expect(targetNumber.nextLeftValue!.value, 2);
    });
  });

  test('explodes once', () {
    final number = SnailfishNumber.fromString('[[[[[9,8],1],2],3],4]');

    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,9],2],3],4]');
  });

  test('splits and explodes', () {
    final number =
        SnailfishNumber.fromString('[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]');

    // explodes to
    // [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,7],4],[7,[[8,4],9]]],[1,1]]');

    // explodes to
    // [[[[0,7],4],[15,[0,13]]],[1,1]]
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,7],4],[15,[0,13]]],[1,1]]');

    // after split:
    // [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,7],4],[[7,8],[0,13]]],[1,1]]');

    // after split:
    // [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]');

    // after explode:
    // [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
    SnailfishNumber.reduceOneStep(number);
    expect(number.toString(), '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]');
  });

  test('computes magnitude', () {
    expect(
        SnailfishNumber.magnitude(
            SnailfishNumber.fromString('[[1,2],[[3,4],5]]')),
        143);
    expect(
        SnailfishNumber.magnitude(
            SnailfishNumber.fromString('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')),
        1384);
    expect(
        SnailfishNumber.magnitude(
            SnailfishNumber.fromString('[[[[1,1],[2,2]],[3,3]],[4,4]]')),
        445);
    expect(
        SnailfishNumber.magnitude(
            SnailfishNumber.fromString('[[[[3,0],[5,3]],[4,4]],[5,5]]')),
        791);
    expect(
        SnailfishNumber.magnitude(
            SnailfishNumber.fromString('[[[[5,0],[7,4]],[5,5]],[6,6]]')),
        1137);
    expect(
        SnailfishNumber.magnitude(SnailfishNumber.fromString(
            '[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]')),
        3488);
  });

  test('largestMagnitudeSumOfTwoNumbers', () {
    final numbers = [
      SnailfishNumber.fromString(
          '[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]'),
      SnailfishNumber.fromString('[[[5,[2,8]],4],[5,[[9,9],0]]]'),
      SnailfishNumber.fromString('[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]'),
      SnailfishNumber.fromString('[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]'),
      SnailfishNumber.fromString('[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]'),
      SnailfishNumber.fromString('[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]'),
      SnailfishNumber.fromString('[[[[5,4],[7,7]],8],[[8,3],8]]'),
      SnailfishNumber.fromString('[[9,3],[[9,9],[6,[4,9]]]]'),
      SnailfishNumber.fromString('[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]'),
      SnailfishNumber.fromString('[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]'),
    ];

    expect(largestMagnitudeSumOfTwoNumbers(numbers), 3993);
  });
}
