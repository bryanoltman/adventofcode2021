import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

int characterToBinary(String character) => character == '.' ? 0 : 1;

class ImageInput {
  late List<int> enhancementBits;
  late List<List<int>> imageMap;

  ImageInput.fromLines(List<String> string) {
    enhancementBits =
        string[0].trim().split('').map(characterToBinary).toList();
    imageMap = string
        .slice(1)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.split('').map(characterToBinary).toList())
        .toList();
  }

  static int bitAtPoint(List<List<int>> image, Point<int> point) {
    if (point.x < 0 || point.x >= image[0].length) return 0;
    if (point.y < 0 || point.y >= image.length) return 0;
    return image[point.y][point.x];
  }

  /// 3x3 grid of neighboring bits, with 0s if the neighbors are outside the
  /// bounds of [imageMap].
  static List<List<int>> neighborBits(List<List<int>> grid, Point<int> point) {
    return [
      [
        bitAtPoint(grid, Point(point.x - 1, point.y - 1)),
        bitAtPoint(grid, Point(point.x, point.y - 1)),
        bitAtPoint(grid, Point(point.x + 1, point.y - 1)),
      ],
      [
        bitAtPoint(grid, Point(point.x - 1, point.y)),
        bitAtPoint(grid, Point(point.x, point.y)),
        bitAtPoint(grid, Point(point.x + 1, point.y)),
      ],
      [
        bitAtPoint(grid, Point(point.x - 1, point.y + 1)),
        bitAtPoint(grid, Point(point.x, point.y + 1)),
        bitAtPoint(grid, Point(point.x + 1, point.y + 1)),
      ],
    ];
  }

  static List<List<int>> padImage(
    List<List<int>> image, {
    int expandBy = 1,
    int background = 0,
  }) {
    var expanded = <List<int>>[];
    for (int i = 0; i < expandBy; i++) {
      expanded.add(List.filled(image[0].length + expandBy * 2, background));
    }
    for (int y = expandBy; y < image.length + expandBy; y++) {
      expanded.add(List.filled(image[0].length + expandBy * 2, background));
      for (int x = expandBy; x < image[0].length + expandBy; x++) {
        expanded[y][x] = image[y - expandBy][x - expandBy];
      }
    }

    for (int i = 0; i < expandBy; i++) {
      expanded.add(List.filled(image[0].length + expandBy * 2, background));
    }
    return expanded;
  }

  static List<List<int>> cropImage(
    List<List<int>> image, {
    required int cropBy,
  }) =>
      image
          .map((e) => e.slice(cropBy, e.length - cropBy).toList())
          .toList()
          .slice(cropBy, image.length - cropBy)
          .toList();

  List<List<int>> enhanceImage(
    List<List<int>> image, {
    int enhancements = 1,
  }) {
    var enhanced = padImage(image, expandBy: 0);
    int background = 0;
    for (int i = 0; i < enhancements; i++) {
      int newBackgroundIndex = int.parse(
          List.filled(9, background.toRadixString(2)).join(),
          radix: 2);
      int newBackground = enhancementBits[newBackgroundIndex];
      var expanded = padImage(
        enhanced,
        background: background,
        expandBy: 3,
      );
      enhanced = padImage(
        enhanced,
        background: newBackground,
        expandBy: 3,
      );
      for (int y = 0; y < expanded.length; y++) {
        for (int x = 0; x < expanded[0].length; x++) {
          final point = Point(x, y);
          final neighbors = neighborBits(expanded, point);
          enhanced[y][x] = enhancementBitForGrid(neighbors);
        }
      }

      enhanced = ImageInput.cropImage(enhanced, cropBy: 2);

      background = newBackground;
    }
    return enhanced;
  }

  static void printImage(List<List<int>> image) {
    final lines =
        image.map((e) => e.map((e) => e == 1 ? '#' : '.').join()).toList();
    for (final line in lines) {
      print(line);
    }
  }

  int enhancementBitForGrid(List<List<int>> grid) {
    final joined = grid.map((e) => e.join()).join();
    final index = int.parse(joined, radix: 2);
    return enhancementBits[index];
  }
}

main() {
  final input = ImageInput.fromLines(File('input.txt').readAsLinesSync());

  // Part 1
  var image = ImageInput.padImage(input.imageMap, expandBy: 0);
  image = input.enhanceImage(image, enhancements: 2);
  var onesCount = image.expand((e) => e).where((e) => e == 1).length;
  print('there are $onesCount lit pixels in the twice-enhanced image');

  // Part 2
  image = ImageInput.padImage(input.imageMap, expandBy: 0);
  image = input.enhanceImage(image, enhancements: 50);
  onesCount = image.expand((e) => e).where((e) => e == 1).length;
  print('there are $onesCount lit pixels in the 50x enhanced image');
}
