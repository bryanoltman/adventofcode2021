import 'package:test/test.dart';
import '10.dart';

main() {
  test('finds first illegal character', () {
    expect(firstIllegalCharacter('{([(<{}[<>[]}>{[]{[(<()>'), '}');
    expect(firstIllegalCharacter('[[<[([]))<([[{}[[()]]]'), ')');
    expect(firstIllegalCharacter('[{[{({}]{}}([{[{{{}}([]'), ']');
    expect(firstIllegalCharacter('[<(<(<(<{}))><([]([]()'), ')');
    expect(firstIllegalCharacter('<{([([[(<>()){}]>(<<{{'), '>');
  });

  test('scores brackets', () {
    final missingBrackets = [
      firstIllegalCharacter('{([(<{}[<>[]}>{[]{[(<()>'), // '}');
      firstIllegalCharacter('[[<[([]))<([[{}[[()]]]'), // ')');
      firstIllegalCharacter('[{[{({}]{}}([{[{{{}}([]'), // ']');
      firstIllegalCharacter('[<(<(<(<{}))><([]([]()'), //')');
      firstIllegalCharacter('<{([([[(<>()){}]>(<<{{'), // '>');
    ];

    expect(scoreMissingBrackets(missingBrackets), 26397);
  });

  test('completes missing lines', () {
    expect(missingClosingString('[({(<(())[]>[[{[]{<()<>>'), '}}]])})]');
    expect(missingClosingString('[(()[<>])]({[<{<<[]>>('), ')}>]})');
    expect(missingClosingString('(((({<>}<{<{<>}{[]{[]{}'), '}}>}>))))');
    expect(missingClosingString('{<[[]]>}<{[{[{[]{()[[[]'), ']]}}]}]}>');
    expect(missingClosingString('<{([{{}}[<[[[<>{}]]]>[]]'), '])}>');
  });

  test('scores line completions', () {
    expect(scoreCompletionString('}}]])})]'), 288957);
    expect(scoreCompletionString(')}>]})'), 5566);
    expect(scoreCompletionString('}}>}>))))'), 1480781);
    expect(scoreCompletionString(']]}}]}]}>'), 995444);
    expect(scoreCompletionString('])}>'), 294);
  });

  test('getMiddleElement', () {
    expect([1, 2, 3].getMiddleElement(), 2);
  });
}
