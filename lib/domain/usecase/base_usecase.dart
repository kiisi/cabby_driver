import 'package:cabby_driver/data/network/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
