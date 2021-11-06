// Package imports:
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

abstract class Failure implements Exception {
  final String code;
  final String message;

  Failure(this.code, this.message);

  Failure.log(
    this.code,
    this.message,
    Logger logger, [
    Level level = Level.info,
  ]) {
    logger.log(level, '[$code]\n$message');
  }
}

class DioNetworkFailure extends Failure {
  final DioErrorType errorType;

  DioNetworkFailure({
    required String code,
    required String message,
    required this.errorType,
  }) : super(code, message);

  DioNetworkFailure.log({
    required code,
    required message,
    required this.errorType,
    required Logger logger,
    Level level = Level.info,
  }) : super(code, message) {
    logger.log(level, '$message\n Caused by ${errorType.toString()}');
  }
}

class AuthFailure extends Failure {
  AuthFailure({
    required String code,
    required String message,
  }) : super(code, message);

  AuthFailure.log({
    required String code,
    required String message,
    required Logger logger,
    Level level = Level.info,
  }) : super.log(code, message, logger, level);
}

class StatusFailure extends Failure {
  StatusFailure({required String code, required String message})
      : super(code, message);

  StatusFailure.log(
      {required String code,
      required String message,
      required Logger logger,
      level = Level.info})
      : super.log(code, message, logger, level);
}

class RequestFailure extends Failure {
  final Response response;

  RequestFailure({
    required String code,
    required String message,
    required this.response,
  }) : super(code, message);

  RequestFailure.log({
    required String code,
    required String message,
    required this.response,
    required Logger logger,
    Level level = Level.info,
  }) : super(code, message) {
    logger.log(level,
        '$message\nStatus Code: ${response.statusCode}\nResponse Data: ${response.data}');
  }
}

class LobbyNotExistsFailure extends Failure {
  LobbyNotExistsFailure({
    required String code,
    required String message,
  }) : super(code, message);

  LobbyNotExistsFailure.log({
    required code,
    required final message,
    required Logger logger,
    level = Level.info,
  }) : super.log(code, message, logger, level);
}

class FileSizeFailure extends Failure {
  FileSizeFailure({required String code, required String message})
      : super(code, message);

  FileSizeFailure.log({
    required String code,
    required String message,
    required Logger logger,
    level = Level.info,
  }) : super.log(code, message, logger, level);
}

class CacheFailure extends Failure {
  CacheFailure({
    required String code,
    required String message,
  }) : super(code, message);

  CacheFailure.log({
    required String code,
    required String message,
    required Logger logger,
    level = Level.info,
  }) : super.log(code, message, logger, level);
}

class PadrinconiaFailure extends Failure {
  PadrinconiaFailure({
    required String code,
    required String message,
  }) : super(code, message);

  PadrinconiaFailure.log({
    required String code,
    required String message,
    required Logger logger,
    level = Level.info,
  }) : super(code, message) {
    logger.log(level, 'Errore di padrinconia: $message');
  }
}
