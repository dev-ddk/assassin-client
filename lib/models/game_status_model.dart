enum GameStatus { WAITING, ACTIVE, CANCELED, ABORTED, ENDED }

extension GameStatusGettersAndSetters on GameStatus {
  String get name {
    switch (this) {
      case GameStatus.WAITING:
        return 'WAITING';
      case GameStatus.ACTIVE:
        return 'ACTIVE';
      case GameStatus.CANCELED:
        return 'CANCELED';
      case GameStatus.ABORTED:
        return 'ABORTED';
      case GameStatus.ENDED:
        return 'ENDED';
    }
  }

  static GameStatus? fromString(String string) {
    switch (string) {
      case 'WAITING_FOR_PLAYERS':
        return GameStatus.WAITING;
      case 'ACTIVE':
        return GameStatus.ACTIVE;
      case 'CANCELED':
        return GameStatus.CANCELED;
      case 'ABORTED':
        return GameStatus.ABORTED;
      case 'ENDED':
        return GameStatus.ENDED;
      default:
        return null;
    }
  }
}
