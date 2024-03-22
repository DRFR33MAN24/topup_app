import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/data/datasource/remote/exception/api_error_handler.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/util/app_constants.dart';

class StyleRepo {
  final DioClient? dioClient;
  StyleRepo({required this.dioClient});

  Future<ApiResponse> getLatestStyleList(String offset, String tag) async {
    try {
      final response = await dioClient!
          .get(AppConstants.latestStyles + offset + '&&tag=${tag}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTagsList() async {
    try {
      final response = await dioClient!.get(AppConstants.stylesTags);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
