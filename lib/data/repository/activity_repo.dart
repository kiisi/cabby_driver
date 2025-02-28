import 'package:cabby_driver/data/data-source/activity_remote_data_source.dart';
import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/request/activity_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dartz/dartz.dart';

abstract interface class ActivityRepository {
  Future<Either<Failure, BaseResponse<SetOnlineStatusResponse>>> setOnlineStatus(
      SetOnlineStatusRequest setOnlineStatusRequest);
}

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource _activityRemoteDataSource;

  ActivityRepositoryImpl(this._activityRemoteDataSource);

  @override
  Future<Either<Failure, BaseResponse<SetOnlineStatusResponse>>> setOnlineStatus(
      SetOnlineStatusRequest setOnlineStatusRequest) async {
    try {
      final response = await _activityRemoteDataSource.setOnlineStatus(setOnlineStatusRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }
}
