import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/data/datasource/remote/exception/api_error_handler.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/util/app_constants.dart';

class TransactionRepo {
  final DioClient? dioClient;
  TransactionRepo({required this.dioClient});

  Future<ApiResponse> getTransactionList(String offset, String date) async {
    try {
      final response = await dioClient!
          .get(AppConstants.transaction + offset + "&&date=" + date);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
