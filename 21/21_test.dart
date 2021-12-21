import 'package:test/test.dart';
import '21.dart';

main() {
  group(Game, () {
    late Game game;
    setUp(() {
      game = Game(player1StartingPosition: 4, player2StartingPosition: 8);
    });

    test('initializes with correct positions', () {
      expect(game.player1Position, 4);
      expect(game.player2Position, 8);
    });

    test('advances turns', () {
      game.nextTurn();
      // rolls 1 + 2 + 3 = 6, 6 + (current position) 4 = 10
      expect(game.player1Position, 10);
      expect(game.player1Score, 10);

      game.nextTurn();
      // rolls 4 + 5 + 6 = 15 + (current position) 8 = 23
      expect(game.player2Position, 3);
      expect(game.player2Score, 3);

      game.nextTurn();
      expect(game.player1Score, 14);

      game.nextTurn();
      expect(game.player2Score, 9);

      game.nextTurn();
      expect(game.player1Score, 20);

      game.nextTurn();
      expect(game.player2Score, 16);

      game.nextTurn();
      expect(game.player1Score, 26);

      game.nextTurn();
      expect(game.player2Score, 22);
    });

    test('plays to finish', () {
      while (!game.isWon) game.nextTurn();
      expect(game.player1Score, 1000);
      expect(game.player2Score, 745);
    });
  });

  group('Iterator extensions', () {
    test('moveNext(n)', () {
      final rolls = dieRolls().iterator..moveNext();
      expect(rolls.takeAndAdvance(3), [1, 2, 3]);
      expect(rolls.takeAndAdvance(3), [4, 5, 6]);
    });
  });

  group(QuantumGame, () {
    test('plays to completion', () {
      final qGame = QuantumGame(
        player1StartingPosition: 4,
        player2StartingPosition: 8,
      );
      qGame.playAllToCompletion();
      expect(qGame.player1Wins, 444356092776315);
      expect(qGame.player2Wins, 341960390180808);
    });
  });
}
