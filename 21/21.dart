import 'dart:math';

import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

/// The die rolls from 1 to 100.
Iterable<int> dieRolls() sync* {
  int num = 0;
  while (true) yield (num++ % 100) + 1;
}

/// Players move from positions 1 through 10.
Iterable<int> playerPosition(int starting) sync* {
  // Provided position is 1-based, convert to 0-based
  starting--;

  while (true) yield (starting++ % 10) + 1;
}

/// Game object for Part 1
class Game {
  static const rollsPerTurn = 3;

  int get player1Position => _player1Movement.current;
  int get player2Position => _player2Movement.current;
  bool get isWon => player1Score >= 1000 || player2Score >= 1000;
  int get numDieRolls => turn * rollsPerTurn;

  int turn = 0;
  int player1Score = 0;
  int player2Score = 0;

  late Iterator<int> _dieRolls = dieRolls().iterator..moveNext();
  late Iterator<int> _player1Movement;
  late Iterator<int> _player2Movement;

  Game({
    required int player1StartingPosition,
    required int player2StartingPosition,
  }) {
    _player1Movement = playerPosition(player1StartingPosition).iterator
      ..moveNext();
    _player2Movement = playerPosition(player2StartingPosition).iterator
      ..moveNext();
  }

  void nextTurn() {
    final isPlayer1Turn = turn % 2 == 0;
    final rolls = _dieRolls.takeAndAdvance(rollsPerTurn);
    final moves = rolls.toList().sum;
    if (isPlayer1Turn) {
      _player1Movement.takeAndAdvance(moves);
      player1Score += player1Position;
    } else {
      _player2Movement.takeAndAdvance(moves);
      player2Score += player2Position;
    }

    turn++;
  }
}

/// A single player's position and score
typedef PositionScore = Tuple2<int, int>;

/// Game object for Part 2
class QuantumGame {
  static const int winningScore = 21;

  // Possible 3d3 values
  final rollValues = [
    3, // (1,1,1)
    4, 4, 4, // (1,1,2),(1,2,1),(2,1,1)
    5, 5, 5, 5, 5, 5, // etc.
    6, 6, 6, 6, 6, 6, 6, //
    7, 7, 7, 7, 7, 7, //
    8, 8, 8, // (3,3,2),(3,2,3),(2,3,3)
    9, // (3,3,3)
  ];

  Map<PositionScore, int> player1States = {};
  Map<PositionScore, int> player2States = {};

  var player1OpenGames = 1;
  var player2OpenGames = 1;

  var player1Wins = 0;
  var player2Wins = 0;

  var turn = 0;

  QuantumGame({
    required int player1StartingPosition,
    required int player2StartingPosition,
  }) {
    player1States[PositionScore(player1StartingPosition, 0)] = 1;
    player2States[PositionScore(player2StartingPosition, 0)] = 1;
  }

  void playAllToCompletion() {
    while (player1OpenGames > 0 && player2OpenGames > 0) {
      playNextTurn();
    }
  }

  void playNextTurn() {
    final isPlayer1Turn = turn % 2 == 0;

    final currentPositionScoreCounts =
        isPlayer1Turn ? player1States : player2States;

    Map<PositionScore, int> nextPositionScoreCount = {};
    var winsThisTurn = 0;
    var openGamesThisTurn = 0;

    // for every possible 3d3 roll
    for (final entry in currentPositionScoreCounts.entries) {
      final positionScore = entry.key;
      final count = entry.value;
      for (final roll in rollValues) {
        final newPosition = (positionScore.item1 + roll - 1) % 10 + 1;
        final newScore = positionScore.item2 + newPosition;
        final newPositionScore = PositionScore(newPosition, newScore);

        if (newScore >= winningScore) {
          winsThisTurn += count;
        } else {
          openGamesThisTurn += count;
          nextPositionScoreCount[newPositionScore] =
              (nextPositionScoreCount[newPositionScore] ?? 0) + count;
        }
      }
    }

    if (isPlayer1Turn) {
      player1States = nextPositionScoreCount;
      player1OpenGames = openGamesThisTurn;

      // Player 1 wins against every open Player 2 game
      player1Wins += winsThisTurn * player2OpenGames;
    } else {
      player2States = nextPositionScoreCount;
      player2OpenGames = openGamesThisTurn;

      // See player1Wins
      player2Wins += winsThisTurn * player1OpenGames;
    }

    turn++;
  }
}

main() {
  // Part 1
  final game = Game(player1StartingPosition: 8, player2StartingPosition: 7);
  while (!game.isWon) game.nextTurn();
  final losingScore = min(game.player1Score, game.player2Score);
  final scoreTimesNumDieRolls = losingScore * game.numDieRolls;
  print('score times num die rolls is $scoreTimesNumDieRolls');

  // Part 2
  final qGame =
      QuantumGame(player1StartingPosition: 8, player2StartingPosition: 7);
  qGame.playAllToCompletion();
  print('player 1 won ${qGame.player1Wins}, player 2 won ${qGame.player2Wins}');
}

extension Day15<T> on Iterator<T> {
  Iterable<T> takeAndAdvance(int n) {
    var ret = <T>[];
    for (int i = 0; i < n; i++) {
      ret.add(current);
      moveNext();
    }

    return ret;
  }
}
