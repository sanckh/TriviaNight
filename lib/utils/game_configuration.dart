class GameConfiguration {
  int numPlayers;
  int winningPoints;
  List<int> playerScores = [0];
  int currentPlayer = 0;

  GameConfiguration(this.numPlayers, this.winningPoints) {
    this.playerScores = List.filled(numPlayers, 0);
    this.currentPlayer = 0;
  }
}
