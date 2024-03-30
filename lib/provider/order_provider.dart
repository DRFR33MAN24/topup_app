import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/data/model/response/order_model.dart';
import 'package:giftme/data/model/response/response_model.dart';
import 'package:giftme/data/repository/order_repo.dart';
import 'package:giftme/helper/api_checker.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepo? orderRepo;

  OrderProvider({required this.orderRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Order> _ordersList = [];
  List<Order> get ordersList => _ordersList;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];
  List<String> get offsetList => _offsetList;

  Future<void> getOrdersList(String offset, String? date,
      {bool reload = false}) async {
    _isLoading = true;
    if (reload) {
      _offsetList = [];
      _ordersList = [];
    }
    if (!_offsetList.contains(offset.toString())) {
      _offsetList.add(offset.toString());
      ApiResponse apiResponse =
          await orderRepo!.getLatestOrdersList(offset, date!);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _ordersList
            .addAll(OrderModel.fromJson(apiResponse.response!.data).orders!);
        _pageSize = OrderModel.fromJson(apiResponse.response!.data).totalSize;

        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<ResponseModel> placeOrder(
      String serviceId, Map<String, String> fields, String token) async {
    _isLoading = true;
    notifyListeners();

//check if user have enough credits!
    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.placeOrder(serviceId, fields, token);
    _isLoading = false;

    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];

      responseModel = ResponseModel(message, true);
      if (kDebugMode) {
        print(message);
      }

      //start socket connection to server and subscribe to order status update channel
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }

      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }
}
