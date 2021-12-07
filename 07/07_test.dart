import 'package:test/test.dart';
import '07.dart';

main() {
  final input = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14];

  test('finds best point', () {
    expect(findBestPoint(input), 2);
  });

  test('computes distance sum for point', () {
    expect(distanceSumForPoint(input, 2), 37);
    expect(distanceSumForPoint(input, 1), 41);
    expect(distanceSumForPoint(input, 3), 39);
    expect(distanceSumForPoint(input, 10), 71);
  });

  test('finds best point squared', () {
    expect(findBestPointPart2(input), 5);
  });

  test('finds squared distance', () {
    expect(distanceSumForPointPart2(input, 2), 206);
    expect(distanceSumForPointPart2(input, 5), 168);
  });
}
