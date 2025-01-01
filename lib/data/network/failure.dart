import 'package:cabby_driver/data/network/network_exceptions.dart';

class Failure {
  int statusCode;
  String message;

  Failure({required this.statusCode, required this.message});
}

class FailureExceptionHandler implements Exception {
  late Failure failure;

  FailureExceptionHandler.handle(dynamic error) {
    failure = Failure(
      statusCode: NetworkExceptions.getDioStatus(error),
      message: NetworkExceptions.getErrorMessage(
        NetworkExceptions.getDioException(error),
      ),
    );
  }
}
