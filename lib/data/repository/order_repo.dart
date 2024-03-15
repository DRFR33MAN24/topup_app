import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:stylizeit/data/datasource/remote/dio/dio_client.dart';
import 'package:stylizeit/data/datasource/remote/exception/api_error_handler.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/data/model/response/order_model.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:http/http.dart' as http;

class OrderRepo {
  final DioClient dioClient;
  OrderRepo({required this.dioClient});

  // Future<ApiResponse> placeOrder() async {
  //   try {
  //     final response = await dioClient!.post(
  //       AppConstants.placeOrder,
  //     );
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  Future<http.StreamedResponse> placeOrder(
      String serviceId, String token) async {
    // File file = File.fromRawPath(img!);
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.placeOrder}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});

    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      '_method': 'post',
      'style_id': serviceId,
    });

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('========>${fields.toString()}');
    }
    http.StreamedResponse response = await request.send();
    return response;
  }
}
