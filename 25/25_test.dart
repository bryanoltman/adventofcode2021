import 'package:test/test.dart';
import '25.dart';

const input = '''
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
''';

main() {
  late FloorMap map;

  setUp(() {
    map = parseFloorMap(input.split('\n').toList());
  });

  test('moves a step forward', () {
    final afterOneStep = parseFloorMap('''
      ....>.>v.>
      v.v>.>v.v.
      >v>>..>v..
      >>v>v>.>.v
      .>v.v...v.
      v>>.>vvv..
      ..v...>>..
      vv...>>vv.
      >.v.v..v.v
    '''
        .split('\n'));
    expect(move(map), afterOneStep);
  });

  test('counts moves until equilibrium is reached', () {
    final numSteps = movesUntilSettled(map);
    expect(numSteps, 58);
  });
}
