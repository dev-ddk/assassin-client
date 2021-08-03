abstract class Failure implements Exception {}

class NetworkFailure extends Failure {}

class AuthFailure extends Failure {}

class RequestFailure extends Failure {
  final int? statusCode;

  RequestFailure({this.statusCode});
}

class LobbyNotExistsFailure extends Failure {}

class FileSizeFailure extends Failure {}

class CacheFailure extends Failure {}

class PadrinconiaFailure extends Failure {}
