// inp a - Read an input value and write it to variable a.
// add a b - Add the value of a to the value of b, then store the result in variable a.
// mul a b - Multiply the value of a by the value of b, then store the result in variable a.
// div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
// mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
// eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.

import 'dart:io';
import 'dart:math';

enum Operation { inp, add, mul, div, mod, eql }

class Command {
  late Operation operation;

  /// Always a register
  late String arg1;

  /// Can be register or number
  late String arg2;

  bool get arg2IsNumber => int.tryParse(arg2) != null;

  int get arg2AsNumber => int.parse(arg2);

  Command.fromString(String string) {
    final parts = string.split(' ');
    operation = Operation.values
        .firstWhere((e) => e.toString().split('.').last == parts[0]);
    arg1 = parts[1];
    if (operation == Operation.inp) {
      arg2 = '';
    } else {
      arg2 = parts[2];
    }
  }
}

Iterable<Command> commandsFromLines(List<String> lines) => lines
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .map(Command.fromString);

Iterable<int> programInput(int number) sync* {
  final digits = number.toString().split('').map(int.parse);
  for (final digit in digits) yield digit;
}

class ALU {
  var registers = <String, int>{
    'w': 0,
    'x': 0,
    'y': 0,
    'z': 0,
  };

  Iterator<int> input = programInput(0).iterator;

  void reset() {
    for (final key in registers.keys) {
      registers[key] = 0;
    }
  }

  void executeCommand(Command command) {
    final int arg2Val;
    if (command.operation == Operation.inp) {
      input.moveNext();
      arg2Val = input.current;
    } else if (command.arg2IsNumber) {
      arg2Val = command.arg2AsNumber;
    } else {
      arg2Val = registers[command.arg2]!;
    }

    switch (command.operation) {
      case Operation.inp:
        registers[command.arg1] = arg2Val;
        break;
      case Operation.add:
        registers[command.arg1] = registers[command.arg1]! + arg2Val;
        break;
      case Operation.mul:
        registers[command.arg1] = registers[command.arg1]! * arg2Val;
        break;
      case Operation.div:
        registers[command.arg1] = registers[command.arg1]! ~/ arg2Val;
        break;
      case Operation.mod:
        registers[command.arg1] = registers[command.arg1]! % arg2Val;
        break;
      case Operation.eql:
        registers[command.arg1] = registers[command.arg1]! == arg2Val ? 1 : 0;
        break;
    }
  }

  void runProgram(Iterable<Command> commands, int inputValue) {
    reset();
    input = programInput(inputValue).iterator;
    for (final command in commands) {
      executeCommand(command);
    }
  }

  int runCompiledProgram(int inputValue) {
    input = programInput(inputValue).iterator;
    int w = 0;
    int x = 0;
    int y = 0;
    int z = 0;

    // input[0]
    input.moveNext();
    w = input.current;

    int maybeX = 1;
    int maybeY = w + 6;
    int maybeZ = w + 6;

    x *= 0;
    x += z;
    x %= 26;
    x += 11;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 6;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[1]
    input.moveNext();
    w = input.current;

    maybeY = w + 14;
    maybeZ = (maybeZ * 26) + w + 14;

    // x = (z % 26 + 13 == w) ? 0 :1

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 1;
    x += 13;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y; // z *= 26
    y *= 0;
    y += w;
    y += 14;
    y *= x;
    z += y; // z += w + 14

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[2]
    input.moveNext();
    w = input.current;

    maybeY = w + 14;
    maybeZ = maybeZ * 26 + maybeY;

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 1;
    x += 15;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1; // y = 26
    z *= y;
    y *= 0;
    y += w;
    y += 14;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[3]
    input.moveNext();
    w = input.current;

    if (z % 26 - 8 == w) {
      maybeX = 0;
      maybeZ = maybeZ ~/ 26;
      maybeY = 0;
    } else {
      maybeX = 1;
      maybeY = w + 10;
      maybeZ = (maybeZ - maybeZ % 26) + maybeY;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -8;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 10;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[4]
    input.moveNext();
    w = input.current;

    maybeX = 1;
    maybeY = w + 9;
    maybeZ = maybeZ * 26 + maybeY;

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 1;
    x += 13;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 9;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[5]
    input.moveNext();
    w = input.current;

    maybeY = w + 12;
    maybeZ = maybeZ * 26 + w + 12;

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 1;
    x += 15;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 12;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[6]
    input.moveNext();
    w = input.current;

    maybeX = 1;
    maybeY = w + 8;
    maybeZ = (maybeZ - maybeZ % 26) + maybeY;

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -11;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 8;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[7]
    input.moveNext();
    w = input.current;

    if (z % 26 - 4 == w) {
      print('hit input[7]');
      print('w:$w');
      print('input:$inputValue');
      maybeZ ~/= 26;
      maybeY = 0;
      maybeX = 0;
    } else {
      maybeX = 1;
      maybeY = w + 13;
      maybeZ = (maybeZ - maybeZ % 26) + maybeY;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -4;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 13;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[8]
    input.moveNext();
    w = input.current;

    if (z % 26 - 15 == w) {
      // print('hit input[8]');
      // print('w:$w');
      // print('input:$inputValue');
      maybeZ ~/= 26;
      maybeY = 0;
      maybeX = 0;
    } else {
      maybeX = 1;
      maybeY = w + 12;
      maybeZ = (maybeZ - maybeZ % 26) + maybeY;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -15;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 12;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[9]
    input.moveNext();
    w = input.current;

    // if (z % 26 + 14 == w) {
    //   print('w: $w');
    //   print(inputValue);
    //   print('asdf');
    //   maybeZ ~/= 26;
    //   maybeX = 0;
    //   maybeY = 0;
    // } else {
    maybeX = 1;
    maybeY = w + 6;
    maybeZ = maybeZ * 26 + w + 6;
    // }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 1;
    x += 14;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 6;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[10]
    input.moveNext();
    w = input.current;

    if (z % 26 + 14 == w) {
      //   print('w: $w');
      //   print(inputValue);
      //   print('asdf');
      //   maybeZ ~/= 26;
      //   maybeX = 0;
      //   maybeY = 0;
    } else {
      maybeX = 1;
      maybeY = w + 9;
      maybeZ = maybeZ * 26 + w + 9;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 1;
    x += 14;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 9;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[11]
    input.moveNext();
    w = input.current;

    if (z % 26 - 1 == w) {
      // print('hit input[11]');
      // print('w: $w');
      // print(inputValue);
      // print('asdf');
      maybeZ ~/= 26;
      maybeX = 0;
      maybeY = 0;
    } else {
      maybeX = 1;
      maybeY = w + 15;
      maybeZ = (maybeZ - maybeZ % 26) + w + 15;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -1;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 15;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[12]
    input.moveNext();
    w = input.current;

    if (z % 26 - 8 == w) {
      // print('hit input[11]');
      // print('w: $w');
      // print(inputValue);
      // print('asdf');
      maybeZ ~/= 26;
      maybeX = 0;
      maybeY = 0;
    } else {
      maybeX = 1;
      maybeY = w + 4;
      maybeZ = (maybeZ - maybeZ % 26) + w + 4;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -8;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 4;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // input[13]
    input.moveNext();
    w = input.current;

    if (z % 26 - 14 == w) {
      maybeX = 0;
      maybeY = 0;
      maybeZ = maybeZ ~/ 26;
    } else {
      maybeX = 1;
      maybeY = 11;
      maybeZ = (maybeZ - maybeZ % 26) + 11 + w;
    }

    x *= 0;
    x += z;
    x %= 26;
    z ~/= 26;
    x += -14;
    x = x == w ? 1 : 0;
    x = x == 0 ? 1 : 0;
    y *= 0;
    y += 25;
    y *= x;
    y += 1;
    z *= y;
    y *= 0;
    y += w;
    y += 10;
    y *= x;
    z += y;

    if (maybeX != x) {
      throw Exception();
    }
    if (maybeY != y) {
      throw Exception();
    }
    if (maybeZ != z) {
      throw Exception();
    }

    // print(z);
    return z;
  }
}

bool isValidMonadNumber(int number) {
  if (number <= 9999999999999) return false;
  while (number > 0) {
    if (number % 10 == 0) return false;
    number ~/= 10;
  }
  return true;
}

int nextValidMonadNumber(int number) {
  if (isValidMonadNumber(number)) return number - 1;
  int i = 0;
  int trackingNumber = number;
  for (i = 0; trackingNumber > 0; i++) {
    if (trackingNumber % 10 == 0) break;
    trackingNumber ~/= 10;
  }
  final nextNumber = number - pow(10, i).toInt();
  return nextNumber;
}

Future<void> transpile(Iterable<Command> commands) async {
  var lines = <String>[];
  for (final command in commands) {
    final String arg2Val;
    if (command.operation == Operation.inp) {
      arg2Val = '';
    } else if (command.arg2IsNumber) {
      arg2Val = command.arg2AsNumber.toString();
    } else {
      arg2Val = command.arg2;
    }
    switch (command.operation) {
      case Operation.inp:
        lines.add('input.moveNext();');
        lines.add('${command.arg1} = input.current;');
        break;
      case Operation.add:
        lines.add('${command.arg1} += $arg2Val;');
        break;
      case Operation.mul:
        lines.add('${command.arg1} *= $arg2Val;');
        break;
      case Operation.div:
        lines.add('${command.arg1} ~/= $arg2Val;');
        break;
      case Operation.mod:
        lines.add('${command.arg1} %= $arg2Val;');
        break;
      case Operation.eql:
        lines.add('${command.arg1} = ${command.arg1} == $arg2Val ? 1 : 0;');
        break;
    }
  }
  print(lines.join());
  print('done');
}

main() async {
  final commands = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .map(Command.fromString);

  // transpile(commands);

  final alu = ALU();

  // // **..***..**.*.
  // for (int spot3 = 1; spot3 < 10; spot3++) {
  //   for (int spot4 = 1; spot4 < 10; spot4++) {
  //     for (int spot8 = 1; spot8 < 10; spot8++) {
  //       for (int spot9 = 1; spot9 < 10; spot9++) {
  //         for (int spot12 = 1; spot12 < 10; spot12++) {
  //           for (int spot14 = 1; spot14 < 10; spot14++) {
  //             final str =
  //                 '99${spot3}${spot4}999${spot8}${spot9}99${spot12}9${spot14}';
  //             alu.runProgram(commands, int.parse(str));
  //             // final zVal = alu.runCompiledProgram(int.parse(str));
  //             final zVal = alu.registers['z']!;
  //             if (zVal == 0) {
  //               print(str + ':$zVal');
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  // xxx7??????????

  // for (int i = 1; i < 10; i++) {
  //   //                    **..***..**9**
  //   //                    01234567890123
  //   int val = int.parse(('9928111871191' + i.toString()).padRight(14, '1'));
  //   // int val = int.parse(('99399995999' + i.toString()).padRight(14, '1'));
  //   if (!isValidMonadNumber(val)) continue;
  //   // print('checking $val');
  //   alu.runCompiledProgram(val);
  // }

  // alu.runCompiledProgram(99999999999999);
  // alu.runCompiledProgram(89989999999999);
  // alu.runCompiledProgram(79979999999999);
  // alu.runCompiledProgram(69969999999999);
  // alu.runCompiledProgram(59959999999999);
  // alu.runCompiledProgram(49949999999999);
  // alu.runCompiledProgram(39939999999999);
  // alu.runCompiledProgram(29929999999999);
  // alu.runCompiledProgram(19919999999999);

  // alu.runCompiledProgram(11999999999999);
  // alu.runCompiledProgram(12989999999999);
  // alu.runCompiledProgram(12979999999999);
  // alu.runCompiledProgram(14969999999999);
  // alu.runCompiledProgram(15959999999999);
  // alu.runCompiledProgram(16949999999999);
  // alu.runCompiledProgram(17939999999999);
  // alu.runCompiledProgram(18929999999999);
  // alu.runCompiledProgram(19919999999999);

  // alu.runCompiledProgram(99999999999999);
  // alu.runCompiledProgram(99989999999999);
  // alu.runCompiledProgram(99979999999999);
  // alu.runCompiledProgram(99969999999999);
  // alu.runCompiledProgram(99959999999999);
  // alu.runCompiledProgram(99949999999999);
  // alu.runCompiledProgram(99939999999999);
  // alu.runCompiledProgram(99929999999999);
  // alu.runCompiledProgram(99919999999999);

  // alu.runCompiledProgram(99999999999999);
  // alu.runCompiledProgram(99998999999999);
  // alu.runCompiledProgram(99997999999999);
  // alu.runCompiledProgram(99996999999999);
  // alu.runCompiledProgram(99995999999999);
  // alu.runCompiledProgram(99994999999999);
  // alu.runCompiledProgram(99993999999999);
  // alu.runCompiledProgram(99992999999999);
  // alu.runCompiledProgram(99991999999999);

  // alu.runCompiledProgram(33333999999999);
  // alu.runCompiledProgram(33333899999999);
  // alu.runCompiledProgram(33333799999999);
  // alu.runCompiledProgram(33333699999999);
  // alu.runCompiledProgram(33333599999999);
  // alu.runCompiledProgram(33333499999999);
  // alu.runCompiledProgram(33333399999999);
  // alu.runCompiledProgram(33333299999999);
  // alu.runCompiledProgram(33333199999999);

  // alu.runCompiledProgram(22222299999999);
  // alu.runCompiledProgram(22222289999999);
  // alu.runCompiledProgram(22222279999999);
  // alu.runCompiledProgram(22222269999999);
  // alu.runCompiledProgram(22222259999999);
  // alu.runCompiledProgram(22222249999999);
  // alu.runCompiledProgram(22222239999999);
  // alu.runCompiledProgram(22222229999999);
  // alu.runCompiledProgram(22222219999999);

  alu.runProgram(commands, 99999999999999);
  var zReg = alu.registers['z']!;
  assert(zReg == 4916021805);
  alu.runProgram(commands, 11111111111111);
  zReg = alu.registers['z']!;
  assert(zReg == 2345842549);

  int modelNumber;
  // final outfile = File('output').openWrite(mode: FileMode.writeOnlyAppend);
  for (modelNumber = 99999999999999;
      modelNumber > 9999999999999;
      modelNumber = nextValidMonadNumber(modelNumber)) {
    if (modelNumber % 9999 == 0) {
      print('model number: $modelNumber');
      // outfile.flush();
    }
    // final zReg = alu.runCompiledProgram(modelNumber);
    // // outfile.write('$modelNumber\t\t$zReg\n');
    // if (zReg == 0) {
    //   print('module number is $modelNumber for 0 zreg');
    //   break;
    // }
    alu.runProgram(commands, modelNumber);
    var zReg = alu.registers['z']!;
    if (modelNumber == 99999999999999) {
      assert(zReg == 4916021805);
    }
    if (modelNumber == 11111111111111) {
      assert(zReg == 2345842549);
    }
    if (zReg == 0) {
      break;
    }
  }
  // outfile.close;

  print('module number is $modelNumber');
}
