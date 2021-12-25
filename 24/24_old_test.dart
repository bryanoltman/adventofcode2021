import 'package:test/test.dart';
import '24.dart';

main() {
  group(Command, () {
    test('parses with one arg', () {
      final string = 'inp x';
      final command = Command.fromString(string);
      expect(command.operation, Operation.inp);
      expect(command.arg1, 'x');
    });

    test('parses with register args', () {
      final string = 'mul x y';
      final command = Command.fromString(string);
      expect(command.operation, Operation.mul);
      expect(command.arg1, 'x');
      expect(command.arg2, 'y');
      expect(command.arg2IsNumber, false);
    });

    test('parses with register and number args', () {
      final string = 'add z 20';
      final command = Command.fromString(string);
      expect(command.operation, Operation.add);
      expect(command.arg1, 'z');
      expect(command.arg2, '20');
      expect(command.arg2IsNumber, true);
      expect(command.arg2AsNumber, 20);
    });
  });

  group(ALU, () {
    late ALU alu;
    setUp(() {
      alu = ALU();
    });

    test('inp reads values', () {
      alu.input = programInput(123).iterator;
      alu.executeCommand(Command.fromString('inp x'));
      alu.executeCommand(Command.fromString('inp y'));
      alu.executeCommand(Command.fromString('inp z'));
      expect(alu.registers['x'], 1);
      expect(alu.registers['y'], 2);
      expect(alu.registers['z'], 3);
    });

    test('add', () {
      alu.executeCommand(Command.fromString('add x 10'));
      expect(alu.registers['x'], 10);

      alu.executeCommand(Command.fromString('add z 20'));
      expect(alu.registers['z'], 20);

      alu.executeCommand(Command.fromString('add x z'));
      expect(alu.registers['x'], 30);
      expect(alu.registers['z'], 20);
    });

    test('mul', () {
      alu.executeCommand(Command.fromString('mul x 10'));
      expect(alu.registers['x'], 0);

      alu.registers['x'] = 3;

      alu.executeCommand(Command.fromString('mul x 20'));
      expect(alu.registers['x'], 60);
    });

    test('div', () {
      alu.registers['x'] = 3;

      alu.executeCommand(Command.fromString('div x 3'));
      expect(alu.registers['x'], 1);
    });

    test('mod', () {
      alu.registers['x'] = 5;

      alu.executeCommand(Command.fromString('mod x 3'));
      expect(alu.registers['x'], 2);
    });

    test('eql', () {
      alu.registers['x'] = 5;

      alu.executeCommand(Command.fromString('eql x 5'));
      expect(alu.registers['x'], 1);

      alu.executeCommand(Command.fromString('eql x 5'));
      expect(alu.registers['x'], 0);
    });

    group('executeProgram', () {
      test('is second number 3x first', () {
        final input = '''
          inp z
          inp x
          mul z 3
          eql z x
        ''';
        final commands = commandsFromLines(input.split('\n'));
        alu.runProgram(commands, 39);
        expect(alu.registers['z'], 1);

        alu.runProgram(commands, 38);
        expect(alu.registers['z'], 0);
      });
    });

    test('to binary', () {
      final input = '''
          inp w
          add z w
          mod z 2
          div w 2
          add y w
          mod y 2
          div w 2
          add x w
          mod x 2
          div w 2
          mod w 2
      ''';
      final commands = commandsFromLines(input.split('\n'));

      alu.runProgram(commands, 9);
      expect(alu.registers['w'], 1);
      expect(alu.registers['x'], 0);
      expect(alu.registers['y'], 0);
      expect(alu.registers['z'], 1);

      alu.runProgram(commands, 3);
      expect(alu.registers['w'], 0);
      expect(alu.registers['x'], 0);
      expect(alu.registers['y'], 1);
      expect(alu.registers['z'], 1);

      alu.runProgram(commands, 5);
      expect(alu.registers['w'], 0);
      expect(alu.registers['x'], 1);
      expect(alu.registers['y'], 0);
      expect(alu.registers['z'], 1);

      alu.runProgram(commands, 0);
      expect(alu.registers['w'], 0);
      expect(alu.registers['x'], 0);
      expect(alu.registers['y'], 0);
      expect(alu.registers['z'], 0);
    });
  });

  test('isValidMonadNumber', () {
    expect(isValidMonadNumber(1235), false);
    expect(isValidMonadNumber(13579246899999), true);
    expect(isValidMonadNumber(99999999999999), true);
    expect(isValidMonadNumber(99999999990999), false);
    expect(isValidMonadNumber(9999999999999), false);
  });

  test('nextValidMonadNumber', () {
    expect(
      nextValidMonadNumber(9999999999099),
      9999999998999,
    );
  });
}
