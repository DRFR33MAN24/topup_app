import 'package:stylizeit/data/datasource/remote/dio/dio_client.dart';
import 'package:stylizeit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/util/app_constants.dart';

class TransactionRepo {
  final DioClient? dioClient;
  TransactionRepo({required this.dioClient});

  Future<ApiResponse> getTransactionList(String offset) async {
    try {
      final response = await dioClient!.get(AppConstants.transaction + offset);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
