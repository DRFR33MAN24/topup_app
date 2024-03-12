import 'package:stylizeit/data/datasource/remote/dio/dio_client.dart';
import 'package:stylizeit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  void initSharedData() async {
    if (!sharedPreferences!.containsKey(AppConstants.intro)) {
      sharedPreferences!.setBool(AppConstants.intro, true);
    }
  }

  void disableIntro() {
    sharedPreferences!.setBool(AppConstants.intro, false);
  }

  bool? showIntro() {
    return sharedPreferences!.getBool(AppConstants.intro);
  }
}
