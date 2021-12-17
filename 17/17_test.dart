import 'dart:math';

import 'package:test/test.dart';
import '17.dart';

main() {
  final input = 'target area: x=20..30, y=-10..-5';
  late Rectangle targetRect;

  setUp(() {
    targetRect = parseTargetString(input);
  });

  test('parses input', () {
    final expectedRect = Rectangle(20, -10, 10, 5);
    expect(targetRect, expectedRect);
  });

  test('produces points when fired and hits target', () {
    final testVelocity = Point(7, -1);
    final points = fireProbe(target: targetRect, velocity: testVelocity);
    expect(targetRect.containsPoint(points.last), true);
  });

  test('produces points when fired and hits target', () {
    final testVelocity = Point(7, 2);
    final points = fireProbe(target: targetRect, velocity: testVelocity);
    expect(points, hasLength(8));
    expect(targetRect.containsPoint(points.last), true);
  });

  test('produces points when fired and hits target', () {
    final testVelocity = Point(6, 3);
    final points = fireProbe(target: targetRect, velocity: testVelocity);
    expect(points, hasLength(10));
    expect(targetRect.containsPoint(points.last), true);
  });

  test('produces points when fired and hits target', () {
    final testVelocity = Point(9, 0);
    final points = fireProbe(target: targetRect, velocity: testVelocity);
    expect(points, hasLength(5));
    expect(targetRect.containsPoint(points.last), true);
  });

  test('produces points when fired and misses target', () {
    final testVelocity = Point(17, -4);
    final points = fireProbe(target: targetRect, velocity: testVelocity);
    expect(points, hasLength(3));
    expect(targetRect.containsPoint(points.last), false);
  });

  test('finds velocity with highest y value', () {
    final bestVelocity = findBestVelocityForTarget(targetRect);
    expect(bestVelocity, Point(6, 9));
  });

  test('finds all hitting velocities', () {
    final allVelocities = findAllHittingVelocities(target: targetRect);
    expect(allVelocities, hasLength(112));
  });
}
