import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/data/datasource/remote/exception/api_error_handler.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/util/app_constants.dart';

class PaymentRepo {
  final DioClient dioClient;
  PaymentRepo({required this.dioClient});

  Future<ApiResponse> getPackages() async {
    try {
      final response = await dioClient.get(AppConstants.packages);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
