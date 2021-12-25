Iterable<int> programInput(int number) sync* {
  final digits = number.toString().split('').map(int.parse);
  for (final digit in digits) yield digit;
}

main() {
  var zVal = 0;
  for (int d0 = 9; d0 > 0; d0--) {
    for (int d1 = 9; d1 > 0; d1--) {
      for (int d2 = 3; d2 > 0; d2--) {
        int d3 = d2 + 6;
        for (int d4 = 9; d4 > 0; d4--) {
          for (int d5 = 9; d5 > 0; d5--) {
            for (int d6 = 9; d6 > 0; d6--) {
              // int d6 = d5 + 1;
              for (int d7 = 9; d7 >= 6; d7--) {
                int d8 = d7 - 1;
                for (int d9 = 9; d9 > 0; d9--) {
                  for (int d10 = 9; d10 > 0; d10--) {
                    for (int d11 = 9; d11 > 0; d11--) {
                      // int d10 = 1;
                      // int d11 = 9;
                      for (int d12 = 9; d12 > 0; d12--) {
                        for (int d13 = 9; d13 > 0; d13--) {
                          var strVal = [
                            d0,
                            d1,
                            d2,
                            d3,
                            d4,
                            d5,
                            d6,
                            d7,
                            d8,
                            d9,
                            d10,
                            d11,
                            d12,
                            d13,
                          ].map((e) => e.toString()).join().padRight(14, '1');
                          if (strVal.contains('0')) continue;
                          final val = int.parse(strVal.padRight(14, '1'));
                          zVal = execute(val);
                          if (zVal == 0) {
                            print('$strVal resulted in $zVal');
                            // break;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
// main() {
//   var zVal = 0;
  // for (int d0 = 1; d0 < 10; d0++) {
  //   for (int d1 = 1; d1 < 10; d1++) {
  //     for (int d2 = 1; d2 <= 3; d2++) {
  //       int d3 = d2 + 6;

  //       for (int d4 = 1; d4 < 10; d4++) {
  //         for (int d5 = 1; d5 < 10; d5++) {
  //           int d6 = d5 + 1;
  //           for (int d7 = 6; d7 < 10; d7++) {
  //             for (int d8 = 1; d8 < 10; d8++) {
  //               // int d8 = d7 - 1;
  //               for (int d9 = 1; d9 < 10; d9++) {
  //                 for (int d10 = 1; d10 < 10; d10++) {
  //                   for (int d11 = 1; d11 < 10; d11++) {
  //                     //   int d10 = 1;
  //                     //   int d11 = 9;
  //                     for (int d12 = 1; d12 < 10; d12++) {
  //                       for (int d13 = 1; d13 < 10; d13++) {
  //                         var strVal = [
  //                           d0,
  //                           d1,
  //                           d2,
  //                           d3,
  //                           d4,
  //                           d5,
  //                           d6,
  //                           d7,
  //                           d8,
  //                           d9,
  //                           d10,
  //                           d11,
  //                           d12,
  //                           d13,
  //                         ].map((e) => e.toString()).join().padRight(14, '1');
  //                         if (strVal.contains('0')) continue;
  //                         final val = int.parse(strVal.padRight(14, '1'));
  //                         zVal = execute(val);
  //                         if (zVal == 0) {
  //                           print('$strVal resulted in $zVal');
  //                           // print('$d7 $d8 $d9 resulted in $zVal');
  //                           // break;
  //                         }
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  // }
}

int execute(int value) {
  final input = programInput(value).iterator;

  int w = 0;
  int z = 0;

  // 0
  input.moveNext();
  w = input.current;

  z = w + 6;

  // 1
  input.moveNext();
  w = input.current;

  z = (z * 26) + w + 14;

  // 2
  input.moveNext();
  w = input.current;

  z = (z * 26) + w + 14;

  // 3
  input.moveNext();
  w = input.current;

  if ((z % 26) - 8 == w) {
    z = z ~/ 26;
  } else {
    z = (z ~/ 26) * 26 + w + 10;
  }

  // 4
  input.moveNext();
  w = input.current;

  z = z * 26 + w + 9;

  // 5
  input.moveNext();
  w = input.current;

  z = z * 26 + w + 12;

  // 6
  input.moveNext();
  w = input.current;

  if ((z % 26) - 11 == w) {
    z = z ~/ 26;
  } else {
    z = (z ~/ 26) * 26 + w + 8;
  }

  // 7
  input.moveNext();
  w = input.current;

  if ((z % 26) - 4 == w) {
    z = z ~/ 26;
  } else {
    return -1;
    z = (z ~/ 26) * 26 + w + 13;
  }

  // 8
  input.moveNext();
  w = input.current;

  if ((z % 26) - 15 == w) {
    z = z ~/ 26;
  } else {
    z = (z ~/ 26) * 26 + 12 + w;
  }

  // 9
  input.moveNext();
  w = input.current;

  z = z * 26 + 6 + w;

  // 10
  input.moveNext();
  w = input.current;

  z = z * 26 + 9 + w;

  // 11
  input.moveNext();
  w = input.current;

  if ((z % 26) - 1 == w) {
    z = z ~/ 26;
  } else {
    z = (z ~/ 26) * 26 + w + 15;
  }

  input.moveNext();
  w = input.current;

  if ((z % 26) - 8 == w) {
    z = z ~/ 26;
  } else {
    z = (z ~/ 26) * 26 + 4 + w;
  }

  input.moveNext();
  w = input.current;

  // z mod 26 - 14 must be w
  if ((z % 26) - 14 == w) {
    // z must be < 26 for this to be 0
    z = z ~/ 26;
  } else {
    z = (z ~/ 26) * 26 + 10 + w;
  }

  return z;
}
