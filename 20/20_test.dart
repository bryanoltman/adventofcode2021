import 'dart:math';

import 'package:collection/collection.dart';
import 'package:test/test.dart';
import '20.dart';

final input =
    '''..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

       #..#.
       #....
       ##..#
       ..#..
       ..###
       ''';

main() {
  late ImageInput imageInput;
  setUp(() {
    imageInput = ImageInput.fromLines(input.split('\n'));
  });

  test('parses input', () {
    expect(imageInput.imageMap, hasLength(5));
    expect(imageInput.enhancementBits, hasLength(512));
    expect(imageInput.enhancementBits.slice(0, 5), [0, 0, 1, 0, 1]);
  });

  test('gets neighbor bits', () {
    expect(ImageInput.neighborBits(imageInput.imageMap, Point<int>(0, 0)), [
      [0, 0, 0],
      [0, 1, 0],
      [0, 1, 0]
    ]);

    expect(ImageInput.neighborBits(imageInput.imageMap, Point<int>(2, 2)), [
      [0, 0, 0],
      [1, 0, 0],
      [0, 1, 0]
    ]);

    expect(ImageInput.neighborBits(imageInput.imageMap, Point<int>(4, 4)), [
      [0, 0, 0],
      [1, 1, 0],
      [0, 0, 0]
    ]);
  });

  test('gets enhancement bit from grid', () {
    final grid = [
      [0, 0, 0],
      [1, 0, 0],
      [0, 1, 0]
    ];
    expect(imageInput.enhancementBitForGrid(grid), 1);

    expect(
      imageInput.enhancementBitForGrid(
          ImageInput.neighborBits(imageInput.imageMap, Point<int>(2, 2))),
      1,
    );
  });

  test('crops image', () {
    final grid = [
      [0, 0, 0],
      [1, 0, 0],
      [0, 1, 0]
    ];
    expect(ImageInput.cropImage(grid, cropBy: 1), [
      [0]
    ]);
  });

  test('enhances image', () {
    final expectedImage = [
      [0, 1, 1, 0, 1, 1, 0],
      [1, 0, 0, 1, 0, 1, 0],
      [1, 1, 0, 1, 0, 0, 1],
      [1, 1, 1, 1, 0, 0, 1],
      [0, 1, 0, 0, 1, 1, 0],
      [0, 0, 1, 1, 0, 0, 1],
      [0, 0, 0, 1, 0, 1, 0]
    ];
    var enhanced = imageInput.enhanceImage(imageInput.imageMap);
    expect(enhanced, expectedImage);
    final twiceEnhanced = imageInput.enhanceImage(
      imageInput.imageMap,
      enhancements: 2,
    );
    expect(twiceEnhanced.expand((e) => e).where((e) => e == 1).length, 35);
  });
}
