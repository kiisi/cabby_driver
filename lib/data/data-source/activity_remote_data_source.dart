import 'package:cabby_driver/data/network/app_api.dart';
import 'package:cabby_driver/data/request/activity_request.dart';
import 'package:cabby_driver/data/response/response.dart';

abstract interface class ActivityRemoteDataSource {
  Future<BaseResponse<SetOnlineStatusResponse>> setOnlineStatus(
      SetOnlineStatusRequest setOnlineStatusRequest);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final AppServiceClient _appServiceClient;

  ActivityRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<BaseResponse<SetOnlineStatusResponse>> setOnlineStatus(
      SetOnlineStatusRequest setOnlineStatusRequest) async {
    return await _appServiceClient.setOnlineStatus(
        id: setOnlineStatusRequest.id, isOnline: setOnlineStatusRequest.isOnline);
  }
}
