import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/repository/activity_repo.dart';
import 'package:cabby_driver/data/request/activity_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:cabby_driver/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ActivityUsecase implements BaseUseCase<SetOnlineStatusRequest, BaseResponse<SetOnlineStatusResponse>> {
  final ActivityRepository _activityRepository;

  ActivityUsecase(this._activityRepository);

  @override
  Future<Either<Failure, BaseResponse<SetOnlineStatusResponse>>> execute(SetOnlineStatusRequest input) async {
    return await _activityRepository.setOnlineStatus(input);
  }
}
