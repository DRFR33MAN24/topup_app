import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/data/datasource/remote/exception/api_error_handler.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/util/app_constants.dart';

class CategoryRepo {
  final DioClient? dioClient;
  CategoryRepo({required this.dioClient});

  Future<ApiResponse> getLatestCategoryList(
      String offset, String tag, String search) async {
    try {
      final response = await dioClient!.get(AppConstants.latestCategories +
          '&&offset=' +
          offset +
          '&&tag=${tag}' +
          '&&search=${search}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTagsList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoriesTags);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
