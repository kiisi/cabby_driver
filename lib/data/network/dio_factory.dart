import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/core/common/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String applicationJson = "application/json";
const String contentType = "Content-Type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    const Duration timeout = Duration(milliseconds: 15 * 1000);
    String language = "en";

    Map<String, dynamic>? headers = {
      contentType: applicationJson,
      accept: applicationJson,
      defaultLanguage: language
    };

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.uri.toString().contains('api.cloudinary.com')) {
          options.headers.remove("Authorization");
        } else {
          String accessToken = await _appPreferences.getAccessToken();
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options);
      },
    ));

    dio.options = BaseOptions(
      baseUrl: Constant.baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      headers: headers,
    );

    if (kReleaseMode) {
    } else {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }

    return dio;
  }
}
