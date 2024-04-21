import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/data/datasource/remote/exception/api_error_handler.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/util/app_constants.dart';

class OrderRepo {
  final DioClient dioClient;
  OrderRepo({required this.dioClient});

  Future<ApiResponse> getLatestOrdersList(String offset, String date) async {
    try {
      final response = await dioClient.get(
          AppConstants.latestOrders + '&&offset=' + offset + '&&date=${date}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> placeOrder(String serviceId, String categoryId,
      Map<String, String> data, String currency, String token) async {
    // File file = File.fromRawPath(img!);
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.placeOrder}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});

    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      '_method': 'post',
      'service': serviceId,
      'category': categoryId,
      'currency': currency
    });

    request.fields.addAll(fields);
    request.fields.addAll(data);

    if (kDebugMode) {
      print('========>${fields.toString()}');
    }
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> placeTransferOrder(
      String phone, String amount, String amountLBP, String token) async {
    // File file = File.fromRawPath(img!);
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.placeTransferOrder}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});

    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      '_method': 'post',
      'phone': phone,
      'amount': amount,
      'amountLBP': amountLBP,
    });

    request.fields.addAll(fields);

    if (kDebugMode) {
      print('========>${fields.toString()}');
    }
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> placeTelecomOrder(String serviceId,
      String categoryId, String quantity, String token) async {
    // File file = File.fromRawPath(img!);
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.placeTelecomOrder}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});

    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      '_method': 'post',
      'service': serviceId,
      'category': categoryId,
      'quantity': quantity
    });

    request.fields.addAll(fields);

    if (kDebugMode) {
      print('========>${fields.toString()}');
    }
    http.StreamedResponse response = await request.send();
    return response;
  }
}
